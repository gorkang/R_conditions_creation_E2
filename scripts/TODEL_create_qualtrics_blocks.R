
# Pair each item with its correspondent follow-up

path2items <- "materials/qualtrics/output/separated_items/"
path2followup <- "materials/qualtrics/output/followUp/"

# Get items
items <- 
  dir(path2items) %>% 
  map(~readChar(paste0(path2items, .x), file.size(paste0(path2items, .x)))) %>% 
  unlist()

named_items <- 
  tibble(names = dir(path2items), items) %>% 
  mutate(names = gsub("\\.txt", "", names))

# Get follow-up
followups <- 
  dir(path2followup) %>% 
  map(~readChar(paste0(path2followup, .x), file.size(paste0(path2followup, .x)))) %>% 
  unlist()

named_followups <- 
  tibble(names = dir(path2followup), followups) %>% 
  mutate(names = gsub("\\.txt", "", names))

# Join items with followups

masterList <- rep(list(NULL), nrow(named_items))

for (z in 1:nrow(named_items)) {
  # z <- 1
  
  currRow <- named_items[z,]
  
  curr_context <- currROw$names %>% gsub("([a-z]{2})_[a-z]{4}_[a-z]*_[a-z]{2}", "\\1", .)
  # curr_prob <- currROw$names %>% gsub("[a-z]{2}_[a-z]{4}_([a-z]*)_[a-z]{2}", "\\1", .)
  
  followups_index <- grep(curr_context, named_followups$names)
  
  temp_list <- rep(list(NULL), length(followups_index))
  temp_list_name <- vector(mode = "character", length = length(followups_index))
  
  for (a in 1:length(followups_index)) {
    # a <- 1
    followup_risk <- 
      named_followups[[followups_index[a], "names"]] %>% 
      gsub("[a-z]{2}_fu_([a-z]*)", "\\1", .)
    item_name <- 
      currROw$names
    block_name <- 
      paste0(item_name, "_", followup_risk)
    
    block_str <- 
      paste0(currROw$items, "\n", named_followups[[followups_index[a], "followups"]])
    
    temp_block        <- as.list(block_str)
    names(temp_blocl) <- block_name
    
    temp_list[[a]] <- block_str
    temp_list_name[a] <- block_name
  }
 
names(temp_list) <- temp_list_name

masterList[[z]] <- temp_list

}

