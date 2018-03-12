

prev_x_ca <- 0.05652174
prev_x_pr1 <- 0.13352174
prev_x_pr2 <- 0.05652174
prev_y_1 <- 0.2562926
prev_y_2 <- 0.2792926
# absolute
prev_xca_pos <- prev_x_ca*img_width
prev_xpr1_pos <- prev_x_pr1*img_width
prev_xpr2_pos <- prev_x_pr2*img_width
prev_y1_pos <- prev_y_1*img_height
prev_y2_pos <- prev_y_2*img_height

# np template (cancer or pregnant) as list
nppi_img <- nppi_items[2]

# repeat template as many times as rows of set numbers csv
nppi_img_list <- rep(as.list(nppi_img), length(nppi_graphs))




# CANCER ####################################################
magick::image_annotate(

  magick::image_annotate(

    magick::image_composite(nppi_img_list[[1]], nppi_graphs[[1]], offset = paste0("+", graph_x_pos, "+", graph_y_pos)),

    paste0("At age XX, it is estimated that breast cancer is present in XX out of " ),
    font = "arial", size = 20, color = "black", boxcolor = "",
    degrees = 0, location = paste0("+", prev_xca_pos, "+", prev_y1_pos)),

  text = paste0("every ", names(nppi_graphs[1]), " women."),
  font = "arial", size = 20, color = "black", boxcolor = "",
  degrees = 0, location = paste0("+", prev_xca_pos, "+", prev_y2_pos))

# TRISOMY ####################################################

magick::image_annotate( 
  
  magick::image_annotate(
    
    magick::image_composite(nppi_img_list[[1]], nppi_graphs[[1]], offset = paste0("+", graph_x_pos, "+", graph_y_pos)), 
    
    paste0("At age XX, it is estimated that trisomy 21 is present in XX " ), 
    font = "arial", size = 20, color = "black", boxcolor = "",
    degrees = 0, location = paste0("+", prev_xpr1_pos, "+", prev_y1_pos)), 
  
  text = paste0("out of every ", names(nppi_graphs[1]), " births."), 
  font = "arial", size = 20, color = "black", boxcolor = "",
  degrees = 0, location = paste0("+", prev_xpr2_pos, "+", prev_y2_pos))
