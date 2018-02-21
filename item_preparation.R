# Items preparation


# Packages and functions  --------------------------------------------------------------

# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magick, png, grid)

# Functions
source("functions/numbers2problems.R")
source("functions/svg2png.R")
source("functions/read_txt_items_to_list.R")
source("functions/ppv_calculator.R")


## Presentation_formats ----------------------------------------------------------------

### Natural Frequency
read_txt_items_to_list("fnab", "nfab_items")


### Positive framework
read_txt_items_to_list("pfab", "pfab_items")


### Probability Absolute
read_txt_items_to_list("prab", "prab_items")


### Probability Relative
read_txt_items_to_list("prre", "prrl_items")

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

### New paradigm ###################################

# path to factboxs templates
newparadigm_template_dir <- "materials/Presentation_format/nppi/input/template/svg/"

# factboxs templates files
newparadigm_templates <- dir(newparadigm_template_dir, pattern = ".svg")

# svg to png parameters (to feed svg2png)
nppi_width <- 690 # pixels
nppi_height <- 1169 # pixels
# dpi <- 45.71

# input/output dir
input_dir <- newparadigm_template_dir
output_dir <- "materials/Presentation_format/nppi/input/template/png/"

# convert svg to png
  # parameters
  width <- nppi_width
  height <- nppi_height
# convert
invisible(sapply(newparadigm_templates, svg2png))

# newparadigm png dir
newparadigm_dir <- output_dir

# factbox png files
newparadigm_files <- dir(newparadigm_dir, pattern = ".png")

# read factbox imgs to a list
nppi_items <- lapply(newparadigm_files, function(x) {magick::image_read(paste0(newparadigm_dir, x))})

# name imgs
names(nppi_items) <- 
  gsub(".png", "", newparadigm_files)


## Bind textual presentation formats -------------------------------------------

problems <- c(nfab_items, pfab_items, prab_items, prrl_items)

## Numbers sets ----------------------------------------------------------------

# read csv with number
numbers_item <-
  # readr::read_csv("materials/Numbers/numbers_bayes.csv")#, col_types = cols())
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")#, col_types = cols())

## Create items ----------------------------------------------------------------

### Create textual items (combine items with numbers)

numbers2problems(problems)
# problems_numbered

### Add question to textual items #########################

# path to responses folder
questions_dir <- 
  paste0("materials/Question/input/")

# responses files
question_files <-
  dir(questions_dir, pattern = ".txt")

# paths to each response file
question_files_path <- paste0(questions_dir, question_files)

# list with responses as char strings
questions <- lapply(question_files_path, 
                    function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each response type
names(questions) <- gsub(".txt", "", question_files)


# paste questions into problems
for (i in seq(length(problems_numbered))) {
  # i=1
  
  if (grepl("ca|pf|pr", names(problems_numbered[i]))) {
    
    current_question_name <- 
      paste0(gsub("(ca|pr).*", "\\1", names(problems_numbered[i])), "_question")
    
    current_question <- 
      questions[current_question_name]
    
    for (j in seq(length(problems_numbered[[i]]))) {
      # j=1
      
      # paste question with problem and save it to the list
      problems_numbered[[i]][[j]] <-
        paste0(problems_numbered[[i]][[j]], current_question, "\n\n")
      
    }
    
  }
  
}

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

#### New-paradigm ###################################################

##### Create ppv graphs

# Read csv with prevalences by age
age_prevalence <- 
  read_csv("materials/Presentation_format/nppi/input/graphs/age_prevalence.csv", col_types = "iii")

# Create column with prevalence percentage
age_prevalence <- 
  age_prevalence %>% 
  mutate(prevalence_percentage = 1/prevalence)

# Test parameters (Two different tests)
numbers_item_nppi_graphs <-
  # read_csv("materials/Numbers/numbers_bayes.csv", col_types = cols()) %>% 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% #, col_types = cols())
  filter(format == "nppi")

# function: create cols with ppv using different test parameters
create_ppv_by_test <- function(x) {
  # i=1
  
  # TEST parameters
  test_prob <- x[["prob"]]
  hit_rate <- x[["hit_rate_02"]]
  false_positive_rate <- x[["false_positive_02"]]
  
  # label: high/low
  ppv_prob <- paste0("ppv_", test_prob)
  
  # create col with ppv 
  age_prevalence <-
    age_prevalence %>%
    mutate(!!ppv_prob := 
             round(100*(ppv_calculator(as.numeric(prevalence_percentage), as.numeric(hit_rate), as.numeric(false_positive_rate))), 2))
  
  assign("age_prevalence", age_prevalence, envir = .GlobalEnv)
  
}

# create cols 
invisible(apply(numbers_item_nppi_graphs, 1, create_ppv_by_test))

# Graph parameters
age_ppv_to_plot <- c(20,25,30,35,40)
x_axis_label <- "Age of the mother"
y_axis_label <- "Test reliability"

width <- 10
height <- 6
dpi <- (magick::image_info(nppi_items[[1]])$width-40)/10

for (x in 1:nrow(numbers_item_nppi_graphs)) {
  #x=1
  
  # col name with ppv values
  graph_prob <- numbers_item_nppi_graphs$prob[x]
  
  # create numerator to organize graphs
  graph_numerator <- numbers_item_nppi_graphs$graph_numerator[x]
  graph_numerator <- if (graph_numerator < 10 & !grepl("0", graph_numerator)) {paste0("0", graph_numerator)} else {paste0(graph_numerator)}
  
  # col with ppv according to graph_prob
  curr_col_name <- grep(graph_prob, names(age_prevalence), value = TRUE) 
  
  graph_png_file_name <- paste0("graph_", graph_numerator, "_", curr_col_name)
  
  png_file_pathname <- 
    paste0("materials/Presentation_format/nppi/input/graphs/png/", graph_png_file_name, "_graph.png") # path and name to new png file
  
  # Create a ppv-value col
  age_prevalence_plot <- age_prevalence %>% 
    mutate_("ppv" = curr_col_name) %>% 
    filter(age %in% age_ppv_to_plot)
  
  # Plot ppv by Age
  graph_within_loop <- ggplot(age_prevalence_plot, aes(x=age, y=ppv)) + # plot canvas
    scale_y_continuous(labels=function(x) paste0(x,"%"), # append % to y-axis value
                       limits = c(0,100)
                       # , breaks = seq(0,100,10)
    ) + # set y-axis limits
    geom_point(size = 6, color = "#009999", shape = 19) + # insert points with ppv value
    geom_line(aes(x=age, y=ppv), color = "#009999", size = 2.5) +  # insert line bridging ppv-value points
    xlab(x_axis_label) + ylab(y_axis_label) + # set axis labels
    theme(axis.text = element_text(size = 25), # axis-numerbs size
          axis.title = element_text(size = 25)) + # axis-labels size
    geom_text(aes(label = 
                    case_when(age %in% age_ppv_to_plot ~ paste0(round(ppv, 0), "%"), TRUE ~ paste0("")), # keep only ages previously set to be ploted
                  hjust = 1, vjust = -1), size = 6) # (position) plot ppv-values above points set in "age_ppv_to_plot"
  
  # Save plot to png file
  ggsave(filename = png_file_pathname, plot = graph_within_loop, width = width, height = height, dpi = dpi, units = "in")
  
}

##### Compose new-paradigm brochure ###################################################

# graphs dir
graph_dir <- "materials/Presentation_format/nppi/input/graphs/png/"

# get graphs file names
nppi_graphs_files_names <- grep("ppv.*png", dir(graph_dir), value = TRUE)

# Read graphs into list
nppi_graphs <- lapply(nppi_graphs_files_names, function(x) magick::image_read(paste0(graph_dir, x)))

names(nppi_graphs) <- paste0(numbers_item_nppi_graphs$prev_02, " births.")

# Template dimensions
img_width <- magick::image_info(nppi_items[[1]])$width
img_height <- magick::image_info(nppi_items[[1]])$height

# Prevalence position in template (%)
# relateive
prev_x <- 0.05652174
prev_y <- 0.2822926
# absolute
prev_x_pos <- prev_x*img_width
prev_y_pos <- prev_y*img_height

# Graph position in template
# relateive
graph_x <- 0.02898551
graph_y <- 0.5731394
# absolute
graph_x_pos <- graph_x*img_width
graph_y_pos <- graph_y*img_height

# numbers for new paradigm
numbers_nppi <- numbers_item %>% filter(format == "nppi")

for (i in seq(length(nppi_items))){
  # i=1
  
  # np template (cancer or pregnant) as list
  nppi_img <- nppi_items[i]
  
  # repeat template as many times as rows of set numbers csv
  nppi_img_list <- rep(as.list(nppi_img), length(nppi_graphs))
  
  for (j in seq(length(nppi_graphs))) {
    # j=1
    
    # assemble_graph use this object
    nppi_img_list[[j]] <- magick::image_annotate(magick::image_composite(nppi_img_list[[i]], nppi_graphs[[j]], offset = paste0("+", graph_x_pos, "+", graph_y_pos)), names(nppi_graphs[j]), font = "arial", size = 19, color = "black", boxcolor = "",
                                       degrees = 0, location = paste0("+", prev_x_pos, "+", prev_y_pos))
    
  }
  
  graph_name <- as.character(numbers_nppi[["prob"]])
  
  names(nppi_img_list) <- paste0(names(nppi_img_list), "_", graph_name)
  
  nppi_items[[i]] <- nppi_img_list
  
}

# Write images
for (q in seq(length(nppi_items))) {
  for (x in seq(length(nppi_items[[q]]))) {
    magick::image_write(nppi_items[[q]][[x]], paste0("materials/Presentation_format/nppi/output/", names(nppi_items[[q]][x]), ".png"))
  }
}



## Reorder items ----------------------------------------------------------------

problems_numbered_ordered <- 
  c(
    
    # LOW PPV PROBLEMS
    c(
      problems_numbered[[1]][[1]]
      ,problems_numbered[[2]][[1]]
      ,problems_numbered[[3]][[1]]
      ,problems_numbered[[4]][[1]]
      ,problems_numbered[[5]][[1]]
      ,problems_numbered[[6]][[1]]
      ,problems_numbered[[7]][[1]]
      ,problems_numbered[[8]][[1]]
    ),
    
    # HIGH PPV PROBLEMS
    c(
      problems_numbered[[1]][[2]]
      ,problems_numbered[[2]][[2]]
      ,problems_numbered[[3]][[2]]
      ,problems_numbered[[4]][[2]]
      ,problems_numbered[[5]][[2]]
      ,problems_numbered[[6]][[2]]
      ,problems_numbered[[7]][[2]]
      ,problems_numbered[[8]][[2]]
    )
    
  )

## Response types ----------------------------------------------------------------

# path to responses folder
response_types_dir <- "materials/Response_type/"

# responses files
response_type_files <- dir(response_types_dir)

# paths to each response file
response_type_files_path <- paste0(response_types_dir, response_type_files)

# list with responses as char strings
responses <- lapply(response_type_files_path, 
                    function(x) readChar(con = x, nchars = file.info(x)$size))

# assing name to each response type
names(responses) <- gsub(".txt", "", response_type_files)

# Response types
invisible(lapply(responses, cat))

### Combine textual problems with response types ############################

# Bind response types to problems
problems_numbered_ordered_responses <-
  lapply(problems_numbered_ordered, function(x) 
    paste0(x, lapply(responses, paste0)))

# get question type names
responses_names <- names(responses)

# add question type posfix to each problem name
for (problem_loop in 1:length(problems_numbered_ordered_responses)) {
  # problem_loop=1  
  for (item_loop in 1:length(problems_numbered_ordered_responses[[problem_loop]])) {
    # item_loop=1
    
    # Add response bit to condition string
    problems_numbered_ordered_responses[[problem_loop]][[item_loop]] <- 
      gsub("([w|h])\\*\\*\n", paste0("\\1_", responses_names[item_loop], "**\n"), problems_numbered_ordered_responses[[problem_loop]][[item_loop]])
  }
}


## Eliminate PPV question in positive framework (pfab) problems. ----------------------------------------------------------------

# Loop to go through list of questions 
for (q in seq(length(questions))) {
  # q=1
  
  # get current question prefix (ca, pr)
  current_question_prefix <- substring(names(questions[q]), 0, 2)
  # get current question
  current_question  <- gsub("\\?\\n\\n\\n","",questions[[q]])
  
  # Loop to go through set of items (context x presentation format)
  for (p in seq(length(problems_numbered_ordered_responses))) {
    # p=3
    
    # Loop to go through items of each context x presentation format
    for (i in seq(length(problems_numbered_ordered_responses[[p]]))) {
      # i=1
      
      # If a positive framework problem with the current question is on the loop, then the ppv question is eliminated
      if (grepl(paste0(current_question_prefix, "_pfab.*_sg"), problems_numbered_ordered_responses[[p]][i])) {
        
        problems_numbered_ordered_responses[[p]][i] <-
          gsub(paste0(current_question, "\\?\\n\\n\\n"), "", problems_numbered_ordered_responses[[p]][i])
        
      }
    }
  }
}

## Problem contexts ----------------------------------------------------------------

# path to responses folder
context_dir <- "materials/Problem_context/input/"

# responses files
context_files <- dir(context_dir, pattern = ".txt")

# paths to each response file
context_files_path <- paste0(context_dir, context_files)

# list with responses as char strings
contexts <- lapply(context_files_path, 
                   function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each response type
names(contexts) <- gsub(".txt", "", context_files)



