test_that("plot_unisex_names returns a ggplot object", {
  result <- plot_unisex_names("A","2023")
  expect_s3_class(result, "plotly")
})
