# Function to read txt files of a presentation format. It receives the presentation format folder name, and the name for the new object (list) with items readed

read_txt_items_to_list <- function(presentation_format, name) {
  
  # Parameters to feed
  # presentation_format <- "FN absolute"
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