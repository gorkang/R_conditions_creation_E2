# TODO: wrap items with qualtrics-format related codes using a placeholder within a prefabricated qualtrics-item template?
# e.g.:
# [QUALTRICS CODE]
# placeholder_to_be_replaced_with_item
# [QUALTRICS CODE]

# TODO: create a qualtrics-compatible response type text
# the only response type that is customized (to disease context) is the sequential guided question.
# all the others should be generics.

# Possible option. Create a txt file with each response type in qualtrics-comp format (sg response type will have two files)?
# Keep in mind that all questions, but global intuitive, require a javascript snippet that has to be manually added in the qualtrics website.
# Therefore, their txt files should be as similar as they can so only the javascript snippet is manually adeded.

# TODO: reduce linebreaks between pieces of information to one (continue in the next line)


# For exporting items each item should be writte in a plain txt file including the format html(?)-code and the qualtrics-format code.

# Problem context   html
# Actual item       html
# Question          html
# Response type     html/qualtrics


problems_numbered_ordered_responses[[1]][[1]] %>% cat
cat(problems_numbered_ordered_responses[[1]][[1]])
item <- problems_numbered_ordered_responses[[1]][[1]]
item2 <- problems_numbered_ordered_responses[[1]][[3]]


# 00. get item name (this should be the actual file-name) ####
item_name <- gsub("\\*\\*(.*)\\*\\*.*", "\\1", item)

# 01. get item w/o name
item_nameless <- gsub("\\*\\*.*\\*\\*\n\n(.*)", "\\1", item)

# separate problem context, actual item, and question from response type. ####
# if all items end with five breaklines (\n) it can be use to chop-off the response type.
# it seems that it is the case.
# lapply(problems_numbered_ordered_responses, 
#        function(x) {lapply(x, 
#                            function(x) {if (grep("\n\n\n\n\n", lapply(x, function(y) {y})) != 1) {print("NOOOOOOOO")}})})

# 02. item without response type
item_responseless <- gsub("(.*)\n\n\n\n\n.*", "\\1", item_nameless)

# TODO: define html-format (font, font-size, breaklines(?), html-links to imgs if necessary)

# +++++++++++++++++++++++++++++++++++++++++
# HTML codes ++++++++++++++++++++++++++++++
hmtl_linebreak <- "<br>"
hmtl_italic <- "<i>ITALIZE_THIS</i>"

# parameters (size in pixels) +++++++++++++
q_choice_size <- 16
q_question_size <- 22

# font size templates +++++++++++++++++++++
html_question_font_size <- 
  paste0('<span style="font-size:', q_question_size, 'px;">QUESTION_TEXT_TO_FORMAT</span>')

html_choices_font_size <- 
  paste0('<span style="font-size:', q_choice_size, 'px;">CHOICES_TEXT_TO_FORMAT</span>')

# +++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++
# Qualtrics codes +++++++++++++++++++++++++
qualtrics_advanced_format <- "[[AdvancedFormat]]"
qualtrics_block_start <- "[[Block:block_name]]"
qualtrics_pagebreak <- "[[PageBreak]]"

qualtrics_question_text <- "[[Question:Text]]"
qualtrics_question_singlechoice_vertical <- "[[Question:MC:SingleAnswer:Vertical]]"
qualtrics_question_singlechoice_horizontal <- "[[Question:MC:SingleAnswer:Horizontal]]"
# q_question_dropdown <- "[[Question:MC:DropDown]]"
qualtrics_question_textentry <- "[[Question:TE]]"

qualtrics_question_choices <- "[[Choices]]"

# +++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++


# 03. Item (without response type)
html_item_responseless <- gsub("QUESTION_TEXT_TO_FORMAT", item_responseless, html_question_font_size)
html_item_responseless_breaks <- gsub("\n", hmtl_linebreak, html_item_responseless)


# 04. response type
# Global intuitive response type
hmtl_response_type <- readChar(con = "materials/qualtrics/input/qual_question_gb.txt", nchars = file.info("materials/qualtrics/input/qual_question_gb.txt")$size)

# 05. Combine item elements

item_to_export <- paste(
  qualtrics_question_singlechoice_horizontal, "\n",
  html_item_responseless_breaks, "\n",
  qualtrics_question_choices, "\n",
  hmtl_response_type
  
  , sep = "")


cat(item_to_export)








