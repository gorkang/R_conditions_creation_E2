# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr, mgsub)

source("scripts/html_qualtrics_codes.R")

# Severity and emotional reaction scale
source("scripts/scale_severity.R")

# A priori screening belief
source("scripts/scale_apriori.R")

# READ SCALE
scales <- 
  c("materials/qualtrics/output/plain_text/scales/apriori_belief", 
    "materials/qualtrics/output/plain_text/scales/severity_emotion/partial") %>% 
  map(~dir(.x, ".txt", full.names = TRUE)) %>% unlist() %>% map(~readChar(.x, file.size(.x))) %>% 
  set_names(., 
            gsub(".*Block\\:([a-z_0-9]*).*", "\\1", .)) # Capture name of each scale

# Function to remove rubish from scales (placeholders, qualtrics tagas, etc.)
clean_scale <- function(str) {
  str %>% 
    gsub("\\[{2}Block\\:([a-z_0-9]*)\\]{2}", "**Scale: \\1**", .) %>% # scale name
    gsub("\\[{2}AdvancedFormat\\]{2}\\n", "", .) %>%                  # remove advanceformat tag
    gsub("\\[{2}ID\\:([a-zA-Z_0-9]*)\\]{2}", "**\\1**", .) %>%        # question ID
    gsub('<span style="font-size\\:[0-9]{2}px;">', "\\1 ", .) %>%     # remove html tag
    gsub('</span>', "", .) %>%  # remove html tag
    gsub("\\[{2}Question.*?\\]{2}\\n", "", .) %>% # remove Question qualtrics format 
    gsub("\\[{2}Choices\\]{2}\\n", "", .) %>%  # remove choices qualtrics format 
    gsub("\\n", "\n\n", .) %>% # double linebreaks because bookdown is weird
    gsub("DELETE_THIS", "", .) # remove DELETE_THIS
}

