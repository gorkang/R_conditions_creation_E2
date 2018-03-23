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
    paste0('<span style="font-size:', choice_size, 'px;">CHOICES_TEXT_TO_FORMAT</span>')
)    

# Qualtrics codes *************************
qualtrics_codes <- list(
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

# separated item folder
separated_item_dir <- "materials/qualtrics/output/separated_items/"
response_types_dir <- "materials/qualtrics/input/reponse_type/qualtrics_question_gi.txt"
paired_items_dir <- "materials/qualtrics/output/paired_items/"

# function to convert txt files to qualtrics txt format
source("functions/items2qualtrics.R")

# does it worth it to add this to the end of textual item preparation?
problems_numbered_ordered_responses_flat <- as.list(unlist(problems_numbered_ordered_responses, recursive = TRUE))

invisible(lapply(problems_numbered_ordered_responses_flat, function(x) {items2qualtrics(list_of_items = x, inputdir = response_types_dir, outputdir = separated_item_dir)}))

# pair items: different context, same presentation format, different ppv prob, same response type
# function to pair items
source("functions/pair_items.R")
# items_txt <- dir(output_dir, pattern = ".txt")
txt_files <- dir(separated_item_dir, pattern = ".txt")
twins <- character(length(items_txt)/2)

# debug(pair_items)
invisible(lapply(txt_files, function(x) {pair_items(x, twins, outputdir = paired_items_dir)}))


# Follow-up format and exporting ------------------------------------------


