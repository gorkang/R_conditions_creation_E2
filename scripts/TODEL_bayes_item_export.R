# Items are imported as Embedded data (ED) fields. One file per each condition 
# (6 pres_format x 2 prob_context x 2 ppv_prob x 2 followUp_risk ) is created.
# A total of 48 txt files are to be created. Each text file must contain the 
# following ED fields:
# - presentation format field
# - 01 problem context field
# - 02 problem context field
# - 01 ppv prob field
# - 02 ppv prob field
# - 01 followup risk
# - 02 followup risk

# - 01 prevalence field
# - 01 item field
# - 02 prevalence field
# - 02 item field

# Resources
source("scripts/html_qualtrics_codes.R")
source("functions/items2qualtrics.R") # function to convert txt files to qualtrics txt format

# separated item folder
separated_item_dir <- "materials/qualtrics/output/separated_items/"
response_types_dir <- "materials/qualtrics/input/reponse_type/"
paired_items_dir   <- "materials/qualtrics/output/paired_items/"

# All possible prevalences ------------------------------------------------
source("functions/get_prevalences.R")

all_prevalences <- 
  get_prevalences()

# Convert items to qualtrics txt advanced format --------------------------
text_output_dir <- "materials/text_output/"

textual_items <- 
  dir(text_output_dir, pattern = ".txt") %>% 
  map(~readChar(paste0(text_output_dir, .x), file.size(paste0(text_output_dir, .x))))

conditions <- 
  dir(text_output_dir, ".txt") %>% 
  gsub("\\.txt", "", .)


get_pair <- function(item_01) {
  # item_01 <- conditions[1]
  
  if (gsub("([a-z]{2})_[a-z]{4}_ppv[a-z]{3,4}", "\\1", item_01) == "ca") {
    context <- "pr"
  } else if (gsub("([a-z]{2})_[a-z]{4}_ppv[a-z]{3,4}", "\\1", item_01) == "pr") {
    context <- "ca"
  }
  
  if (gsub("[a-z]{2}_[a-z]{4}_ppv([a-z]{3,4})", "\\1", item_01) == "high") {
    ppv_prob <- "low"
  } else if (gsub("[a-z]{2}_[a-z]{4}_ppv([a-z]{3,4})", "\\1", item_01) == "low") {
    ppv_prob <- "high"
  }
  
  item_02 <-
    paste0(context, "_",
           gsub("[a-z]{2}_([a-z]{4})_ppv[a-z]{3,4}", "\\1", item_01), "_",
           "ppv", ppv_prob)
  
  item_02
  
}  


item_pairs <-
conditions %>% 
  as.tibble() %>% 
  rename(item_01 = value) %>% 
  mutate(item_02 = 
           conditions %>% 
           map(~get_pair(.x)) %>% 
           unlist()) %>% 
  filter(row_number() <= length(conditions)/2)


item_pairs$item_01 %>% 
  walk(~items2qualtrics(list_of_items = .x, outputdir = "materials/text_output/item_blocks/", removePlaceholders = TRUE))

# problems_numbered_ordered_responses %>% 
#   walk(~items2qualtrics(list_of_items = .x, responsesdir = response_types_dir, outputdir = separated_item_dir, removePlaceholders = TRUE))

# # pair items: different context, same presentation format, different ppv prob, same response type
# # function to pair items
# source("functions/pair_items.R")
# 
# # items_txt <- dir(output_dir, pattern = ".txt")
# txt_files <- dir(separated_item_dir, pattern = ".txt")
# twins <- character(length(txt_files)/2)
# 
# txt_files %>%
#   walk(~pair_items(txt_files = .x, separated_item_dir = separated_item_dir, twins = twins, outputdir = paired_items_dir))


