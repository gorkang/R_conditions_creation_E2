

# Pictoric presentation formats -------------------------------------------

## Numbers sets ----------------------------------------------------------------

# read csv with number
numbers_item <-
  # readr::read_csv("materials/Numbers/numbers_bayes.csv")#, col_types = cols())
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")#, col_types = cols())

### Fact-box ###########

# path to factboxs templates
factbox_template_dir <- "materials/Presentation_format/fbpi/input/template/svg/"

# factboxs templates files
factbox_templates <- dir(factbox_template_dir, pattern = ".svg")

# svg to png parameters (to feed svg2png)
fbpi_width <- 1200 # pixels
fbpi_height <- 834 # pixels
# dpi <- 145.35

# input/output dir
input_dir <- factbox_template_dir
output_dir <- "materials/Presentation_format/fbpi/input/template/png/"

# convert svg to png
# paremeters
width <- fbpi_width
height <- fbpi_height
# convert
invisible(sapply(factbox_templates, svg2png))

# factbox png dir
factbox_dir <- output_dir

# factbox png files
factbox_files <- dir(factbox_dir, pattern = ".png")

# read factbox imgs to a list
fbpi_items <- lapply(factbox_files, function(x) {magick::image_read(paste0(factbox_dir, x))})

# name imgs
names(fbpi_items) <- 
  gsub(".png", "", factbox_files)

### Create pictoric items ----------------------------------------------------------------

#### Fact-box ############################################

# filter numbers to keep factbox numbers
numbers_fact <- filter(numbers_item, format == "fbpi")

# Use this to calculate position using percentages.
img_width <- magick::image_info(fbpi_items[[1]])$width
img_height <- magick::image_info(fbpi_items[[1]])$height

# position of each piece using percentages
first_col_x <- 0.6916667
second_col_x <- 0.8916667
first_row_y <- 0.4760192
second_row_y <- 0.5539568
third_row_y <- 0.68999 # 0.6894484-0.6865
fourth_row_y <- 0.7680348 # 0.7709832-0.0029484

# convert percentage position to absolute positions relative to the img dimensions
first_col_pos <- first_col_x*img_width
second_col_pos <- second_col_x*img_width
first_row_pos <- first_row_y*img_height
second_row_pos <- second_row_y*img_height
third_row_pos <- third_row_y*img_height
fourth_row_pos <- fourth_row_y*img_height

# Position to put numbers
# TODO: get position of the two "1000 women" text to replace it with parametrized prevalence.
pieces_pos <- c(paste0("+", first_col_pos, "+", first_row_pos), # R1C1
                paste0("+", first_col_pos, "+", second_row_pos), # R2C1
                paste0("+",second_col_pos, "+", first_row_pos), # R1C2
                paste0("+",second_col_pos, "+", second_row_pos), # R2C2
                paste0("+",second_col_pos, "+", third_row_pos), # R3C2
                paste0("+",second_col_pos, "+", fourth_row_pos) # R4C2
)

# position of columnes in numbers
fbpi_field_replacements <- c("die_bre_without","die_all_without","die_bre_with","die_all_with","add_treat","breast_remove")

# get index of field replacements within numbers_fact
num_pos <- which(names(numbers_item) %in% fbpi_field_replacements)

# Assemble factboxs
for (fact_box_loop in seq(length(fbpi_items))) { # LOOP: number of images (one with cancer, one with trisomy)
  # fact_box_loop=1
  
  # fb template (cancer or pregnant) as list
  fbpi_img <- fbpi_items[fact_box_loop]
  
  # repeat template as many times as rows of set numbers csv
  fbpi_img_list <- rep(as.list(fbpi_img), nrow(numbers_fact))
  
  # LOOP to walk set of numbers
  for (number_set_loop in seq(nrow(numbers_fact))) {
    # number_set_loop=1
    
    fbpi_img_to_fill <- fbpi_img_list[[number_set_loop]]
    
    num_looped <- numbers_fact[number_set_loop,]
    
    # LOOp to walk fields to replace
    for (numbers_pos_loop in seq(length(pieces_pos))) { # LOOP: number of numbers to put into the image
      # numbers_pos_loop=6
      
      # put pieces of information into template
      fbpi_img_to_fill <-
        magick::image_annotate(fbpi_img_to_fill, as.character(num_looped[[1, num_pos[numbers_pos_loop]]]), size = 21, color = "black", boxcolor = "", # ROW 1
                               degrees = 0, location = pieces_pos[numbers_pos_loop])
      
    }
    # insert img with numbers to list
    fbpi_img_list[[number_set_loop]] <- fbpi_img_to_fill
    
    # IF last iteration around number sets, put names on imgs
    if (number_set_loop == nrow(numbers_fact)) {
      # To name each img.
      names(fbpi_img_list) <- apply(numbers_fact, 1, function(x) {gsub("(.*)", paste0("\\1_", x[["prob"]]), names(fbpi_img_list[number_set_loop]))})
    }
    
  }
  # insert imgs with numbers of one context to master list
  fbpi_items[[fact_box_loop]] <- fbpi_img_list
}

# Write images
for (q in seq(length(fbpi_items))) {
  for (x in seq(length(fbpi_items[[q]]))) {
    magick::image_write(fbpi_items[[q]][[x]], paste0("materials/Presentation_format/fbpi/output/", names(fbpi_items[[q]][x]), ".png"))
  }
}

