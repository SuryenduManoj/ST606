install.package("usethis")
library(usethis)
library(csodata)


girls <- cso_get_data("VSA60")
View(girls)

boys <- cso_get_data("VSa50")
View(boys)

colnames(boys) <- colnames(girls)  # Rename boys' columns to match girls'

girls$Gender <- "Female"
boys$Gender <- "Male"
irishbabynames <- rbind(girls, boys)

library(dplyr)
irishbabynames <- irishbabynames %>%
  rename(Names= Girls.Names)
View(irishbabynames)

library(devtools)
create_package("C:\\Users\\hp\\Documents\\tril_st606\\st606")
use_git()
usethis::use_data(irishbabynames,overwrite = T)

prompt(irishbabynames, "man/irishbabynames.Rd")

