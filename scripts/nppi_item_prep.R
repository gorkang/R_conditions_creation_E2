# Pictoric presentation formats -------------------------------------------

# read csv with number
numbers_item <-
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")

# Convert svg templates to png templates ----------------------------------

# path to factboxs templates
newparadigm_template_dir <- "materials/Presentation_format/nppi/input/template/svg/"

# factboxs templates files
newparadigm_templates <- dir(newparadigm_template_dir, pattern = ".svg")

# svg to png parameters (to feed svg2png)
nppi_width <- 690 # pixels
nppi_height <- 1169 # pixels

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
walk(newparadigm_templates, svg2png)

# newparadigm png dir
newparadigm_dir <- output_dir

# factbox png files
newparadigm_files <- dir(newparadigm_dir, pattern = ".png")

# read factbox imgs to a list
nppi_items <- map(newparadigm_files, ~magick::image_read(paste0(newparadigm_dir, .x)))

# name imgs
names(nppi_items) <- 
  gsub(".png", "", newparadigm_files)

rm(height,width,input_dir,newparadigm_dir,newparadigm_files,newparadigm_template_dir,newparadigm_templates,nppi_height,nppi_width,output_dir)

# Create ppv graphs -------------------------------------------------------

# Read csv with prevalences by age
age_prevalence <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls", sheet = 2)

# Test parameters (Two different tests)
numbers_nppi <-
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>%
  filter(format == "nppi")

# Check number of contexts. It must be the same number of graphs
problem_contexts <- dir("materials/Problem_context/input/", pattern = ".txt") %>% grep("txt_", ., value = TRUE)

# Graph parameters
age_ppv_to_plot <- c(20,25,30,35,40)
x_axis_label <- c("Age of the mother", "Age of the woman")
y_axis_label    <- "Test reliability"

width <- 10
height <- 6
dpi <- (magick::image_info(nppi_items[[1]])$width-40)/10

# output folder
graph_output_folder <- "materials/Presentation_format/nppi/input/graphs/png/"

# If Folder does not exist, create it
dir.create(file.path(graph_output_folder), showWarnings = FALSE, recursive = TRUE)

#TODO: dinamically build this names
# PPV graph name
graph_png_file_name <- c("nppi_ppv_pr_graph", "nppi_ppv_ca_graph")

# Path to folder to save graph
png_file_pathname <-
  paste0(graph_output_folder, graph_png_file_name, ".png") # path and name to new png file

# Get ppv in a scale between 0 and 100
age_prevalence <- mutate(age_prevalence, PPV_100 = PPV*100)

# UNCOMMENT TO select ages to plot on ppv graph
# age_prevalence_plot <-
#   age_prevalence %>% 
#   filter(age %in% age_ppv_to_plot)

# TODO: possible to create graphs dinamically? Why is there one for each context? The only context-dependent part is the xlab (xlab(grep("woman", x_axis_label, value = TRUE))). To fix this it is necessary to fix the TODO (line 64)
for (cCntxt in seq(length(problem_contexts))) {
  # cCntxt <- 1
  
  if (grepl("ca", problem_contexts[[cCntxt]])) {
    
    ppv_graph <-
      ggplot(age_prevalence, aes(x=age, y=PPV_100)) + # plot canvas
      scale_y_continuous(labels=function(x) paste0(x,"%"), # append % to y-axis value
                         limits = c(0,100)
                         # , breaks = seq(0,100,10)
      ) + # set y-axis limits
      geom_point(size = 5.5, color = "#009999", shape = 19) + # insert points with ppv value
      geom_line(aes(x=age, y=PPV_100), color = "#009999", size = 2) +  
      theme_minimal() + # insert line bridging PPV-value points
      xlab(grep("woman", x_axis_label, value = TRUE)) + ylab(y_axis_label) + # set axis labels
      theme(axis.text = element_text(size = 25), # axis-numerbs size
            axis.title = element_text(size = 25)) + # axis-labels size
      geom_text(aes(label = 
                      case_when(age %in% age_ppv_to_plot ~ paste0(round(PPV_100, 0), "%"), TRUE ~ paste0("")), # keep only ages previously set to be ploted
                    hjust = 1, vjust = -1), size = 6) # (position) plot ppv-values above points set in "age_ppv_to_plot"
    
    
    # Save plot to png file
    ggsave(filename = grep(gsub(".*(ca).*|.*(pr).*", "\\1\\2", problem_contexts[cCntxt]), png_file_pathname, value = TRUE), 
           plot = ppv_graph, width = width, height = height, dpi = dpi, units = "in")
    
  } else if (grepl("pr", problem_contexts[[cCntxt]])) {
    
    ppv_graph <-
      ggplot(age_prevalence, aes(x=age, y=PPV_100)) + # plot canvas
      scale_y_continuous(labels=function(x) paste0(x,"%"), # append % to y-axis value
                         limits = c(0,100)
                         # , breaks = seq(0,100,10)
      ) + # set y-axis limits
      geom_point(size = 5.5, color = "#009999", shape = 19) + # insert points with ppv value
      geom_line(aes(x=age, y=PPV_100), color = "#009999", size = 2) +  # insert line bridging PPV-value points
      theme_minimal() + 
      xlab(grep("mother", x_axis_label, value = TRUE)) + ylab(y_axis_label) + # set axis labels
      theme(axis.text = element_text(size = 25), # axis-numerbs size
            axis.title = element_text(size = 25)) + # axis-labels size
      geom_text(aes(label = 
                      case_when(age %in% age_ppv_to_plot ~ paste0(round(PPV_100, 0), "%"), TRUE ~ paste0("")), # keep only ages previously set to be ploted
                    hjust = 1, vjust = -1), size = 6) # (position) plot ppv-values above points set in "age_ppv_to_plot"
    
    
    # Save plot to png file
    ggsave(filename = grep(gsub(".*(ca).*|.*(pr).*", "\\1\\2", problem_contexts[cCntxt]), png_file_pathname, value = TRUE), 
           plot = ppv_graph, width = width, height = height, dpi = dpi, units = "in")
    
  }
}

rm(graph_png_file_name,png_file_pathname)
rm(age_ppv_to_plot,dpi,graph_output_folder,height,width,x_axis_label,y_axis_label)
##### Compose new-paradigm brochure ###################################################

# graphs dir
graph_dir <- "materials/Presentation_format/nppi/input/graphs/png/"

# get graphs file names
nppi_graphs_files_names <- grep("ppv.*png", dir(graph_dir), value = TRUE)

# Read graphs into list
nppi_graphs <- map(nppi_graphs_files_names, ~magick::image_read(paste0(graph_dir, .x)))

# Name graphs
names(nppi_graphs) <- gsub(".png", "", nppi_graphs_files_names)

# Template dimensions
img_width <- magick::image_info(nppi_items[[1]])$width
img_height <- magick::image_info(nppi_items[[1]])$height

# Prevalence position in template (%)
# relateive
prev_ca_x <- 0.05852174
prev_pr_x_1 <- 0.13352174
prev_pr_x_2 <- 0.05852174
prev_y_1 <- 0.2562926
prev_y_2 <- 0.2792926
# absolute
prev_xca_pos <- prev_ca_x*img_width
prev_xpr1_pos <- prev_pr_x_1*img_width
prev_xpr2_pos <- prev_pr_x_2*img_width
prev_y1_pos <- prev_y_1*img_height
prev_y2_pos <- prev_y_2*img_height

# Graph position in template
# relateive
graph_x <- 0.02898551
graph_y <- 0.5731394
# absolute
graph_x_pos <- graph_x*img_width
graph_y_pos <- graph_y*img_height

# TODO: possible to create graphs dinamically? Why is there one for each context?
for (i in seq(length(nppi_items))){
  # i=1
  
  # Get nnpi template
  nppi_img <- nppi_items[i]
  
  # repeat template as many times as the number of graphs
  nppi_img_list <- rep(as.list(nppi_img), nrow(numbers_nppi))
  
  for (j in seq(nrow(numbers_nppi))) {
    # j=1
    
    if (grepl("_ca", names(nppi_items[i]))) {
      
      # CANCER ####################################################
      nppi_img_list[[j]] <-
        magick::image_annotate(
          
          magick::image_annotate(
            
            magick::image_composite(nppi_img_list[[i]], nppi_graphs[[gsub(".png", "", grep("_ca_", nppi_graphs_files_names, value = TRUE))]], offset = paste0("+", graph_x_pos, "+", graph_y_pos)),
            
            paste0("At age ", numbers_nppi[[j, "age"]], ", it is estimated that breast cancer is present in ", numbers_nppi[[j, "prev_01"]], " out " ),
            font = "arial", size = 20, color = "black", boxcolor = "",
            degrees = 0, location = paste0("+", prev_xca_pos, "+", prev_y1_pos)),
          
          text = paste0("of every ", numbers_nppi[[j, "prev_02"]], " women."),
          font = "arial", size = 20, color = "black", boxcolor = "",
          degrees = 0, location = paste0("+", prev_xca_pos, "+", prev_y2_pos))
      
      
    } else if (grepl("_pr", names(nppi_items[i]))) {
      # TRISOMY ####################################################
      
      nppi_img_list[[j]] <-
        magick::image_annotate(
          
          magick::image_annotate(
            
            magick::image_composite(nppi_img_list[[i]], nppi_graphs[[gsub(".png", "", grep("_pr_", nppi_graphs_files_names, value = TRUE))]], offset = paste0("+", graph_x_pos, "+", graph_y_pos)),
            
            paste0("At age ", numbers_nppi[[j, "age"]], ", it is estimated that trisomy 21 is present in ", numbers_nppi[[j, "prev_01"]]),
            font = "arial", size = 20, color = "black", boxcolor = "",
            degrees = 0, location = paste0("+", prev_xpr1_pos, "+", prev_y1_pos)),
          
          text = paste0("out of every ", numbers_nppi[[j, "prev_02"]], " births."),
          font = "arial", size = 20, color = "black", boxcolor = "",
          degrees = 0, location = paste0("+", prev_xpr2_pos, "+", prev_y2_pos))
      
    }
  }
  
  ppv_prob <- as.character(numbers_nppi[["prob"]])
  
  names(nppi_img_list) <- paste0(names(nppi_img_list), "_", ppv_prob)
  
  nppi_items[[i]] <- nppi_img_list
  
  if (i == length(nppi_items)) {
    rm(i,j,nppi_img, nppi_img_list)
  }
}

# Write images
nppi_output_folder <- "materials/Presentation_format/nppi/output/"

# If Folder does not exist, create it
dir.create(file.path(nppi_output_folder), showWarnings = FALSE, recursive = TRUE)

for (q in seq(length(nppi_items))) {
  for (x in seq(length(nppi_items[[q]]))) {
    magick::image_write(nppi_items[[q]][[x]], paste0(nppi_output_folder, names(nppi_items[[q]][x]), ".png"))
  }
  if (q == length(nppi_items)) {
    rm(q,x)
  }
}

rm(list = c(grep("graph_", ls(), value = TRUE),
            grep("prev_", ls(), value = TRUE)))
rm(img_height, img_width,
   nppi_graphs_files_names, nppi_output_folder,
   nppi_graphs, age_prevalence, ppv_prob, cCntxt, problem_contexts)
# Problem contexts --------------------------------------------------------

# Read problem contexts ####
# path to responses folder
context_dir <- "materials/Problem_context/input/"

# responses files
context_files <- dir(context_dir, pattern = ".txt") %>% grep("txt_", ., value = TRUE)

# paths to each response file
context_files_path <- paste0(context_dir, context_files)

# list with responses as char strings
nppi_context <- lapply(context_files_path, 
                       function(x) readChar(con = x, nchars = file.info(x)$size)) 

nppi_context <-
  map2(gsub("txt_(.*).txt", "***\\1***", context_files), nppi_context, paste0)


rm(context_dir,context_files,context_files_path)

# high/low prob filling ####

# put prevalences on contexts using number bayes

for (c_context in seq(nppi_context)) {
  # c_context <- 1
  current_context <- 
    as.list(rep(nppi_context[[c_context]], nrow(numbers_nppi)))
  
  for (c_prob in seq(nrow(numbers_nppi))) {
    # c_prob <- 1
    
    # put age and prevalence using numbers table
    current_context[[c_prob]] <- 
      gsub("age_variable", numbers_nppi[["age"]][c_prob], 
           gsub("prevalence_02_variable", numbers_nppi[["prev_02"]][c_prob], 
                current_context[[c_prob]]))
  }
  
  current_context <- map2(numbers_nppi[["prob"]], current_context, function(x,y) {
  # add ppv prob to name
      gsub("(\\*\\*\\*.*_)(.*\\*\\*\\*.*)", paste0("\\1", x, "_\\2"), y)  
    })
  
  nppi_context[[c_context]] <- current_context
  
  # trash remove
  if (c_context == length(nppi_context)) {
    rm(c_context,c_prob, current_context)
  }
}

nppi_context <-
  as.list(unlist(nppi_context))

# Responses type pictorial ------------------------------------------------

# path to responses folder
response_types_dir <- "materials/Response_type/"

# responses files
response_type_files <- dir(response_types_dir, pattern = "*.txt")

# paths to each response file
response_type_files_path <- paste0(response_types_dir, response_type_files)

# list with responses as char strings
responses_pic <- 
  map(response_type_files_path, ~readChar(con = .x, nchars = file.info(.x)$size))
# assing name to each response type
names(responses_pic) <- gsub(".txt", "", response_type_files)

## sequential guided question fillers
sg_fillers <- read_csv("materials/Response_type/sg_fillers/sg_fillers.csv", col_types = "cccc")

# fields to loop through
tobefilled <- paste0("__", grep("[A-Z]", names(sg_fillers), value = TRUE), "__")
tofill     <- grep("[A-Z]", names(sg_fillers), value = TRUE)

temp_sg <- responses_pic$sg
responses_pic$sg <- rep(responses_pic$sg, nrow(sg_fillers))

# filled sg accodring to each problem context
for (cC in seq(nrow(sg_fillers))) {
  # cC = 2
  temp_sg <- responses_pic$sg[cC]
  
  for (fC in seq(length(tobefilled))) {
    # fC = 1
    temp_sg <- gsub(tobefilled[fC], sg_fillers[cC, tofill[fC]], temp_sg)
  }
  responses_pic$sg[cC] <- temp_sg
}

rm(response_type_files,response_type_files_path,response_types_dir, numbers_item, numbers_nppi, sg_fillers)

