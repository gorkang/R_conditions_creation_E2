problems_numbered_ordered_responses_flat <- unlist(problems_numbered_ordered_responses, recursive = TRUE)

item_test <- problems_numbered_ordered_responses_flat[[8]]

item_test %>% cat

item_test

# very horrible regex to grab the prevalence of each problem. the regex is anchored to breaklines and "Suppose" and "Imagine"
regex_first_line <- ".*([0-9]{2}.*[0-9]{4}.*at the time of the screening).*"
regex_first_line_a <-   ".*\\n\\n.*\\n\\n.*\\n\\n\\n(.*)\\n\\n.*\\n\\n.*\\n\\n\\n.*\\n\\n\\n\\n\\n.*\\n"
regex_first_line_a <-   ".*\\n\\n.*\\n\\n.*\\n\\n\\n(.*)\\n\\n.*\\n\\n.*\\n\\n\\n.*\\n.*"

# entre la pregunta y el response type dejar sólo 2 saltos de linea.

gsub(regex_first_line, "\\1", item_test)
gsub(regex_first_line_a, "\\1", item_test)



lapply(problems_numbered_ordered_responses_flat, function(x) {gsub(regex_first_line_a, "\\1", x)})



item <- item_test

# 00. get item name (this should be the actual file-name) ####
# item_name <- gsub("\\*\\*(.*)\\*\\*.*", "\\1", item)

# 01. get item w/o name
item_nameless <- gsub("\\*\\*.*\\*\\*\n\n(.*)", "\\1", item)

item_responseless <- gsub("(.*)\n\n\n\n\n.*", "\\1", item_nameless)


gsub(, "\\1", item_responseless)
