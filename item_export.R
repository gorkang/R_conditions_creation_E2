# TODO: create a qualtrics-compatible response type text
# the only response type that is customized (to disease context) is the sequential guided question.
# all the others should be generics.

# Possible option. Create a txt file with each response type in qualtrics-comp format (sg response type will have two files)?
# Keep in mind that all questions, but global intuitive, require a javascript snippet that has to be manually added in the qualtrics website.
# Therefore, their txt files should be as similar as they can so only the javascript snippet is manually adeded.

# TODO: reduce linebreaks between pieces of information to one (continue in the next line)
# TODO: wrap-up everything in a loop? A block with n items has to be created for each condition. Loop through conditions?

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



items2qualtrics <- function(list_of_items) {
    
# item to format to qualtrics
# item <- problems_numbered_ordered_responses[[1]][[1]]
item <- list_of_items

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

# 03. Item (without response type)
html_item_responseless <- gsub("QUESTION_TEXT_TO_FORMAT", item_responseless, html_question_font_size)
html_item_responseless_breaks <- gsub("\n", hmtl_linebreak, html_item_responseless)


# 04. response type
# Global intuitive response type
hmtl_response_type <- readChar(con = "materials/qualtrics/input/qual_question_gb.txt", nchars = file.info("materials/qualtrics/input/qual_question_gb.txt")$size)

# 05. Combine item elements

if (grepl("_gi", item_name)) {
  
  item_to_export <- paste(
    qualtrics_advanced_format, "\n",
    qualtrics_question_singlechoice_horizontal, "\n",
    html_item_responseless_breaks, "\n",
    qualtrics_question_choices, "\n",
    hmtl_response_type
    
    , sep = "")
  
  
} else if (!grepl("_gi", item_name)) {
  
  item_to_export <- paste(
    qualtrics_advanced_format, "\n",
    qualtrics_question_text, "\n",
    html_item_responseless_breaks
    
    , sep = "")
  
}

# 06. Write item to txt file

cat(item_to_export, file = paste0("materials/qualtrics/output/", item_name, ".txt"))

}

    
    lapply(problems_numbered_ordered_responses, function(x) {lapply(x, items2qualtrics)})






