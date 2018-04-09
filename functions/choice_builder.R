# This has to be put on the choices part within each question building


# This object are defined once for all future calls. 
# Possible number of choices 
ordinal_numbers <- 
  c("second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth")

# This two are set for the current call
# Number of choices
choices_number <- 
  (sum(str_detect(pattern = paste0(ordinal_numbers, "_choice"), string = response_text)) + 1)
# Actual choices
choices <- 
  c("first", ordinal_numbers[seq(choices_number-1)])


choice_builder <- 
  function(choices_ordinal, response_string) {
    
    choices_ordinal <- 
      choices
    # response_string <- response_text
    
    xxxx <- choices_ordinal %>% 
      map(~custom_xxx(.x)) %>% unlist
    
    x <- choices_ordinal[6]
    
    choices_ordinal %>%
      map(~custom_xxx(.x))
    
    parent.env()
    
    custom_xxx <- 
      function (x) {
      if (length(choices) == 1) {
        gsub("CHOICES_TEXT_TO_FORMAT",
             extract_between_placeholders("choiches_start", "second_choice", response_string),
             html_codes$choices_font_size)
      }  else if (length(choices) < 3) {
        if (x == "first") {
          gsub("CHOICES_TEXT_TO_FORMAT",
               extract_between_placeholders("choiches_start", "second_choice", response_string),
               html_codes$choices_font_size)
        } else if (x == "second") {
          gsub("CHOICES_TEXT_TO_FORMAT",
               extract_between_placeholders("second_choice", "choiches_end", response_string),
               html_codes$choices_font_size)
        }
      } else if (length(choices) >= 3) {
        if (x == "first") {
          .GlobalEnv$counter <- 1
          gsub("CHOICES_TEXT_TO_FORMAT",
               extract_between_placeholders("choiches_start", "second_choice", response_string),
               html_codes$choices_font_size)
        } else if (!which(choices %in% x) == length(choices)) {
          gsub("CHOICES_TEXT_TO_FORMAT",
               extract_between_placeholders(paste0(x, "_choice"), paste0(choices[counter+2], "_choice"), response_string),
               html_codes$choices_font_size)
        } else if (which(choices %in% x) == length(choices)) {
          gsub("CHOICES_TEXT_TO_FORMAT",
               extract_between_placeholders(paste0(x,"_choice"), paste0("choices_end"), response_string),
               html_codes$choices_font_size)
        }
      }
    }
    
    
    
    # print_choices <- function() {
    #   if (choices_ordinal == "first") {
    #     print(gsub("CHOICES_TEXT_TO_FORMAT",
    #                extract_between_placeholders("choiches_start", "second_choice", response_string),
    #                html_codes$choices_font_size))
    #     .GlobalEnv$next_next_choice <-
    #       .GlobalEnv$choices[which(.GlobalEnv$choices %in% choices_ordinal) + 2]
    #   
    #     } else if (!which(.GlobalEnv$choices %in% choices_ordinal) == length(.GlobalEnv$choices)) {
    #     print(gsub("CHOICES_TEXT_TO_FORMAT",
    #                extract_between_placeholders(paste0(choices_ordinal,"_choice"), paste0(next_next_choice, "_choice"), response_string),
    #                html_codes$choices_font_size))
    #     .GlobalEnv$next_next_choice <-
    #       .GlobalEnv$choices[which(.GlobalEnv$choices %in% choices_ordinal) + 2]
    #   } else if (which(.GlobalEnv$choices %in% choices_ordinal) == length(.GlobalEnv$choices)) {
    #     print(gsub("CHOICES_TEXT_TO_FORMAT",
    #                extract_between_placeholders(paste0(choices_ordinal,"_choice"), paste0("choices_end"), response_string),
    #                html_codes$choices_font_size))
    #   }
    #   
    # }
    # 
    # choices_ordinal %>% map(~print_choices(.))
    
    
  }
