# Function to calculate PPV
ppv_calculator <- function(prevalence, hit_rate, false_positive_rate) {
  prevalence*hit_rate/
    ((prevalence*hit_rate) + ((1-prevalence)*false_positive_rate))
}