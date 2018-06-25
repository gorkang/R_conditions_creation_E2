# This script contains the codes to format items to be export to qualtrics.
# It contains HTML and Qualtrics codes.

# Format parameters -------------------------------------------------------
# font size
choice_size <- 16
question_size <- 22
  
# HTML codes ******************************
html_codes <- list(
  # font
  linebreak = "<br>",
  italic = "<i>ITALIZE_THIS</i>",
  # font size templates
  question_font_size =
    paste0('<span style="font-size:', question_size, 'px;">QUESTION_TEXT_TO_FORMAT</span>'),
  choices_font_size =
    paste0('<span style="font-size:', choice_size, 'px;">CHOICES_TEXT_TO_FORMAT</span>'),
  list_start = "<li>",
  list_end = "</li>",
  insert_img = '<img height="834" src="LINK2IMG" style="width&#58; 1200px; height&#58; 834px;" width="1200" />'
)    

# Qualtrics codes *************************
qualtrics_codes <- list(
  # General
  advanced_format = "[[AdvancedFormat]]",
  block_start = "[[Block:block_name]]",
  pagebreak = "[[PageBreak]]",
  question_id = "[[ID:question_id]]",
  # Questions
  question_singlechoice_vertical = "[[Question:MC:SingleAnswer:Vertical]]",
  question_singlechoice_horizontal = "[[Question:MC:SingleAnswer:Horizontal]]",
  question_dropdown = "[[Question:MC:DropDown]]",
  question_textentry = "[[Question:TE:SingleLine]]",
  question_form = "[[Question:TE:Form]]",
  # Answers
  question_choices = "[[Choices]]",
  # Only text
  question_only_text = "[[Question:Text]]",
  # Others
  embedded_data = "[[ED:field:value]]"
)
