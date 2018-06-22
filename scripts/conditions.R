# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# Manipulations -----------------------------------------------------------

# # Betweem
press_formats <- c("nfab", "prre", "prab", "pfab", "nppi", "fbpi")
resp_type     <- c("gi", "gs", "sg", "ss")
# # Within
prob_context <- c("ca", "pr")
ppv_prob     <- c("high", "low")

# Within conditions -------------------------------------------------------

# There are four possible problem context x ppv probability combinations
between_combinations <-
  expand.grid(prob_context, ppv_prob) %>% 
  setNames(., c("prob_context", "ppv_prob")) 

# Create items combinations
# # if ca, then pr (and viceversa)
# # if high, then low (and viceversa)

item_pairs <-
  between_combinations %>% 
  mutate(item_01 = paste0(prob_context, "_", ppv_prob)) %>% 
  mutate(prob_context_02 = case_when(prob_context == "ca" ~ "pr",
                                     prob_context == "pr" ~ "ca"),
         ppv_prob_02 = case_when(ppv_prob == "high" ~ "low",
                                 ppv_prob == "low" ~ "high")) %>% 
  mutate(item_02 = paste0(prob_context_02, "_", ppv_prob_02)) %>% 
  select(matches("item")) %>% 
  transmute(items = paste0(item_01, "_", item_02))

# 96 possible conditions (only considering the screening task)
# # 6 x presentation formats
# # 2 x problem contexts
# # 2 x ppv probability
# # 4 x response types
screening_conditions <- 
  expand.grid(press_formats, resp_type, pull(item_pairs)) %>% 
  set_names(., c("presentation_format", "response_type", "items"))


# Follow-up ---------------------------------------------------------------
followUp_risk <- c("riskHigh", "riskLow")

followUp_items <-
  expand.grid(followUp_risk, followUp_risk) %>% 
  filter(!Var1 == Var2) %>% 
  transmute(followUps = paste0(Var1, "_", Var2)) %>% 
  pull()

# Complete conditions -----------------------------------------------------
# # 96 x screening conditions
# # 2 x follow-up risks

screening_items <-
  as.tibble(screening_conditions) %>% 
  unite(., sep = "_", col = "screening_items") %>% 
  pull()

actually_all_conditions <- 
  expand.grid(screening_items, followUp_items) %>% 
  set_names(., c("screening", "followUp")) %>% 
  as.tibble()

# Sepate each info in a column
actually_all_conditions_sep <- 
  actually_all_conditions %>% 
  separate(., col = "screening", sep = "_", 
           into = c("press_format", "resp_type", "prob_context_01", "ppv_prob_01", "prob_context_02", "ppv_prob_02") ) %>% 
  separate(., col = "followUp", sep = "_", 
           into = c("followUp_01", "followUp_02"))

actually_all_conditions_sep <-
  actually_all_conditions_sep %>% 
  mutate(item_file_name_01 = paste0(prob_context_01, "_", press_format, "_ppv", ppv_prob_01),
         item_file_name_02 = paste0(prob_context_02, "_", press_format, "_ppv", ppv_prob_02)) %>% 
  mutate(med_cond_01 = case_when(prob_context_01 == "ca" ~ "breast cancer",
                                     prob_context_01 == "pr" ~ "trisomy 21", 
                                     TRUE ~ as.character(NA)),
         med_cond_02 = case_when(prob_context_02 == "ca" ~ "breast cancer",
                                     prob_context_02 == "pr" ~ "trisomy 21", 
                                     TRUE ~ as.character(NA)))

actually_all_conditions_sep %<>% 
  mutate(complete_name = paste(press_format, resp_type, prob_context_01, ppv_prob_01, prob_context_02, ppv_prob_02, followUp_01, followUp_02, sep = "_"))

# Write table to a file
write_csv(actually_all_conditions_sep, "materials/conditions.csv")
