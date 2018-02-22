# Comprehension dir
comprehension_dir <- "materials/Question/Comprehension/input/"

# Files
comprehension_files <- dir(comprehension_dir, pattern = ".txt")

# Path to files
comprehension_path <- paste0(comprehension_dir, comprehension_files)

# Read comprehensions into a list
comprehension_items <-
  lapply(comprehension_path, 
                function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each comprehension
names(comprehension_items) <- gsub(".txt", "", comprehension_files)  

# # get comprehension numbers
# numbers_comprehension <- filter(numbers_item, format == "comprehension")
 
# comprehension items
comprehension_questions <- list(NULL)
# 
# # put risk percentage into comprehension text
for (i in seq(length(comprehension_items))) { # Comprehension items LOOP
 # i=1
   
 # get comprehension item (ca/pr)
  comprehension_questions[[i]] =
          # gsub("risk_percentage",
          #      paste0(numbers_comprehension[[j, "prev_01"]], "%"),
               paste0("***", names(comprehension_items[i]),
                      "***\n\n", comprehension_items[i], "\n\n")

}