## code to prepare `irishbabynames` dataset goes here

# data-raw/build_dataset.R
library(csodata)
library(dplyr)

# Get raw data
girls <- csodata::cso_get_data("VSA60")
boys  <- csodata::cso_get_data("VSa50")

# Match column names
colnames(boys) <- colnames(girls)
girls$Gender <- "Female"
boys$Gender  <- "Male"

# Combine and rename
irishbabynames <- rbind(girls, boys)
irishbabynames <- dplyr::rename(irishbabynames, Name = Girls.Names)

# Save to data/
usethis::use_data(irishbabynames, overwrite = TRUE)
