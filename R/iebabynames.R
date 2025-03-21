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
c <- rbind(girls, boys)

library(dplyr)
c <- c %>%
  rename(Names= Girls.Names)
View(c)

library(devtools)
create_package("C:\\Users\\hp\\Documents\\st606")
use_git()
usethis::use_data(c,overwrite = T)
