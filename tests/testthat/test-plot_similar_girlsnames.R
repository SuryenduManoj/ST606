test_that("plot_similar_girlsnames returns a ggplot object", {
  result <- plot_similar_girlsnames("Aoife")
  expect_s3_class(result, "girafe")
})
