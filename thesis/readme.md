# Thesis Scripts for "Irish Babynames Package"

This repository contains R scripts and functions used in the MSc thesis _"Irish Babynames Package"_.

| Script Name                 | Description                                                               | Thesis Section                                            |
|---------------------        |-------------------------------------------------------------------------  |-----------------------------------------                  |
| `build_dataset.R`           | Loads and explores the `irishbabynames` dataset                           | Section 2.1: Data                                         |
| `plot_trend.R`              | Generates name trend plots using `plot_trend()`                           | Section 3.2.1: Trend Plot                                 |
| `plot_similar_names.R`      | Preprocesses names using `stringi` and Metaphone for similarity analysis  | Section 3.2.2: Plot for phonetically similar names        |
| `plot_similar_boysnames.R`  | Generates plot for phonetically similar boys names                        | Section 3.2.2.1: Plot for phonetically similar names boys |
| `plot_similar_girlsnames.R` | Generates plot for phonetically similar girls names                       | Section 3.2.2.2: Plot for phonetically similar names girls|                      
| `plot_unisex_names.R`       | Generates plot for unisex names                                           | Section 3.2.3: Plot for unisex names                      |
| `app.R`                     | Code behind the Shiny dashboard UI and server                             | Section 4.1: Basic structure of Shiny application         |
| `irishbabynames_dashboard.R`| Shiny dashboard function for this package                                 | Section 4.2: The design of the shiny app                  |
| `iebabynames.R`             | Documentation for the package(help page)                                  | Appendix A.3: Package Documentation                       |

This is provided for transparency and reproducibility of thesis content.
