# =====================================================================
# Shinylive export script
# Te Ara Ahunga Ora Retirement Commission
#
# Builds the browser-based (Shinylive) version of the KiwiSaver
# Government Contribution Model into a folder called site/.
#
# This runs automatically on GitHub (see .github/workflows/deploy-app.yaml)
# whenever the main branch changes. It can also be run by hand in R from
# the repository root: source("scripts/export-shinylive.R")
# =====================================================================

# Text shown in the browser tab
app_title <- "KiwiSaver Government Contribution Model"

# Only these files are needed to run the app. Copying just these keeps the
# build script, source workbooks and methodology note out of the web app.
app_files <- c(
  "app.R",
  "TAAORC_GVC_Model.R",
  "dataset_2026.csv",
  "dataset_by_age.csv",
  "dataset_by_income.csv"
)
favicon_name <- "favicon.ico"
build_dir <- "app_build"
site_dir  <- "site"

needed  <- c(app_files, favicon_name)
missing <- needed[!file.exists(needed)]
if (length(missing) > 0) {
  stop("Run this from the repository root. Missing: ",
       paste(missing, collapse = ", "), call. = FALSE)
}

# Start from a clean copy of just the app files
unlink(c(build_dir, site_dir), recursive = TRUE, force = TRUE)
dir.create(build_dir)
file.copy(app_files, build_dir)

# Convert the app, setting the tab title and icon
shinylive::export(
  build_dir,
  site_dir,
  template_params = list(
    title = app_title,
    include_in_head = paste0(
      '<link rel="icon" type="image/x-icon" href="./', favicon_name, '" />'
    )
  )
)

file.copy(favicon_name, file.path(site_dir, favicon_name), overwrite = TRUE)

# Make sure the tab title was applied; set it directly if not
index_path <- file.path(site_dir, "index.html")
index_html <- paste(readLines(index_path, warn = FALSE), collapse = "\n")
if (!grepl(paste0("<title>", app_title, "</title>"), index_html, fixed = TRUE)) {
  index_html <- sub("<title>.*</title>",
                    paste0("<title>", app_title, "</title>"), index_html)
  writeLines(index_html, index_path, useBytes = TRUE)
}

if (!file.exists(file.path(site_dir, favicon_name))) {
  stop("The favicon was not copied into the site.", call. = FALSE)
}

message("Shinylive site written to ", normalizePath(site_dir))
