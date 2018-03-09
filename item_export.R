
# For exporting items each item should be writte in a plain txt file including the format html(?)-code and the qualtrics-format code.

# Problem context   html
# Actual item       html
# Question          html
# Response type     html/qualtrics


problems_numbered_ordered_responses[[1]][[1]] %>% cat
cat(problems_numbered_ordered_responses[[1]][[1]])
item <- problems_numbered_ordered_responses[[1]][[1]]
item2 <- problems_numbered_ordered_responses[[1]][[3]]

# get item name (this should be the actual file-name) ####
gsub("\\*\\*(.*)\\*\\*.*", "\\1", item)

# separate problem context, actual item, and question from response type. ####
# if all items end with five breaklines (\n) it can be use to chop-off the response type.
# it seems that it is the case.
lapply(problems_numbered_ordered_responses, 
       function(x) {lapply(x, 
                           function(x) {if (grep("\n\n\n\n\n", lapply(x, function(y) {y})) != 1) {print("NOOOOOOOO")}})})
       
# item without response type
gsub("(.*)\n\n\n\n\n.*", "\\1", item)

# TODO: define html-format (font, font-size, breaklines(?), html-links to imgs if necessary)

# TODO: create a qualtrics-compatible response type text
  # the only response type that is customized (to disease context) is the sequential guided question.
  # all the others should be generics.

