# # placeholder pattern 
# pattern <- "\\[\\[\\[.*?\\]\\]\\]" 

subtext_fontsize <- 18
scaleanchors_fontsize <- 16

# Export
# create folder
export_path <- 
  "materials/qualtrics/output/plain_text/scales/severity_emotion_scale" %T>% 
  dir.create(., FALSE, TRUE) 

# read scale template (already with Qualtrics tags) 
scale_template <-  
  "materials/Scales/input/severity_emotional_reaction.txt" %>%  
  readChar(., file.size(.)) 
# Separate items and blocks
all_items <-
  scale_template %>% 
  gsub('\\n$', '', .) %>%
  str_split(., '\n+__QSEP__\n') %>% 
  unlist() %>% 
  str_replace_all(string = ., 
                  pattern = 'question_id', 
                  replacement = paste0('sevEmo_', sprintf('%02d', 1:16)))


# # Format block 01
# block01 <- 
#   all_items[[1]] %>% 
#   str_replace(string = html_codes$question_font_size, pattern = 'QUESTION_TEXT_TO_FORMAT', replacement = .) %>% 
#   paste(qualtrics_codes$question_singlechoice_vertical, qualtrics_codes$question_id, ., sep = '\n')
# # Format block 02
# block02 <- all_items[[2]] %>% 
#   paste(qualtrics_codes$question_singlechoice_vertical, qualtrics_codes$question_id, ., sep = '\n')
# # Format block 02
# block03 <- all_items[[3]] %>% 
#   paste(qualtrics_codes$question_singlechoice_vertical, qualtrics_codes$question_id, ., sep = '\n')

# Block titles
block01_title <- 'Medical screenings and procedures'
block02_title <- 'How do the following medical procedures, issues, and conditions make you feel?'
block03_title <- 'Rate the following medical procedures, issues and conditions'

# Format font size, block, question and ID
block_titles <-
  c(block01_title, block02_title, block03_title) %>%
  str_replace(string = html_codes$title_font_size, pattern = 'QUESTION_TEXT_TO_FORMAT', replacement = .) %>% 
  paste(qualtrics_codes$block_start, qualtrics_codes$question_only_text, qualtrics_codes$question_id, ., qualtrics_codes$pagebreak, sep = '\n')
# ID blocks
block_titles <- 
  block_titles %>% 
  str_replace_all(., 'question_id', paste0('sevEmoTit', sprintf('%02d', 1:3))) %>% 
  str_replace_all(., 'block_name', paste0('severity_emo_block_', sprintf('%02d', 1:3)))

# Bind blocks and questions
c(qualtrics_codes$advanced_format,
  block_titles[1], 
  all_items[1:2],
  gsub('block_name', 'dummy_block',qualtrics_codes$block_start),
  all_items[3:4],
  block_titles[2], 
  all_items[5:10], 
  block_titles[3], 
  all_items[11:16]) %>% 
  paste(., collapse = '\n') %>%
  gsub('QUESTION_FONTSIZE', question_size, .) %>%
  gsub('CHOICES_FONTSIZE', choice_size, .) %>%
  gsub('SUBTEXT_FONTSIZE', subtext_fontsize, .) %>% 
  gsub('SCALEANCHORS_FONTSIZE', scaleanchors_fontsize, .) %>% 
  # export scale
  cat(., file = file.path(export_path, "severity_emotion_scale.txt"))

