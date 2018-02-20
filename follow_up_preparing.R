

# Follow up dir
follow_up_dir <- "materials/Follow_up/input/"

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
           paste0(numbers_fu[[j, "prev_01"]], "%"), 
           paste0("***", names(follow_up_items[i]), "_",
                  numbers_fu[[j, "prob"]], "***\n\n", fu_to_num[[j]]))  
  }

  # Save numbered follow up to master list
  fu_questions[[i]] = fu_to_num
}



