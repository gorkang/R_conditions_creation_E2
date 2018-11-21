# READ SCALE

scales <- 
  scales2print %>% 
  map(~dir(.x, ".txt", full.names = TRUE)) %>% unlist() %>% map(~readChar(.x, file.size(.x))) %>% 
  set_names(., 
            gsub(".*Block\\:([a-z_0-9]*).*", "\\1", .)) # Capture name of each scale

# Function to remove rubish from scales (placeholders, qualtrics tagas, etc.)
clean_scale <- function(str) {
  str %>% 
    gsub("\\[{2}AdvancedFormat\\]{2}\\n", "", .) %>%                  # remove advanceformat tag
    gsub("\\[{2}Block\\:([a-z_0-9]*)\\]{2}", "## \\1", .) %>% # scale name
    gsub("\\[{2}Question.*?\\]{2}\\n", "", .) %>% # remove Question qualtrics format 
    gsub("\\[{2}ID\\:([a-zA-Z_0-9]*)\\]{2}", "  \n**\\1**", .) %>%        # question ID
    gsub("\\[{2}Choices\\]{2}\\n", "  \n", .) %>%  # remove choices qualtrics format 
    gsub("\\[{2}PageBreak\\]{2}\\n", "  \n", .) %>%  # remove page break qualtrics format 
    gsub("<span style='font-size\\:[0-9]{2}px;'>", "", .) %>%     # remove html tag
    gsub("</span>", "", .) %>%  # remove html tag
    gsub("<br>", " ", .) %>%  # remove html linebreak
    gsub("\\n", "  \n", .) %>% # double linebreaks because bookdown is weird
    gsub("DELETE_THIS", "", .) # remove DELETE_THIS
}

# Print Scales
scales %>% 
  map(~clean_scale(.x)) %>% 
  paste(., collapse = "\n\n-------------------------\n\n") %>% cat()
