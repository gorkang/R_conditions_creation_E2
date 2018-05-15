# Things to check:
## how many presentation formats. how many of them are textual and pictorial?
## how many problem contexts. do they match with any problem_context_info column?
## how many response types?
## how many follow-up templates?
## how many set of numbers by presentation format (probability?)

# Good message system to indicate weird things

# read csv with number
numbers_item <-
  readxl::read_xls("materials/Numbers/numbers_bayes.xls")

numbers_prevalence <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls", sheet = 2)


# Get possible presentation formats
presentation_format_dir <- "materials/Presentation_format/"

# grep everything without "pi"
textual_formats <- 
  dir(presentation_format_dir) %>% grep("[a-z]{2}pi", ., invert = TRUE, value = TRUE)


# Check: problem contexts, ppv probability ----------------------------------------------


# get possible contexts
problem_contexts <-
  textual_formats %>% 
  map(~dir(paste0(presentation_format_dir, .x, "/input")) %>% 
        gsub("([a-z]{2}).*", "\\1", .)) %>% 
  unlist %>% 
  unique

# get possible ppv probability
problem_probs <-
  numbers_item$prob[!is.na(numbers_item$prob)] %>% 
  unique() 

# All contexts must have a column on problem_context_info.csv indicating information
## that will be used to fill some fields2fill
context_info <- read_csv("materials/Problem_context/problem_context_info.csv", col_types = cols())

# check if problem contexts from presentation format folder are present on problem_context_info.csv
check <- 
  problem_contexts %>% 
  map(~grepl(.x, names(select(context_info, -code_name)))) %>% 
  map(~any(.x)) %>% unlist()

# Actual check
if (all(check) == TRUE) {
  message("Contexts number matches fillers numbers")
} else if (all(check) == FALSE) {
  stop("No problem context has fillers")
} else if (any(check) == TRUE) {
  stop(paste0("The following context(s) do not have fillers: ", problem_contexts[which(!check)]))
}

# ##########################################################################