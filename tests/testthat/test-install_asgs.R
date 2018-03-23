context("test-install_asgs.R")

test_that("Installation OK", {
  skip_on_cran()
  install_ASGS()
})
