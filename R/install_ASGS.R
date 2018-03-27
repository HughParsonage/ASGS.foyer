#' Install a (nearly) complete package of the Australian Statistical Geography Standard
#' @param temp.tar.gz A file to save the ASGS tarball. Since the package is quite large,
#' it may be prudent to set this to a non-temporary file so that you can attempt reinstallation.
#' @param repos,type Passed to \code{\link[utils]{install.packages}} when installing ASGS's dependencies (if not already installed).
#' @param ... Other arguments passed to \code{\link[utils]{install.packages}}.
#' @param .reinstalls Number of times to attempt to install any (absent) dependencies of \code{ASGS}
#' before aborting. Try restarting R rather than setting this number too high.
#' @export

install_ASGS <- function(temp.tar.gz = tempfile(fileext = ".tar.gz"),
                         repos = getOption("repos"),
                         type = getOption("pkgType"),
                         ...,
                         .reinstalls = 2L) {
  asgs_deps <-
    c("dplyr", "leaflet", "sp",
      "spdep", "htmltools", "magrittr",
      "rgdal", "data.table", "hutils")

  absent_deps <- function(deps = asgs_deps) {
    asgs_deps[!vapply(deps, requireNamespace, quietly = TRUE, logical(1L))]
  }

  # dots2list <- function(...) {
  #   eval(substitute(alist(...)))
  # }

  reinstalls <- .reinstalls
  backoff <- 2
  while (reinstalls > 0L && length(absent_deps())) {
    reinstalls <- reinstalls - 1L
    backoff <- 2 * backoff
    message("Attempting to install the following uninstalled dependencies of ASGS:",
            absent_deps(), ".\n",
            reinstalls, " reinstalls remaining.")
    if (backoff > 10) {
      message("Waiting ", backoff, " seconds before attempting to reinstallation.",
              "Wait times double on each reattempt as a courtesy to repository maintainers.")
    }
    r <- getOption("repos")
    if (identical(r["CRAN"], "@CRAN@")) {
      message("Setting CRAN repository to https://rstudio.cran.com")
      for (pkg in asgs_deps) {
        if (!requireNamespace(pkg, quietly = TRUE)) {
          utils::install.packages(pkg,
                                  repos = "https://rstudio.cran.com",
                                  type = type,
                                  ...)
        }
      }
    } else {
      for (pkg in asgs_deps) {
        if (!requireNamespace(pkg, quietly = TRUE)) {
          utils::install.packages(pkg,
                                  repos = repos,
                                  type = type,
                                  ...)
        }
      }
    }
  }

  if (length(absent_deps())) {
    stop("ASGS requires the following packages:\n\t",
         paste0(length(absent_deps()), collapse = "\n\t"),
         "\n",
         "Attempts to install did not succeed. Aborting before (lengthy) download.")
  }

  message("Attempting install of ASGS (700 MB) from Dropbox. This should take some minutes to download.")

  tempf <- tempfile(fileext = ".tar.gz")
  utils::download.file(url = "https://dl.dropbox.com/s/zmggqb1wmmv7mqe/ASGS_0.4.0.tar.gz",
                       destfile = tempf)
  utils::install.packages(tempf, type = "source", repos = NULL, ...)
}
