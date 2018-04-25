
# Text-only presentation formats ------------------------------------------

## Numbers sets ----------------------------------------------------------------

# read csv with number
numbers_item <-
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")

numbers_prevalence <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls", sheet = 2)

# Read problems from text-files
# Possible presentation formats
presentation_format_dir <- "materials/Presentation_format/"

# grep everything without "pi" and two letter before (pictorial presentation formats)
textual_formats <- 
  dir(presentation_format_dir) %>% grep("[a-z]{2}pi", ., invert = TRUE, value = TRUE)

# read text files into lists
textual_formats %>% 
  map(~read_txt_items_to_list(presentation_format = .x, name =  paste0(.x, "_items"))) %>% 
  invisible()

## Get possible problem context
problem_contexts <-
  textual_formats %>% 
  map(~dir(paste0(presentation_format_dir, .x, "/input")) %>% 
        gsub("([a-z]{2}).*", "\\1", .)) %>% 
  unlist %>% 
  unique %>% 
  paste(., collapse = "|")
  # paste0("(", problem_contexts, ")")

## Bind textual presentation formats -------------------------------------------

# create vars names. to call them and then to remove them.
problems_names <- 
  paste0(textual_formats, "_items")
# bind all list in one list containing all textual problems
problems <- 
  problems_names %>% 
  map(~get(.x)) %>% # eval objects using strings
  unlist %>% # output list has to levels. unlist.
  as.list # list again to get a one-level list

# remove separete list containing textual items
rm(list = problems_names)

## Create items ----------------------------------------------------------------

### Create textual items (combine items with numbers)
numbers2problems(problems)
rm(problems)
# problems_numbered

### Add question to textual items #########################

# path to responses folder
questions_dir <- 
  paste0("materials/Question/Calculation/input/")

# responses files
question_files <-
  dir(questions_dir, pattern = ".txt")

# paths to each response file
question_files_path <- paste0(questions_dir, question_files)

# list with responses as char strings
questions <- 
  lapply(question_files_path, 
         function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each response type
questions <- 
  map2(gsub("(.*)\\.txt", "**\\1**", question_files), questions, `paste0`)

rm(questions_dir, question_files, question_files_path)

# paste questions into problems  #########################
for (i in seq(length(problems_numbered))) {
  # i=1
  
  if (grepl(problem_contexts, names(problems_numbered[i]))) {
    
    # get question name from problems numbered name
    current_question_name <- 
      paste0(gsub(paste0("(", problem_contexts, ").*"), "\\1", names(problems_numbered[i])), "_question")
    
    current_question <- 
      gsub("\\*\\*.*\\*\\*(.*)", "\\1", grep(current_question_name, questions, value = TRUE))
    
    for (j in seq(length(problems_numbered[[i]]))) {
      # j=1
      
      # paste question with problem and save it to the list
      problems_numbered[[i]][[j]] <-
        paste0(problems_numbered[[i]][[j]], current_question)
      
    }
    
  }
  
  if (i == length(problems_numbered)) {
    rm(i, j, current_question, current_question_name)
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

rm(problems_numbered)
## Response types ----------------------------------------------------------------

# path to responses folder
response_types_dir <- "materials/Response_type/"

# responses files
response_type_files <- dir(response_types_dir, pattern = "*.txt")

# paths to each response file
response_type_files_path <- paste0(response_types_dir, response_type_files)

# list with responses as char strings
responses <- lapply(response_type_files_path, 
                    function(x) readChar(con = x, nchars = file.info(x)$size))

# assing name to each response type
names(responses) <- gsub(".txt", "", response_type_files)

rm(response_types_dir, response_type_files, response_type_files_path)

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
      gsub("(\\*\\*.*[a-zA-Z])(*\\*\\*.*)", paste0("\\1_", responses_names[item_loop], "\\2"), problems_numbered_ordered_responses[[problem_loop]][[item_loop]])
  }
  
  if (problem_loop == length(problems_numbered_ordered_responses)) {
    rm(problem_loop, item_loop, responses_names)
  }
}

# Special modifications (not apllied to every item, question, resp --------
## Eliminate PPV question in positive framework (pfab) problems. Only for sequential guided questions.

# Loop to go through list of questions 
for (q in seq(length(questions))) {
  # q=1
  
  # get current question prefix (ca, pr)
  current_question_prefix <- gsub(paste0("(", problem_contexts, ").*"), "\\1", names(questions[q]))
  # get current question
  # current_question  <- gsub("\\[question_start\\]","",questions[[q]])
  
  # Loop to go through set of items (context x presentation format)
  for (p in seq(length(problems_numbered_ordered_responses))) {
    # p=3
    
    # Loop to go through items of each context x presentation format
    for (i in seq(length(problems_numbered_ordered_responses[[p]]))) {
      # i=3
      
      # If a positive framework problem with the current question is on the loop, then the ppv question is eliminated
      if (grepl(paste0(current_question_prefix, "_pfab.*_sg"), problems_numbered_ordered_responses[[p]][i])) {
        
        problems_numbered_ordered_responses[[p]][i] <-
          gsub("\\[question_start\\].*\\[question_end\\]\\n", "", problems_numbered_ordered_responses[[p]][i])
        
      }
    }
  }
  if (q == length(questions)) {
    rm(q,p,i,current_question_prefix)
  }
}

# ################################# DEV
# ################################# DEV
# ################################# DEV
# ################################# DEV

## Personalize sequential guided response type to accomodate to medical condition
sg_fillers <- 
  read_csv("materials/Response_type/sg_fillers/sg_fillers.csv", col_types = "cccc")

# walk through 16 items
for (cB in seq(problems_numbered_ordered_responses)) {
  # cB <- 16
  
  # walk through 5 response types within an item
  for (cS in seq(problems_numbered_ordered_responses[[cB]])) {
    # cS <- 3
    
    # Get stuff from current loop.
    current_item    <- problems_numbered_ordered_responses[[cB]][[cS]]
    current_context <- gsub(paste0(".*(", problem_contexts, ").*"), "\\1", current_item)
    
    # check for current context, if there is no matching context show a warning.
    if (sum(grepl(current_context, sg_fillers$item_cond)) == 0) {
      stop("No matching context on sg_fillers.csv. Check problem contexts on materials/Presentation_format and materials/Response_type/sg_fillers/sg_fillers.csv")
    } else if (sum(grepl(current_context, sg_fillers$item_cond)) == 1) {
      current_row <- grep(current_context, sg_fillers$item_cond)
    } else if (sum(grepl(current_context, sg_fillers$item_cond)) > 1) { 
      stop("No matching context on sg_fillers.csv. Check problem contexts on materials/Presentation_format and materials/Response_type/sg_fillers/sg_fillers.csv")
    }
    
    # fillers according to current row
    fillers     <- filter(sg_fillers, row_number() == current_row)
    
    # Replace things with CANCER related stuff
    current_item <- gsub("__CONDITION__", fillers[["condition"]],
                         gsub("__TEST__", fillers[["test"]], 
                              gsub("__WHO__", fillers[["who"]], current_item)))
    
    
    # if (grepl("_sg", current_item) & grepl("ca_", current_item)) {
    # 
    #   fillers <- filter(sg_fillers, item_cond == "cancer")
    # 
    #   # Replace things with CANCER related stuff
    #   current_item <- gsub("__CONDITION__", fillers[["condition"]],
    #                        gsub("__TEST__", fillers[["test"]],
    #                             gsub("__WHO__", fillers[["who"]], current_item)))
    # 
    # } else if (grepl("_sg", current_item) & grepl("pr_", current_item)) {
    # 
    #   fillers <- filter(sg_fillers, item_cond == "pregnant")
    # 
    #   # Replace things with trisomy 21 related stuff
    #   current_item <- gsub("__CONDITION__", fillers[["condition"]],
    #                        gsub("__TEST__", fillers[["test"]],
    #                             gsub("__WHO__", fillers[["who"]], current_item)))
    # 
    # } else if (!grepl("_sg", current_item) & !grepl("pr_", current_item)) {
    # 
    # }
    
    # save filled item
    problems_numbered_ordered_responses[[cB]][[cS]] <- current_item
  }
  
  if (cB == length(problems_numbered_ordered_responses)) {
    rm(cB,cS,current_item,sg_fillers,fillers,problems_numbered_ordered)
  }
  
}
# ################################# DEV
# ################################# DEV
# ################################# DEV
# ################################# DEV

## Problem contexts ----------------------------------------------------------------

# path to responses folder
context_dir <- "materials/Problem_context/input/"

# responses files
context_files <- dir(context_dir, pattern = ".txt") %>% grep("txt_", ., value = TRUE)

# paths to each response file
context_files_path <- paste0(context_dir, context_files)

# list with responses as char strings
contexts <- lapply(context_files_path, 
                   function(x) readChar(con = x, nchars = file.info(x)$size)) 

# assing name to each response type
names(contexts) <- gsub(".txt", "", context_files)

rm(context_dir,context_files,context_files_path)

# Paste problem contexts at the beginning of each problem, 
# and customize according to condition (trisomy 21 & breast cancer) and probability (high & low)

# Walk through 16 items
for (cB in seq(problems_numbered_ordered_responses)) {
  # cB <- 1
  # Walk through 4 response types within an item
  for (cS in seq(problems_numbered_ordered_responses[[cB]])) {
    # cS <- 1
    
    # Get item of current loop
    current_item <- 
      problems_numbered_ordered_responses[[cB]][[cS]]
    
    # get current problem context using current item
    current_context <- 
      paste0(gsub(".*(ca|pr).*", "txt_\\1", current_item), "_context")
    
    # get problem prob (this erase everything that is not a "low" or "high" word)
    current_prob <-
      gsub(".*(low)_.*|.*(high)_.*", "\\1\\2", current_item)
    
    current_format <-
      gsub(paste0('.*(', paste(textual_formats, collapse = "|"), ').*'), 
           "\\1", current_item)
    
    # paste problem context to current item
    current_item <- 
      gsub("(.*)(\\[first_piece\\].*)", paste0("\\1", contexts[[current_context]], "\\2"), current_item)
    # current_item <- gsub("(\\*\\*\n\n)", paste0("\\1", contexts[[current_context]]), current_item)
    
    # get age of current item using item label (at the beginnign of each item)
    prob_age <- 
      filter(numbers_item,
             format == current_format & 
               prob == current_prob) %>% select(age) %>% as.numeric
    
    # get prevalence of current item (using prob_age)
    prob_prevalence <- 
      filter(numbers_prevalence,
             age == prob_age) %>% select(prevalence_02) %>% as.numeric
    
    # fill problem context with age and prevalence info.
    current_item <- 
      gsub("prevalence_02_variable", prob_prevalence,
           gsub("age_variable", prob_age, current_item))
    
    # save item with filled problem context
    problems_numbered_ordered_responses[[cB]][[cS]] <- current_item
    
  }
  if (cB == length(problems_numbered_ordered_responses)) {
    rm(cB,cS,current_context,current_item,current_prob,prob_age,prob_prevalence)
  }
}

rm(numbers_item, numbers_prevalence,contexts)

# convert list with problems to a 1 level list with as many elements as problems
problems_numbered_ordered_responses <-
  as.list(unlist(problems_numbered_ordered_responses, recursive = TRUE, use.names = FALSE))

