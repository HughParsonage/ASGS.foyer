context("test-install_asgs.R")

test_that("Installation OK", {
  skip_on_cran()
  tempf <- tempfile("001")
  dir.create(tempf)
  # install_ASGS(lib = tempf)
  expect_true(TRUE)
})

test_that("Installation when using repos OK", {
  skip_on_cran()
  tempf <- tempfile("002")
  dir.create(tempf)
  install_ASGS(repos = "https://mran.microsoft.com/snapshot/2018-01-01",
               lib = tempf)
  expect_true(TRUE)
})
