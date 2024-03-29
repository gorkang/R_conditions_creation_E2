# Pictoric presentation formats -------------------------------------------

## Numbers sets 

# read csv with number
numbers_item <-
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")#, col_types = cols())

# Convert svg templates to png templates ----------------------------------

# path to factboxs templates
factbox_template_dir <- "materials/Presentation_format/fbpi/input/template/svg/"

# factboxs templates files
factbox_templates <- dir(factbox_template_dir, pattern = ".svg")

# svg to png parameters (to feed svg2png)
fbpi_width <- 1200 # pixels
fbpi_height <- 834 # pixels
# dpi <- 145.35

# input/output dir
input_dir  <- factbox_template_dir
output_dir <- "materials/Presentation_format/fbpi/input/template/png/"

# If Folder does not exist, create it. If does exist, does nothing.
dir.create(file.path(output_dir), showWarnings = FALSE, recursive = TRUE)

# Convert svg to png
# # paremeters
width <- fbpi_width
height <- fbpi_height

# # convert
walk(factbox_templates, svg2png)

# factbox png dir
factbox_dir <- output_dir

# factbox png files
factbox_files <- dir(factbox_dir, pattern = ".png")

# read factbox imgs to a list
fbpi_items <- map(factbox_files, ~magick::image_read(paste0(factbox_dir, .x)))

# name imgs
names(fbpi_items) <- 
  gsub(".png", "", factbox_files)

rm(factbox_dir,factbox_files,factbox_template_dir,fbpi_height,fbpi_width,height,width, input_dir, output_dir, factbox_templates)


# Assemble Fact-box images ------------------------------------------------

# filter numbers to keep factbox numbers
numbers_fact <- filter(numbers_item, format == "fbpi")

# Use this to calculate position using percentages (number 1 to use the first img. It shouldn't make a difference to use the second)
img_width <- magick::image_info(fbpi_items[[1]])$width
img_height <- magick::image_info(fbpi_items[[1]])$height

# position of each piece using percentages
first_col_x  <- 0.691666 # first column x axis pos. (percetages pos.)
second_col_x <- 0.8916667 # second column x axis pos. (percetages pos.)
first_row_y  <- 0.498 # first row y axis pos. (percetages pos.)
second_row_y <- 0.623 # second row y axis pos. (percetages pos.)
third_row_y  <- 0.777  # ...
# fourth_row_y <- 0.7680348 # ...
age_pos_x <- 0.282
age_pos_y <- 0.13

first_prev_x  <- .627    # first prevalence (from left to right) x axis position
second_prev_x <- .827    # second prevalence (from left to right) x axis position
both_prev_y   <- .351    # both prevalences y axis position.

# convert percentage position to absolute positions relative to the img dimensions
first_col_pos  <- first_col_x*img_width   # first column x axis pos. (absolute pos.)
second_col_pos <- second_col_x*img_width  # second column x axis pos (absolute pos.)
first_row_pos  <- first_row_y*img_height  # first row y axis pos. (absolute pos.)
second_row_pos <- second_row_y*img_height # second row y axis pos. (absolute pos.)
third_row_pos  <- third_row_y*img_height  # third row ... (absolute pos.)
# fourth_row_pos <- fourth_row_y*img_height # fourth row ... (absolute pos.)

age_pos_x_abs <- age_pos_x*img_width
age_pos_y_abs <- age_pos_y*img_height

first_prev_col_pos  <- first_prev_x*img_width  # first prevalence (from left to right) x axis position (absolute pos.)
second_prev_col_pos <- second_prev_x*img_width # second prevalence (from left to right) x axis position (absolute pos.)
both_prev_row_pos   <- both_prev_y*img_height  # both prevalences y axis position. (absolute pos.)

# Position to put numbers
pieces_pos <- c(paste0("+", first_prev_col_pos, "+", both_prev_row_pos), # first prevalence (left to right),
                paste0("+", second_prev_col_pos, "+", both_prev_row_pos), # first prevalence (left to right),
                paste0("+", first_col_pos, "+", first_row_pos), # R1C1
                paste0("+", first_col_pos, "+", second_row_pos), # R2C1
                paste0("+",second_col_pos, "+", first_row_pos), # R1C2
                paste0("+",second_col_pos, "+", second_row_pos), # R2C2
                paste0("+",second_col_pos, "+", third_row_pos), # R3C2
                #paste0("+",second_col_pos, "+", fourth_row_pos) # R4C2 breast_remove
                paste0("+",age_pos_x_abs, "+", age_pos_y_abs) # woman's age
)

# position of columnes in numbers
fbpi_field_replacements <-
  read_csv("materials/Numbers/fields2fill.csv", col_types = cols())$fbpi_item_prep %>% 
  na.omit()

# get index of field replacements within numbers_fact
# # empty vector to store positions
num_pos <- vector(mode = "numeric", length = length(fbpi_field_replacements))
num_pos <- mapply(FUN = function(x,y) {x = which(names(numbers_item) %in% y)}, x = num_pos, y = fbpi_field_replacements)

# Assemble factboxs

# 01. Goes through number of images (in this case, two, one with cancer, one with trisomy)
for (fact_box_loop in seq(length(fbpi_items))) {
  # fact_box_loop=1
  
  # repeat template as many times as rows of set numbers csv
  fbpi_img_list <- rep(as.list(fbpi_items[fact_box_loop]), nrow(numbers_fact))
  
  # 01.1 Goes through set of numbers
  for (number_set_loop in seq(nrow(numbers_fact))) {
    # number_set_loop=1
    
    # grabs the current img to fill
    fbpi_img_to_fill <- fbpi_img_list[[number_set_loop]]
    # grabs the current row with numbers to use as fillers
    num_looped <- numbers_fact[number_set_loop,]
    
    # Loop to walk fields to replace
    for (numbers_pos_loop in seq(length(pieces_pos))) { # LOOP: number of numbers to put into the image
      # numbers_pos_loop=1
      
      # puts numbers into template.
      ## prevalence numbers are treated 
      ## different because they have 
      ## different font on the template
      
      # # if piece of information to put is the prevalence
      if (num_pos[numbers_pos_loop] == which(names(numbers_item) %in% "prev_02")) {
        
        fbpi_img_to_fill <-
          magick::image_annotate(fbpi_img_to_fill, paste0(format(num_looped[[1, num_pos[numbers_pos_loop]]], big.mark=",",scientific=FALSE), " women"), 
                                 size = 22, color = "black", boxcolor = "", # ROW 1
                                 # , strokecolor = "black",
                                 font = "Arial Black",
                                 degrees = 0, location = pieces_pos[numbers_pos_loop])
        
        # # if piece of information is any other than prevalence
      } else if (num_pos[numbers_pos_loop] != which(names(numbers_item) %in% "prev_02")) {
        
        fbpi_img_to_fill <-
          magick::image_annotate(fbpi_img_to_fill, as.character(num_looped[[1, num_pos[numbers_pos_loop]]]), 
                                 size = 25, color = "black", boxcolor = "", # ROW 1
                                 degrees = 0, location = pieces_pos[numbers_pos_loop])
      }
    }
    
    # Insert img with numbers into list with same-context templates
    fbpi_img_list[[number_set_loop]] <- fbpi_img_to_fill
    
    # IF it's last iteration through number sets, put names on imgs
    if (number_set_loop == nrow(numbers_fact)) {
      # To name each img.
      names(fbpi_img_list) <- apply(numbers_fact, 1, function(x) {gsub("(.*)", paste0("\\1_", x[["prob"]]), names(fbpi_img_list[number_set_loop]))})
    }
    
  }
  
  # Insert imgs with numbers of one context to master list
  fbpi_items[[fact_box_loop]] <- fbpi_img_list
  
  # If last iteration, remove all this.
  if (fact_box_loop == length(fbpi_items)) {
    rm(fbpi_img_list, fbpi_img_to_fill, 
       fact_box_loop, number_set_loop, numbers_pos_loop, 
       num_pos, pieces_pos, fbpi_field_replacements,
       img_height, img_width, num_looped)
  }
  
}

# Write images ------------------------------------------------------------

fbpi_output_folder <- "materials/Presentation_format/fbpi/output/"

# If Folder does not exist, create it. If it does, do nothing-
dir.create(file.path(fbpi_output_folder), showWarnings = FALSE, recursive = TRUE)

for (q in seq(length(fbpi_items))) {
  for (x in seq(length(fbpi_items[[q]]))) {
    magick::image_write(fbpi_items[[q]][[x]], paste0(fbpi_output_folder, names(fbpi_items[[q]][x]), ".png"))
  }
  if (q == length(fbpi_items)) {
    rm(q,x)
  }
}

rm(list = c(grep("first_|second_|third_|fourth_", ls(), value = TRUE),
            grep("both_", ls(), value = TRUE),
            "fbpi_output_folder"))

# Problem context ---------------------------------------------------------

# Read problem contexts ####
# path to responses folder
context_dir <- "materials/Problem_context/input/"

# responses files
context_files <- 
  dir(context_dir, pattern = ".txt") %>% 
  grep("pict_", ., value = TRUE)

# paths to each response file
context_files_path <- paste0(context_dir, context_files)

# list with responses as char strings
fbpi_context <- map(context_files_path, ~readChar(con = .x, nchars = file.info(.x)$size))

# assing name to each response type
names(fbpi_context) <- gsub(".txt", "", context_files)

# high/low prob filling ####

# put prevalences on contexts using number bayes
fbpi_context <- 
  lapply(numbers_fact[["prev_02"]], function(x) {gsub("prevalence_02_variable", x, fbpi_context)})

# name contexts 
fbpi_context <- 
  map2(paste0("**fbpi_context_", numbers_fact[["prob"]], "_ppv**"), unlist(fbpi_context), .f = `paste0`)

rm(context_dir,context_files,context_files_path)
# Responses type pictorial ------------------------------------------------

# path to responses folder
response_types_dir <- "materials/Response_type/"

# responses files
response_type_files <- dir(response_types_dir, pattern = "*.txt")

# paths to each response file
response_type_files_path <- paste0(response_types_dir, response_type_files)

# list with responses as char strings
responses_pic <- map(response_type_files_path, ~readChar(con = .x, nchars = file.info(.x)$size))

# assing name to each response type
names(responses_pic) <- gsub(".txt", "", response_type_files)

# ## sequential guided question fillers
# textual_formats <- 
#   dir("materials/Presentation_format/") %>% grep("[a-z]{2}pi", ., invert = TRUE, value = TRUE)
# 
# ## Get possible problem context
# problem_contexts <-
#   textual_formats %>% 
#   map(~dir(paste0("materials/Presentation_format/", .x, "/input")) %>% 
#         gsub("([a-z]{2}).*", "\\1", .)) %>% 
#   unlist %>% 
#   unique


problem_contexts = 
  list.files("materials/Presentation_format/fbpi/output") %>% 
  gsub("([a-z]{2})_.*", "\\1", .) %>% unique()



# fillers
context_info <- 
  read_csv("materials/Problem_context/problem_context_info.csv", col_types = "ccc")

# fields to loop through (obtained from sg_fillers column names)
tobefilled <-
  read_csv("materials/Numbers/fields2fill.csv", col_types = cols()) %>% 
  select(sg_response) %>% drop_na() %>% pull()
# tofill     <- grep("[A-Z]", names(sg_fillers), value = TRUE)

# sg template to fill (as many as contexts)
temp_sg          <- responses_pic$sg
responses_pic$sg <- rep(responses_pic$sg, ncol(context_info)-1)

# filled sg according to each problem context
for (cC in seq(problem_contexts)) {
  # cC = 2
  temp_sg <- responses_pic$sg[cC]
  
  for (fC in seq(length(tobefilled))) {
    # fC = 1
    temp_sg <- 
      gsub(tobefilled[fC], 
           filter(context_info, code_name == tobefilled[fC]) %>% select(problem_contexts[cC]), 
           temp_sg)
  }
  responses_pic$sg[cC] <- temp_sg
}

rm(response_type_files, response_type_files_path, response_types_dir, numbers_fact, numbers_item)    

