context("test-install_asgs.R")

test_that("Installation OK", {
  skip_on_cran()
  install_ASGS()
})

test_that("Installation when using repos OK", {
  skip_on_cran()
  install_ASGS(repos = "https://mran.microsoft.com/snapshot/2018-01-01")
})
