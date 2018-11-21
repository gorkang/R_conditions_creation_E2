# This function extract strings between placeholders with the same form:
# [placeholder_A] string to extract [placeholder_B]

extract_between_placeholders <- function(a, b, string_to_extract) {
  
  # Debug 
  # string_to_extract <- response_text
  # a <- "question_start"
  # b <- "choiches_start"
  
  a_placeholder <- paste0("\\[", a, "\\]")
  b_placeholder <- paste0("\\[", b, "\\]")
  
  placeholder_regex <-
    paste0(".*", a_placeholder, "\\n{,1}(.*)\\n{,1}", b_placeholder, ".*")
  
  gsub(placeholder_regex, "\\1", string_to_extract)
  
}
