# TODO: create a qualtrics-compatible response type text
# [X] global intuituive
# [ ] global systematic
# [ ] sequential guided
# [ ] sequential simple

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
html_codes <- list(
  # font
  linebreak = "<br>",
  italic = "<i>ITALIZE_THIS</i>",
  # font size
  choice_size = 16,
  question_size = 22,
  # font size templates
  question_font_size =
    paste0('<span style="font-size:', q_question_size, 'px;">QUESTION_TEXT_TO_FORMAT</span>'),
  choices_font_size =
    paste0('<span style="font-size:', q_choice_size, 'px;">CHOICES_TEXT_TO_FORMAT</span>')
)    

# Qualtrics codes *************************
qualtric_codes <- list(
  # General
  advanced_format = "[[AdvancedFormat]]",
  block_start = "[[Block:block_name]]",
  pagebreak = "[[PageBreak]]",
  # Questions
  question_text = "[[Question:Text]]",
  question_singlechoice_vertical = "[[Question:MC:SingleAnswer:Vertical]]",
  question_singlechoice_horizontal = "[[Question:MC:SingleAnswer:Horizontal]]",
  question_dropdown = "[[Question:MC:DropDown]]",
  question_textentry = "[[Question:TE]]",
  # Answers
  question_choices = "[[Choices]]"
)

# Item formating ----------------------------------------------------------

# function to convert txt files to qualtrics txt format
source("functions/items2qualtrics.R")

# convert txt files to qualtric text format
invisible(lapply(problems_numbered_ordered_responses, function(x) {lapply(x, items2qualtrics)}))


