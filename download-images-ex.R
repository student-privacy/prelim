library(jsonlite)
library(purrr)

res <- fromJSON("response.json")
img_links <- map(res$result$posts[[12]], "full")

tbl <- tibble::tibble(
  account_id = res$result$posts$account$id,
  account_name = res$result$posts$account$name,
  account_handle = res$result$posts$account$handle,
  post_url = res$result$posts$postUrl,
  message = res$result$posts$message,
  img_url = map_chr(img_links, ~ ifelse(is.null(.x), "", unique(na.omit(.x))))
)

dir.create("imgs")
out_names <- file.path("imgs", paste0(tbl$account_id[1:10], ".jpg"))
walk2(tbl$img_url[1:10], out_names, ~{
  if (.x == "") {
    return()
  } else {
    download.file(.x, .y)
  }
})
