# # placeholder pattern 
# pattern <- "\\[\\[\\[.*?\\]\\]\\]" 



# read scale template (already with Qualtrics tags) 
scale_template <-  
  "materials/Scales/input/severity_emotional_reaction.txt" %>%  
  readChar(., file.size(.)) 

# Indicate questions and choices size 
scale_template <-  
  scale_template %>% gsub("Q_FONT_SIZE", "22", .) %>% gsub("C_FONT_SIZE", "16", .) 

# separate questions (using preset separator) 
scale_sep <- 
  scale_template %>% str_split(., "\n__QSEP__\n") %>% unlist()

# Separate questions in context-dependant and general
context_questions_ca <- scale_sep[1:6]
context_questions_pr <- scale_sep[1:6]
general_questions <- scale_sep[7:8]

# Get fillers
sevEmoFillers <- 
  read_csv("materials/fillers.csv", col_types = cols()) %>% 
  filter(grepl("sevEmo", field_name))
# filler names
fillerNames <- 
  sevEmoFillers$field_name

# Fill cancer questions
for (i in seq(fillerNames)){
fillerValue <- 
  sevEmoFillers %>% 
  filter(field_name == fillerNames[i]) %>% 
  select(ca) %>% pull()

context_questions_ca <- 
  context_questions_ca %>% 
  gsub(fillerNames[i], fillerValue, .)
}
# Fill trisomy 21 questions
for (i in seq(fillerNames)){
  fillerValue <- 
    sevEmoFillers %>% 
    filter(field_name == fillerNames[i]) %>% 
    select(pr) %>% pull()
  
  context_questions_pr <- 
    context_questions_pr %>% 
    gsub(fillerNames[i], fillerValue, .)
}

# Bind all questions
sevEmo_scale <- c(context_questions_ca, context_questions_pr, general_questions)
# Put IDs on questions
sevEmo_scale <- 
  sevEmo_scale %>% 
  str_replace_all(., "replaceID", paste0("sevEmo_", sprintf("%02d", 1:sum(str_detect(., "replaceID")))))

# Export
# create folder
export_path <- 
"materials/qualtrics/output/plain_text/scales/severity_emotion_scale" %T>% 
  dir.create(., FALSE, TRUE) 

sevEmo_scale %>% 
  paste(., collapse = "\n") %>% 
  # Add advance format and block qualtrics tag
  paste(qualtrics_codes$advanced_format, gsub("block_name", "severity_emotion_scale", qualtrics_codes$block_start), ., sep = "\n") %>% 
  cat(., sep = "\n", file = file.path(export_path, "severity_emotion_scale.txt"))
