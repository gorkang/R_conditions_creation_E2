pair_items <- function(txt_files, twins, outputdir) {
  
# ############################################################################################
# This script receives an item name and looks for the opposite context and ppv prob item.
# The cat the two items with a qualtrics page break between them, and save them to a txt file.
# ############################################################################################

  # get item of current iteration
  first_twin = txt_files
  first_twin_info <- unlist(strsplit(first_twin, "_"))
  
  # check if item is already on list with paired item, if it is, skip it.
  if (all(grepl(first_twin, twins))) {
    
  } else if (!all(grepl(first_twin, twins))) {
    
    # look for oposite ppv prob and context.
    if (first_twin_info[1] == "ca") {
      if (first_twin_info[3] == "high") {
        second_twin <- paste0("pr_", first_twin_info[2], "_low_", first_twin_info[4])
      } else if (first_twin_info[3] == "low") {
        second_twin <- paste0("pr_", first_twin_info[2], "_high_", first_twin_info[4])
      }
    } else if (first_twin_info[1] == "pr") {
      if (first_twin_info[3] == "high") {
        second_twin <- paste0("ca_", first_twin_info[2], "_low_", first_twin_info[4])
      } else if (first_twin_info[3] == "low") {
        second_twin <- paste0("ca_", first_twin_info[2], "_high_", first_twin_info[4])
      }
    }
    
  }
  
  # get info of second item
  second_twin_info <- unlist(strsplit(second_twin, "_"))
  
  # store binded items names
  twins <- paste0(first_twin,  "--", second_twin)
  
  # Read separated files
  a_to_read <- paste0(txt_files_dir, first_twin)
  a <- readChar(con = a_to_read, nchars = file.info(a_to_read)$size)
  
  b_to_read <- paste0(txt_files_dir, second_twin)
  b <- readChar(con = b_to_read, nchars = file.info(b_to_read)$size)
  
  # output file name
  file_out_name <- paste(first_twin_info[2], first_twin_info[3], second_twin_info[3], first_twin_info[4], sep = "_")
  # print binded items to txt
  dir.create(outputdir, showWarnings = FALSE, recursive = TRUE)
  cat(a, b, sep = paste0(qualtrics_code$pagebreak, "\n"), file = paste0(outputdir, file_out_name))
  
}