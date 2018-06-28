# placeholder pattern
pattern <- "\\[\\[\\[.*?\\]\\]\\]"

# read scale template (already with Qualtrics tags)
scale_template <- 
  "materials/Scales/input/severity_emotional_reaction.txt" %>% 
  readChar(., file.size(.))

# Indicate questions and choices size
scale_template <- 
  scale_template %>% gsub("Q_FONT_SIZE", "22", .) %>% gsub("C_FONT_SIZE", "16", .)

# separate questions (using preset separator)
scale_sep <-
  scale_template %>% str_split(., "\n__QSEP__\n") %>% unlist() %>% 
  as.list()

# separate questions by number of placeholdesr
simple_question <- scale_sep[1:2]
double_question <- scale_sep[3] %>% unlist()

# function to replace placeholders of questions with one placeholder
replace_questions <- function(str_question){
  reps <-
    str_question %>% str_extract_all(., pattern) %>% 
    unlist() %>% gsub("\\[", "", .) %>% gsub("\\]", "", .) %>% 
    strsplit(x = ., split = "/") %>% unlist()
  
  # str_question <- 
  str_question %>% gsub(pattern, "REPLACE", .) %>% 
    str_replace(., "REPLACE", reps) %>% str_replace(., "(.*)", paste0("**", reps, "**\\1"))
}

# REPLACE placeholders (also gets replacements)!
simple_question <- 
  simple_question %>% 
  map(~replace_questions(.x))

# Get replacements of questions with more than one placeholder
reps <-
  double_question[[1]] %>% str_extract_all(., pattern) %>% 
  unlist() %>% gsub("\\[", "", .) %>% gsub("\\]", "", .) %>% 
  strsplit(., "/")

# get placeholders to be replaced
to_rep <- 
  double_question[[1]] %>% 
  str_extract_all(., pattern) %>% unlist() %>% gsub("\\[", "\\\\[", .) %>% gsub("\\]", "\\\\]", .)

# function to replace placeholders of questions with more than one placeholder
replace_question_double <- function(x) {
  
  mgsub(string = double_question, 
        pattern = to_rep, 
        replacement = x)
  
}

# REPLACE placeholders in questions with more than one placeholder
double_question <- 
  reps %>% 
  transpose(.) %>% 
  map(~unlist(.x)) %>% 
  map(~replace_question_double(.x)) %>% 
  unlist() %>% 
  paste0("**", reps[[1]], "**", .)

# All questions
sev_emo_scale <- 
  c(simple_question, list(double_question)) 

# Get breast cancer question and remove names. Also put ID to questions
severity_emo_breastcancer_scale <- 
  sev_emo_scale %>% 
  unlist() %>% grep("breast|mastectomy", ., value = TRUE) %>% 
  gsub("\\*\\*.*\\*\\*", "", .) %>% 
  str_replace_all(., "replaceID", paste0("sevEmo_brca_0", seq(5)))
# Get trisomy 21 question and remove names. Also put ID to questions
severity_emo_trisomy21_scale <-
  sev_emo_scale %>% 
  unlist() %>% grep("abortion|Down", ., value = TRUE) %>% 
  gsub("\\*\\*.*\\*\\*", "", .) %>% 
  str_replace_all(., "replaceID", paste0("sevEmo_tr21_0", seq(5)))

# Export scales
# output dir
scales_folder_partial <- 
  "materials/qualtrics/output/plain_text/scales/severity_emotion/partial" %T>% 
  dir.create(., FALSE, TRUE)
# export breast cancer scale
severity_emo_breastcancer_scale %>% 
  paste(., collapse = "\n") %>% 
  paste(gsub("block_name", "severity_emo_breastcancer", qualtrics_codes$block_start), ., sep = "\n") %>% 
  cat(., file = file.path(scales_folder_partial, "severity_emo_breastcancer.txt"))
# export trisomy 21 scale
severity_emo_trisomy21_scale %>% 
  paste(., collapse = "\n") %>% 
  paste(gsub("block_name", "severity_emo_trisomy21", qualtrics_codes$block_start), ., sep = "\n") %>% 
  cat(., file = file.path(scales_folder_partial, "severity_emo_trisomy21.txt"))

# read separated scales and export them as two blocks in one file
# output dir
scales_folder_complete <- 
  "materials/qualtrics/output/plain_text/scales/severity_emotion/complete" %T>% 
  dir.create(., FALSE, TRUE)

# read files
scales_folder_partial %>% 
  dir(., ".txt") %>% 
  file.path(scales_folder_partial, .) %>% 
  map(~readChar(con = .x, nchars = file.size(.x))) %>% 
  paste(., collapse = "\n") %>% 
  # add advanced format qualtrics tag
  paste(qualtrics_codes$advanced_format, ., sep = "\n") %>% 
  # export
  cat(., file = file.path(scales_folder_complete, "scale_severity_emotion.txt"))

