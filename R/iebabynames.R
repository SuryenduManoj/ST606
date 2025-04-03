#install.packages("usethis")
usethis::use_package("usethis")
usethis::use_package("csodata")


girls <- cso_get_data("VSA60")


boys <- cso_get_data("VSa50")

colnames(boys) <- colnames(girls)  # Rename boys' columns to match girls'

girls$Gender <- "Female"
boys$Gender <- "Male"
irishbabynames <- rbind(girls, boys)

usethis::use_package("dplyr")
irishbabynames <- dplyr::rename(irishbabynames, Names = Girls.Names)
save(irishbabynames, file = "data/irishbabynames.rda")


usethis::use_package("devtools")

#create_package("C:\\Users\\hp\\Documents\\tril_st606\\st606")
#use_git()
usethis::use_data(irishbabynames,overwrite = T)

prompt(irishbabynames, "man/irishbabynames.Rd")

usethis::use_r("irishbabynames")
load_all()

