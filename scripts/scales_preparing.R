# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr, mgsub)

source("scripts/html_qualtrics_codes.R")

# Severity and emotional reaction scale
source("scripts/scale_severity.R")

# A priori screening belief
source("scripts/scale_apriori.R")




# Scales dir
scales_dir <- "materials/Scales/input/"

# Files
scales_files <- dir(scales_dir, pattern = ".txt")

# Path to files
scales_path <- paste0(scales_dir, scales_files)

# Read scaless into a list
scales_items <-
  lapply(scales_path, 
                function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each scales
names(scales_items) <- gsub(".txt", "", scales_files)  

# # get scales numbers
# numbers_scales <- filter(numbers_item, format == "scales")
 
# scales items
scales_questions <- list(NULL)
# 
# # put risk percentage into scales text
for (i in seq(length(scales_items))) { # Scales items LOOP
 # i=1
   
 # get scales item (ca/pr)
  scales_questions[[i]] =
          # gsub("risk_percentage",
          #      paste0(numbers_scales[[j, "prev_01"]], "%"),
               paste0("***", names(scales_items[i]),
                      "***\n\n", scales_items[i], "\n\n")

}