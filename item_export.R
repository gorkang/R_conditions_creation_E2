# TODO: create a qualtrics-compatible response type text
# the only response type that is customized (to disease context) is the sequential guided question.
# all the others should be generics.

# Possible option. Create a txt file with each response type in qualtrics-comp format (sg response type will have two files)?
# Keep in mind that all questions, but global intuitive, require a javascript snippet that has to be manually added in the qualtrics website.
# Therefore, their txt files should be as similar as they can so only the javascript snippet is manually adeded.

# TODO: decide how many items per block and how to contruc blocks.

# For exporting items each item should be writte in a plain txt file including the format html(?)-code and the qualtrics-format code.

# [[QUALTRICS]]
# Problem context   html
# Actual item       html
# Question          html
# Response type     html
# [[QUALTRICS]]


# Format parameters -------------------------------------------------------

# HTML codes ******************************
    # font
    hmtl_linebreak <- "<br>"
    hmtl_italic <- "<i>ITALIZE_THIS</i>"
    
    # font size
    q_choice_size <- 16
    q_question_size <- 22
    
    # font size templates
    html_question_font_size <- 
      paste0('<span style="font-size:', q_question_size, 'px;">QUESTION_TEXT_TO_FORMAT</span>')
    
    html_choices_font_size <- 
      paste0('<span style="font-size:', q_choice_size, 'px;">CHOICES_TEXT_TO_FORMAT</span>')

# Qualtrics codes *************************
    # General
    qualtrics_advanced_format <- "[[AdvancedFormat]]"
    qualtrics_block_start <- "[[Block:block_name]]"
    qualtrics_pagebreak <- "[[PageBreak]]"
    # Questions
    qualtrics_question_text <- "[[Question:Text]]"
    qualtrics_question_singlechoice_vertical <- "[[Question:MC:SingleAnswer:Vertical]]"
    qualtrics_question_singlechoice_horizontal <- "[[Question:MC:SingleAnswer:Horizontal]]"
    # q_question_dropdown <- "[[Question:MC:DropDown]]"
    qualtrics_question_textentry <- "[[Question:TE]]"
    # Answers
    qualtrics_question_choices <- "[[Choices]]"



# Item formating ----------------------------------------------------------
  
    # function to convert txt files to qualtrics txt format
    source("functions/items2qualtrics.R")

    # convert txt files to qualtric text format
    invisible(lapply(problems_numbered_ordered_responses, function(x) {lapply(x, items2qualtrics)}))


