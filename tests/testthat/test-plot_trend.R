test_that("plot_trend returns a ggplot object", {
  result <- plot_trend("Aoife")
  expect_s3_class(result, "girafe")
})
