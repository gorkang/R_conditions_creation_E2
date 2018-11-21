# Function to read txt files of a given presentation format.
# It receives a string indicating presentation format (e.g. "nfab"), and
# and string indicating a name for the new object with presentation formats 
# (e.g. "nfab_items").

textItem2list <- function(presentation_format, name) {
  
  # Parameters to feed
  # presentation_format <- "nfab"
  # name <- "nfab_items"
  
  # path to responses folder
  items_dir <- paste0("materials/Presentation_format/", presentation_format, "/input/")
  
  # responses files
  item_files <- dir(items_dir, pattern = ".txt")
  
  # paths to each response file
  item_files_path <- paste0(items_dir, item_files)
  
  # list with responses as char strings
  items <- lapply(item_files_path, 
                  function(x) readChar(con = x, nchars = file.info(x)$size)) 
  
  # assing name to each response type
  names(items) <- gsub(".txt", "", item_files)
  
  # assign object to global envir.
  assign(x = name, value = items, envir = .GlobalEnv)
  
}