# This function takes a string indicating a condition [problemContext_presentationFormat_ppvProb].
# Each info must be separated by a "_".
# Also, this function relys on remove_placeholders, that's the reason why they are on the same script.

# This function needs remove_placeholders
source("functions/remove_placeholders.R")

# actual function
print_cat_items <- function(actual_item, condition, item, print_or_cat = "print_cat") {
  
  if (print_or_cat == "print") {
    remove_placeholders(grep(condition, actual_item, value = TRUE), item)
  } else if (print_or_cat == "print_cat")
    remove_placeholders(grep(condition, actual_item, value = TRUE), item) %>% 
    gsub("\\n", "\n\n", .) %>% # add extra linebreaks because markdown considers that one is not enough
    cat(sep = "\n****************************\n")
}
