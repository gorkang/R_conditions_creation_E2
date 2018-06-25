# Debug ++++++++++++++++++++++++++
# response_string <- response_text
# x <- choices[2]
# extract_choice_text(x)
  
choice_builder <- 
  function(response_string) {
    
    # secondary function definition +++++++++++++++++++++++++++
    # this is the function that do the actual work. the choice
    # builder is just a wrap-up to iteratively call this func.
    extract_choice_text <- 
      function (x) {
        if (length(choices) == 1) {
          gsub("CHOICES_TEXT_TO_FORMAT",
               extract_between_placeholders("choices_start", "choices_end", response_string),
               html_codes$choices_font_size)
        }  else if (length(choices) < 3) {
          if (x == "first") {
            gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders("choices_start", "second_choice", response_string),
                 html_codes$choices_font_size)
          } else if (x == "second") {
            gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders("second_choice", "choices_end", response_string),
                 html_codes$choices_font_size)
          }
        } else if (length(choices) >= 3) {
          if (x == "first") {
            gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders("choices_start", "second_choice", response_string),
                 html_codes$choices_font_size)
          } else if (!which(choices %in% x) == length(choices)) {
            gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders(paste0(x, "_choice"), paste0(choices[which(choices %in% x) + 1], "_choice"), response_string),
                 html_codes$choices_font_size)
          } else if (which(choices %in% x) == length(choices)) {
            gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders(paste0(x,"_choice"), paste0("choices_end"), response_string),
                 html_codes$choices_font_size)
          }
        }
      }
    
    # arguments for every call ++++++++++++++++++++++++++++++++
    # Possible number of choices 
    ordinal_numbers <- 
      c("second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth")
    # For this particular call ++++++++++++++++++++++++++++++++
    # Number of choices
    choices_number <- 
      (sum(str_detect(pattern = paste0(ordinal_numbers, "_choice"), string = response_string)) + 1)
    # Actual choices
    choices <-
      if (choices_number == 1) {
        c("first")
      } else if (choices_number != 1) {
        c("first", ordinal_numbers[seq(choices_number-1)])
        
      }
    
    # Temp stuff ++++++++++++++++++++++++++++++++++++++++++++++
    # Create a temp copy of choices to be able to check "choices" after manipualted the temp copy
    choices_ordinal <- 
      choices
    
    # Iterative call to extract choice text
    choices_ordinal %>%
      map(~extract_choice_text(.x))
    
  }
