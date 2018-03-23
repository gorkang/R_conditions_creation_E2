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

# function to convert txt files to qualtrics txt format
source("functions/items2qualtrics.R")

# convert txt files to qualtric text format
output_dir <- "materials/qualtrics/output/separated_items/"
input_dir <- "materials/qualtrics/input/reponse_type/qualtrics_question_gi.txt"

# This used to be a lapply, now it's a for. 
# lapply(problems_numbered_ordered_responses, function(x) {items2qualtrics(list_of_items = x, inputdir = input_dir, outputdir = output_dir)})

for (a in seq(length(problems_numbered_ordered_responses))) {
  # a=1
  for (b in seq(length(problems_numbered_ordered_responses[[a]]))) {
    # b=1
    items2qualtrics(problems_numbered_ordered_responses[[a]][[b]], inputdir = input_dir, outputdir = output_dir)
    
  }
}

# pair items: different context, same presentation format, different ppv prob, same response type
# function to pair items
source("functions/pair_items.R")
# items_txt <- dir(output_dir, pattern = ".txt")
txt_files <- dir("materials/qualtrics/output/separated_items/", pattern = ".txt")
twins <- character(length(items_txt)/2)
output_dir <- "materials/qualtrics/output/paired_items/"

invisible(lapply(txt_files, function(x) {pair_items(x, twins, outputdir = output_dir)}))


