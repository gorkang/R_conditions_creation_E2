choice_builder <- 
  function(choices_ordinal, response_string) {
    
    # choices_ordinal <- choices[2]
    # response_string <- response_text
    
    if (choices_ordinal == "first") {
      print(gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders("choiches_start", "second_choice", response_string),
                 html_codes$choices_font_size))
      .GlobalEnv$next_next_choice <-
        .GlobalEnv$choices[which(.GlobalEnv$choices %in% choices_ordinal) + 2]
    } else if (!which(.GlobalEnv$choices %in% choices_ordinal) == length(.GlobalEnv$choices)) {
      print(gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders(paste0(choices_ordinal,"_choice"), paste0(next_next_choice, "_choice"), response_string),
                 html_codes$choices_font_size))
      .GlobalEnv$next_next_choice <-
        .GlobalEnv$choices[which(.GlobalEnv$choices %in% choices_ordinal) + 2]
    } else if (which(.GlobalEnv$choices %in% choices_ordinal) == length(.GlobalEnv$choices)) {
      print(gsub("CHOICES_TEXT_TO_FORMAT",
                 extract_between_placeholders(paste0(choices_ordinal,"_choice"), paste0("choices_end"), response_string),
                 html_codes$choices_font_size))
    }
    
  }
