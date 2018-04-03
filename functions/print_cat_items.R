# This function takes a string indicating a condition [problemContext_presentationFormat_ppvProb].
# Each info must be separated by a "_".
# Also, this function relys on remove_placeholders, that's the reason why they are on the same script.

# This function needs remove_placeholders
source("functions/remove_placeholders.R")

# actual function
print_cat_items <- function(actual_item, condition, item) {
  
  remove_placeholders(grep(condition, actual_item, value = TRUE), item) %>% 
    cat(sep = "\n****************************\n")
  
}
