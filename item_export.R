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

# Item formating ----------------------------------------------------------

source("scripts/html_qualtrics_codes.R")

# separated item folder
separated_item_dir <- "materials/qualtrics/output/separated_items/"
response_types_dir <- "materials/qualtrics/input/reponse_type/qualtrics_question_gi.txt"
paired_items_dir <- "materials/qualtrics/output/paired_items/"

# function to convert txt files to qualtrics txt format
source("functions/items2qualtrics.R")

# does it worth it to add this to the end of textual item preparation?
# problems_numbered_ordered_responses_flat <- as.list(unlist(problems_numbered_ordered_responses, recursive = TRUE))

problems_numbered_ordered_responses %>% 
  map(~items2qualtrics(list_of_items = .x, responsesdir = response_types_dir, outputdir = separated_item_dir, removePlaceholders = TRUE)) %>% 
  invisible()

# pair items: different context, same presentation format, different ppv prob, same response type
# function to pair items
source("functions/pair_items.R")

# items_txt <- dir(output_dir, pattern = ".txt")
txt_files <- dir(separated_item_dir, pattern = ".txt")
twins <- character(length(txt_files)/2)

txt_files %>% 
  map(~pair_items(txt_files = .x, separated_item_dir = separated_item_dir, twins = twins, outputdir = paired_items_dir)) %>% 
  invisible()

# Follow-up format and exporting ------------------------------------------


