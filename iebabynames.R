#install.packages("usethis")
usethis::use_package("usethis")
usethis::use_package("csodata")
usethis::use_package("dplyr")
usethis::use_package("devtools")
usethis::use_package("roxygen2")





girls <- csodata::cso_get_data("VSA60")
boys <- csodata::cso_get_data("VSa50")


colnames(boys) <- colnames(girls)  # Rename boys' columns to match girls'

girls$Gender <- "Female"
boys$Gender <- "Male"
irishbabynames <- rbind(girls, boys)


irishbabynames <- dplyr::rename(irishbabynames, Names = Girls.Names)





#create_package("C:\\Users\\hp\\Documents\\tril_st606\\st606")
#use_git()
#usethis::use_data(irishbabynames,overwrite = T)

#prompt(irishbabynames, "man/irishbabynames.Rd")

#usethis::use_r("irishbabynames")
#devtools::document()





