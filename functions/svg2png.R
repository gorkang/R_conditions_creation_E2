# Function to convert svg files to png using inkscape and ubuntu terminal

svg2png <- function(svg_file) {
  
  # This parameters have to be defined outside the function!!!
        # svg_file <- "ca_factbox.svg" # svg file name
        # width <- 375 # pixels
        # height <- 260 # pixels
        # dpi <- 45 # dpi
        # input_dir <- "materials/Presentation format/Fact-boxs/input/template/svg/" # path to svg files
        # output_dir <- "materials/Presentation format/Fact-boxs/input/template/png/" # path to png output folder
  
  svg_file_name <- svg_file
  # path to png 
  png_file <- paste0(gsub(".svg", "", svg_file), ".png")
  
  # ubuntu terminal command
  svg_to_png_system_command <-
    paste0("inkscape -z -e '", output_dir, 
           png_file, 
           "' -w ", width, 
           " -h ", height, " '",
           input_dir, svg_file_name, "'")
  
  # run command line through terminal
  system(svg_to_png_system_command)
  
}
