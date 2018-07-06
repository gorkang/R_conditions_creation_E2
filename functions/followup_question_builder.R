followup_question_builder <- function(file_path, file_name, outputdir, export = TRUE) {
  
  # ARGUMENTS
  # file_path <- "materials/Question/Follow_up/input/questions_raw/"
  # file_name <- "followup_question_04.txt"
  
  # path to question
  question_path <- 
    paste0(file_path, file_name)
  # actual question
  question_text <- 
    readChar(question_path, file.info(question_path)$size)
  # choices
  current_choices <- 
    choice_builder(response_string = question_text) %>% 
    unlist
  
  if (export == TRUE) {
    dir.create(outputdir, showWarnings = FALSE, recursive = TRUE)
    
    # ACTUAL FUNCTION
    cat(
      # QUESTION TYPE ********************
      gsub("(\\[\\[.*\\]\\]).*", "\\1", question_text),
      
      # QUESTION ********************
      gsub("QUESTION_TEXT_TO_FORMAT", 
           extract_between_placeholders("question_start", "choices_start", question_text), 
           html_codes$question_font_size),
      
      # CHOICES FORMAT ********************
      qualtrics_codes$question_choices,
      # CHOICES ***************************
      paste(current_choices, collapse = "\n"),
      
      # SEP *******************************
      sep = "\n"
      # FILE TO EXPORT
      , file = paste0(outputdir, file_name)
    )
  } else if (export == FALSE) {
    paste(
      # QUESTION TYPE ********************
      gsub("(\\[\\[.*\\]\\]).*", "\\1", question_text),
      
      # QUESTION ********************
      gsub("QUESTION_TEXT_TO_FORMAT", 
           extract_between_placeholders("question_start", "choices_start", question_text), 
           html_codes$question_font_size),
      
      # CHOICES FORMAT ********************
      qualtrics_codes$question_choices,
      # CHOICES ***************************
      paste(current_choices, collapse = "\n"),
      
      # SEP *******************************
      sep = "\n"
    )
  }
}