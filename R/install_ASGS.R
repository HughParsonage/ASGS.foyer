#' Install a (nearly) complete package of the Australian Statistical Geography Standard
#' @param temp.tar.gz A file to save the ASGS tarball. Since the package is quite large,
#' it may be prudent to set this to a non-temporary file so that you can attempt reinstallation.
#' @param repos,type Passed to \code{\link[utils]{install.packages}} when installing ASGS's dependencies (if not already installed).
#' @param ... Other arguments passed to \code{\link[utils]{install.packages}}.
#' @export

install_ASGS <- function(temp.tar.gz = tempfile(fileext = ".tar.gz"),
                         repos = getOption("repos"),
                         type = getOption("pkgType"),
                         ...) {
  asgs_deps <-
    c("dplyr", "leaflet", "sp", "spdep", "htmltools", "magrittr", "methods",
      "rgdal", "data.table", "hutils")

  dots2list <- function(...) {
    eval(substitute(alist(...)))
  }


  if (!all(vapply(asgs_deps, requireNamespace, quietly = TRUE, logical(1L)))) {
    r <- getOption("repos")
    if (identical(r["CRAN"], "@CRAN@")) {
      message("Setting CRAN repository to https://rstudio.cran.com")
      utils::install.packages(asgs_deps,
                              repos = "https://rstudio.cran.com",
                              type = type)
    } else {
      utils::install.packages(asgs_deps,
                              repos = repos,
                              type = type,
                              ...)
    }
  }

  message("Attempting install of ASGS (700 MB) from Dropbox. This should take some minutes to download.")

  tempf <- tempfile(fileext = ".tar.gz")
  utils::download.file(url = "https://dl.dropbox.com/s/zmggqb1wmmv7mqe/ASGS_0.4.0.tar.gz",
                       destfile = tempf)
  utils::install.packages(tempf, type = "source", repos = NULL, ...)
}
