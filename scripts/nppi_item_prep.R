
# Pictoric presentation formats -------------------------------------------

# read csv with number
numbers_item <-
  # readr::read_csv("materials/Numbers/numbers_bayes.csv")#, col_types = cols())
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")#, col_types = cols())

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

  # If Folder does not exist, create it
  dir.create(file.path(output_dir), showWarnings = FALSE, recursive = TRUE)

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

#### New-paradigm ###################################################

##### Create ppv graphs

# Read csv with prevalences by age
age_prevalence <- 
  # readr::read_csv("materials/Presentation_format/nppi/input/graphs/age_prevalence_OLD.csv", col_types = "iii")
  readxl::read_xls("materials/Numbers/numbers_bayes.xls", sheet = 2)

# Create column with prevalence percentage
age_prevalence <- 
  age_prevalence %>% 
  mutate(prevalence_percentage = prevalence_01/prevalence_02)

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

graph_output_folder <- "materials/Presentation_format/nppi/input/graphs/png/"

  # If Folder does not exist, create it
  dir.create(file.path(graph_output_folder), showWarnings = FALSE, recursive = TRUE)


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
    paste0(graph_output_folder, graph_png_file_name, "_graph.png") # path and name to new png file
  
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

# To name graphs it's necessary to know how many contexts we are working with.
# context_number <- length(dir("materials/Problem_context/input/", "*context.txt"))

# names(nppi_graphs) <- paste0(numbers_item_nppi_graphs$prev_02, " births.")
names(nppi_graphs) <- paste0(numbers_item_nppi_graphs$prev_02)

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
    
    # IF cancer
    if (grepl("_ca", names(nppi_items[i]))) {
      # assemble_graph use this object
      nppi_img_list[[j]] <- magick::image_annotate(magick::image_composite(nppi_img_list[[i]], nppi_graphs[[j]], offset = paste0("+", graph_x_pos, "+", graph_y_pos)), paste0(names(nppi_graphs[j]), " women."), 
                                                   font = "arial", size = 19, color = "black", boxcolor = "",
                                                   degrees = 0, location = paste0("+", prev_x_pos, "+", prev_y_pos))
      
      # IF pregnant
    } else if (grepl("_pr", names(nppi_items[i]))) {
      # assemble_graph use this object
      nppi_img_list[[j]] <- magick::image_annotate(magick::image_composite(nppi_img_list[[i]], nppi_graphs[[j]], offset = paste0("+", graph_x_pos, "+", graph_y_pos)), paste0(names(nppi_graphs[j]), " births."), 
                                                   font = "arial", size = 19, color = "black", boxcolor = "",
                                                   degrees = 0, location = paste0("+", prev_x_pos, "+", prev_y_pos))
      
    }
  }
  
  graph_name <- as.character(numbers_nppi[["prob"]])
  
  names(nppi_img_list) <- paste0(names(nppi_img_list), "_", graph_name)
  
  nppi_items[[i]] <- nppi_img_list
  
}

# Write images
nppi_output_folder <- "materials/Presentation_format/nppi/output/"

  # If Folder does not exist, create it
  dir.create(file.path(nppi_output_folder), showWarnings = FALSE, recursive = TRUE)

for (q in seq(length(nppi_items))) {
  for (x in seq(length(nppi_items[[q]]))) {
    magick::image_write(nppi_items[[q]][[x]], paste0(nppi_output_folder, names(nppi_items[[q]][x]), ".png"))
  }
}
  
# Problem contexts --------------------------------------------------------
  
  # Read problem contexts ####
      # path to responses folder
      context_dir <- "materials/Problem_context/input/"
      
      # responses files
      context_files <- dir(context_dir, pattern = "text.txt")
      
      # paths to each response file
      context_files_path <- paste0(context_dir, context_files)
      
      # list with responses as char strings
      nppi_context <- lapply(context_files_path, 
                             function(x) readChar(con = x, nchars = file.info(x)$size)) 
      
      # assing name to each response type
      names(nppi_context) <- gsub(".txt", "", context_files)
  
  # high/low prob filling ####
  
      # put prevalences on contexts using number bayes
      # nppi_context <- 
      
      for (c_context in seq(nppi_context)) {
        # c_context <- 1
        current_context <- as.list(rep(nppi_context[[c_context]], nrow(numbers_nppi)))
        
        for (c_prob in seq(nrow(numbers_nppi))) {
          # c_prob <- 1
          
          current_context[[c_prob]] <- 
            gsub("age_variable", numbers_nppi[["age"]][c_prob], gsub("prevalence_02_variable", numbers_nppi[["prev_02"]][c_prob], current_context[[c_prob]]))
        }
        names(current_context) <- paste0("nppi_context_", numbers_nppi[["prob"]], "_ppv")
        
        nppi_context[[c_context]] <- current_context
      }
      
      

# Responses type pictorial ------------------------------------------------

      # path to responses folder
      response_types_dir <- "materials/Response_type/"
      
      # responses files
      response_type_files <- dir(response_types_dir, pattern = "*.txt")
      
      # paths to each response file
      response_type_files_path <- paste0(response_types_dir, response_type_files)
      
      # list with responses as char strings
      responses_pic <- lapply(response_type_files_path, 
                          function(x) readChar(con = x, nchars = file.info(x)$size))
      
      # assing name to each response type
      names(responses_pic) <- gsub(".txt", "", response_type_files)
      
      # Customize sequential guided response type
      responses_pic$sg <- apply(sg_fillers, 1, function(x) { 
        
        gsub("__CONDITION__", x[["condition"]],
             gsub("__TEST__", x[["test"]], 
                  gsub("__WHO__", x[["who"]], responses_pic$sg)))
        
      })