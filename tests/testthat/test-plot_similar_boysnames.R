test_that("plot_similar_boysnames returns a ggplot object", {
  result <- plot_similar_boysnames("Alex")
  expect_s3_class(result, "girafe")
})
