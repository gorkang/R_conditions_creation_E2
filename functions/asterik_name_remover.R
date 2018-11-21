#' This functions eliminate a string among up to three asteriks
#' e.g. ***name**

asterik_name_remover <- function(string)  {
  
  between_asteriks <- "\\*{,3}[a-z_]*\\*{,3}(.*)"
  
  gsub(between_asteriks, "\\1", string)
  
  
}