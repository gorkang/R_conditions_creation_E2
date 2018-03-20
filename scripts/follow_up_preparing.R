# TODO: get the first sentence of each condition on 
# problems_numbered... (the one with the final problems) and paste it in each follow up (ca,pr;riskhigh,risklow)

# THINGS TO FILL:
# ppv response in previous question. this is a qualtrics question id code. to know the 
    # actual code we need to have already uploaded the ppv question and see what their codes are.

# FILE GENERATION OUTLINE:
# 2 contexts (ca, pr)
# 2 disease_prevalence (low, high).
# 2 risk_percentage (1%, 10%).
# result: 8 txt files

# THIS HAS TO BE DONE ON item_export branch
# QUESTIONS  (create them in txt files and bind them to the follow up txt)
# 1. yes/no alternative single choice question.
# 2. 0-100% horizontal slider
# 3. five 0-100% horizontal sliders + "other:..." open text.
# 4. open text question
# 5. (regarding #1) if yes/no (different text) 0-100% horizontal slider.

# Generate qualtrics + html questions
# create an external file, or R object, with html and qualtrics code to be used on item export and here

# read csv with number
numbers_item <-
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")

# Follow up dir
follow_up_dir <- "materials/Question/Follow_up/input/items/"

# Files
follow_up_files <- dir(follow_up_dir, pattern = ".txt")

# Path to files
follow_up_path <- paste0(follow_up_dir, follow_up_files)

# Read follow ups into a list
follow_up_items <-
  lapply(follow_up_path, 
                function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each follow up
names(follow_up_items) <- gsub(".txt", "", follow_up_files)  

# get followup numbers
numbers_fu <- filter(numbers_item, format == "fu")

# follow up items
fu_questions <- list(NULL)

# put risk percentage into follow up text
for (i in seq(length(follow_up_items))) { # Follow up items LOOP
  # i=1
  
  # get follow up item (ca/pr)
  fu_to_num =
    rep(follow_up_items[[i]], nrow(numbers_fu))
  
  for (j in seq(nrow(numbers_fu))) { # set of numbers LOOP
    # j=1
    
    # put risk number and name into follow up items
    fu_to_num[[j]] =
      gsub("risk_percentage", 
           paste0(numbers_fu[[j, "fu_risk"]], "%"), 
           paste0("***", names(follow_up_items[i]), "_risk",
                  numbers_fu[[j, "prob"]], "***\n\n", fu_to_num[[j]]))  
  }

  # Save numbered follow up to master list
  fu_questions[[i]] = fu_to_num
}

# unlist and list again to get a one level list
fu_questions <- as.list(unlist(fu_questions, recursive = FALSE))

# Combine follow up items with prevalences
numbers_nfab <- 
  filter(numbers_item, format == "nfab")

# get prevalences from numbers_bayes filtered
prevalences_txt <- 
  as.vector(apply(numbers_nfab, 1, function(y) {paste0("__", y[["prob"]], "__", y[["prev_01"]], " out of ", y[["prev_02"]])}))

# Put prevalences on follow up items
for (i in seq(length(fu_questions))) {
  
  current_fu <-
    rep(fu_questions[[i]], length(prevalences_txt))
  
  for (j in seq(length(current_fu))) {
    # j = 1
    
    current_fu[j] <-
      gsub("disease_prevalence", # prevalence field to be fill
                            gsub("__.*__(.*)", "\\1", prevalences_txt[[j]]), # replace with the actual prevalence of prevalences_txt (rmv que ppv prob: low/high)
                            # the substitution above takes place in what results of the following
                            gsub("(\\*\\*\\*.*)(\\*\\*\\*.*)", # get the follow up name and separates it in two parts to put the ppv prob in it 
                                 paste0("\\1", "_ppv", gsub("__(.*)__.*", "\\1", prevalences_txt)[[j]],"\\2"), # replace with "ppv_ + ppv_prob" (taken from prevalence txt)
                                 current_fu[j])) # actual followup item to make all the above substitutions.
  }
  
  fu_questions[[i]] <- current_fu
  
  
}

# unlist and list again to get a one level list
fu_questions <-
  as.list(unlist(fu_questions, recursive = TRUE))

# Export items to txt
# directory (setting and creation)
output_dir <- "materials/Question/Follow_up/output/"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# function to export items to text
save_fu <- function(list_fu) {
  
item2save <- gsub("\\*\\*\\*.*\\*\\*\\*\\n\\n(.*)", "\\1", list_fu)
path2save <- paste0(output_dir, gsub("\\*\\*\\*(.*)\\*\\*\\*.*", "\\1", list_fu), ".txt")
cat(item2save, sep = "", file = path2save)

}

gsub("problem context")

# export items to text iterating through the list of follow up items
invisible(lapply(fu_questions, save_fu))

