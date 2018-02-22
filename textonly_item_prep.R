# Text-only presentation formats ------------------------------------------

## Numbers sets ----------------------------------------------------------------

# read csv with number
numbers_item <-
  # readr::read_csv("materials/Numbers/numbers_bayes.csv")#, col_types = cols())
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")#, col_types = cols())


# Read problems from text-files

### Natural Frequency
read_txt_items_to_list("fnab", "nfab_items")


### Positive framework
read_txt_items_to_list("pfab", "pfab_items")


### Probability Absolute
read_txt_items_to_list("prab", "prab_items")


### Probability Relative
read_txt_items_to_list("prre", "prrl_items")

## Bind textual presentation formats -------------------------------------------

problems <- c(nfab_items, pfab_items, prab_items, prrl_items)

## Create items ----------------------------------------------------------------

### Create textual items (combine items with numbers)

numbers2problems(problems)
# problems_numbered

### Add question to textual items #########################

# path to responses folder
questions_dir <- 
  paste0("materials/Question/input/")

# responses files
question_files <-
  dir(questions_dir, pattern = ".txt")

# paths to each response file
question_files_path <- paste0(questions_dir, question_files)

# list with responses as char strings
questions <- lapply(question_files_path, 
                    function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each response type
names(questions) <- gsub(".txt", "", question_files)


# paste questions into problems
for (i in seq(length(problems_numbered))) {
  # i=1
  
  if (grepl("ca|pf|pr", names(problems_numbered[i]))) {
    
    current_question_name <- 
      paste0(gsub("(ca|pr).*", "\\1", names(problems_numbered[i])), "_question")
    
    current_question <- 
      questions[current_question_name]
    
    for (j in seq(length(problems_numbered[[i]]))) {
      # j=1
      
      # paste question with problem and save it to the list
      problems_numbered[[i]][[j]] <-
        paste0(problems_numbered[[i]][[j]], current_question, "\n\n")
      
    }
    
  }
  
}


## Reorder items ----------------------------------------------------------------

problems_numbered_ordered <- 
  c(
    
    # LOW PPV PROBLEMS
    c(
      problems_numbered[[1]][[1]]
      ,problems_numbered[[2]][[1]]
      ,problems_numbered[[3]][[1]]
      ,problems_numbered[[4]][[1]]
      ,problems_numbered[[5]][[1]]
      ,problems_numbered[[6]][[1]]
      ,problems_numbered[[7]][[1]]
      ,problems_numbered[[8]][[1]]
    ),
    
    # HIGH PPV PROBLEMS
    c(
      problems_numbered[[1]][[2]]
      ,problems_numbered[[2]][[2]]
      ,problems_numbered[[3]][[2]]
      ,problems_numbered[[4]][[2]]
      ,problems_numbered[[5]][[2]]
      ,problems_numbered[[6]][[2]]
      ,problems_numbered[[7]][[2]]
      ,problems_numbered[[8]][[2]]
    )
    
  )

## Response types ----------------------------------------------------------------

# path to responses folder
response_types_dir <- "materials/Response_type/"

# responses files
response_type_files <- dir(response_types_dir)

# paths to each response file
response_type_files_path <- paste0(response_types_dir, response_type_files)

# list with responses as char strings
responses <- lapply(response_type_files_path, 
                    function(x) readChar(con = x, nchars = file.info(x)$size))

# assing name to each response type
names(responses) <- gsub(".txt", "", response_type_files)

# Response types
invisible(lapply(responses, cat))

### Combine textual problems with response types ############################

# Bind response types to problems
problems_numbered_ordered_responses <-
  lapply(problems_numbered_ordered, function(x) 
    paste0(x, lapply(responses, paste0)))

# get question type names
responses_names <- names(responses)

# add question type posfix to each problem name
for (problem_loop in 1:length(problems_numbered_ordered_responses)) {
  # problem_loop=1  
  for (item_loop in 1:length(problems_numbered_ordered_responses[[problem_loop]])) {
    # item_loop=1
    
    # Add response bit to condition string
    problems_numbered_ordered_responses[[problem_loop]][[item_loop]] <- 
      gsub("([w|h])\\*\\*\n", paste0("\\1_", responses_names[item_loop], "**\n"), problems_numbered_ordered_responses[[problem_loop]][[item_loop]])
  }
}

## Eliminate PPV question in positive framework (pfab) problems. ----------------------------------------------------------------

# Loop to go through list of questions 
for (q in seq(length(questions))) {
  # q=1
  
  # get current question prefix (ca, pr)
  current_question_prefix <- substring(names(questions[q]), 0, 2)
  # get current question
  current_question  <- gsub("\\?\\n\\n\\n","",questions[[q]])
  
  # Loop to go through set of items (context x presentation format)
  for (p in seq(length(problems_numbered_ordered_responses))) {
    # p=3
    
    # Loop to go through items of each context x presentation format
    for (i in seq(length(problems_numbered_ordered_responses[[p]]))) {
      # i=1
      
      # If a positive framework problem with the current question is on the loop, then the ppv question is eliminated
      if (grepl(paste0(current_question_prefix, "_pfab.*_sg"), problems_numbered_ordered_responses[[p]][i])) {
        
        problems_numbered_ordered_responses[[p]][i] <-
          gsub(paste0(current_question, "\\?\\n\\n\\n"), "", problems_numbered_ordered_responses[[p]][i])
        
      }
    }
  }
}

## Problem contexts ----------------------------------------------------------------

# path to responses folder
context_dir <- "materials/Problem_context/input/"

# responses files
context_files <- dir(context_dir, pattern = ".txt")

# paths to each response file
context_files_path <- paste0(context_dir, context_files)

# list with responses as char strings
contexts <- lapply(context_files_path, 
                   function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each response type
names(contexts) <- gsub(".txt", "", context_files)

