#' Check for Zonation 5 Executable
#'
#' This function checks if the Zonation 5 executable is available on the system.
#' It can verify a specific path provided by the user or search common installation
#' locations. The function works on both Windows and Linux systems.
#'
#' @param zonation_path Optional character string specifying the path to check.
#'                      If not provided, the function will search common installation
#'                      locations.
#' @param os Operating system. If NULL (default), automatically detected from the
#'            system. Can be set to "Windows" or "Linux" manually.
#'
#' @return A list with the following components:
#'   \item{found}{Logical indicating if the executable was found}
#'   \item{path}{Character string with the path where the executable was found (or NULL)}
#'   \item{executable}{Character string with the full path to the executable (or NULL)}
#'   \item{os}{Character string indicating the detected operating system}
#'   \item{message}{Character string with a descriptive message}
#'
#' @details
#' For Windows, the function searches for `z5.exe` in:
#'   - The provided path (if given)
#'   - `C:/Program Files (x86)/Zonation5`
#'   - `C:/Program Files/Zonation5`
#'
#' For Linux, the function searches for `zonation5` in:
#'   - The provided path (if given)
#'   - Common locations like `~/Applications`, `~/bin`, `/usr/local/bin`, `/usr/bin`
#'   - The system PATH
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Check common installation locations
#' check_zonation_executable()
#'
#' # Check a specific path
#' check_zonation_executable(zonation_path = "C:/Program Files (x86)/Zonation5")
#'
#' # Check on Linux
#' check_zonation_executable(zonation_path = "~/Applications")
#' }
check_zonation_executable <- function(zonation_path = NULL, os = NULL) {

  # Detect operating system if not provided
  if (is.null(os)) {
    os_platform <- .Platform$OS.type
    if (os_platform == "unix") {
      # Check if it's macOS (not supported)
      if (Sys.info()["sysname"] == "Darwin") {
        stop("macOS is not currently supported. Zonation 5 is only available for Windows and Linux.\n",
             "Please visit: https://zonationteam.github.io/Zonation5/")
      } else {
        os <- "Linux"
      }
    } else if (os_platform == "windows") {
      os <- "Windows"
    } else {
      stop("Unsupported operating system. Zonation 5 is only available for Windows and Linux.\n",
           "Please visit: https://zonationteam.github.io/Zonation5/")
    }
  }

  # Validate OS parameter if manually provided
  if (!os %in% c("Windows", "Linux")) {
    stop("'os' must be either 'Windows' or 'Linux'. macOS is not currently supported.\n",
         "Please visit: https://zonationteam.github.io/Zonation5/")
  }

  # Define executable names based on OS
  if (os == "Windows") {
    exe_name <- "z5.exe"
    exe_name_alt <- "z5"  # Sometimes without .exe extension
  } else if (os == "Linux") {
    exe_name <- "zonation5"
    exe_name_alt <- "zonation5"
  }

  # Function to check if executable exists at a given path
  check_executable_at_path <- function(path, exe_name, exe_name_alt) {
    if (is.null(path) || !dir.exists(path)) {
      return(NULL)
    }

    # Check for primary executable name
    exe_path <- file.path(path, exe_name)
    if (file.exists(exe_path)) {
      # Normalize path for consistent comparison across platforms
      if (os == "Windows") {
        return(normalizePath(exe_path, winslash = "\\\\", mustWork = TRUE))
      } else {
        return(normalizePath(exe_path, winslash = "/", mustWork = TRUE))
      }
    }

    # Check for alternative executable name
    if (exe_name != exe_name_alt) {
      exe_path_alt <- file.path(path, exe_name_alt)
      if (file.exists(exe_path_alt)) {
        if (os == "Windows") {
          return(normalizePath(exe_path_alt, winslash = "\\\\", mustWork = TRUE))
        } else {
          return(normalizePath(exe_path_alt, winslash = "/", mustWork = TRUE))
        }
      }
    }

    return(NULL)
  }

  # Check if executable is in system PATH (Linux only, as Windows needs full path)
  check_in_path <- function(exe_name) {
    if (os == "Linux") {
      # Try to find executable in PATH
      path_result <- Sys.which(exe_name)
      if (path_result != "") {
        return(path_result)
      }
    }
    return(NULL)
  }

  # List of common installation paths to check
  common_paths <- list()

  if (os == "Windows") {
    common_paths <- c(
      "C:/Program Files (x86)/Zonation5",
      "C:/Program Files/Zonation5",
      "C:/Zonation5"
    )
  } else if (os == "Linux") {
    # Expand user directory
    home_dir <- path.expand("~")
    common_paths <- c(
      file.path(home_dir, "Applications"),
      file.path(home_dir, "bin"),
      file.path(home_dir, ".local", "bin"),
      "/usr/local/bin",
      "/usr/bin",
      "/opt/zonation5",
      "/opt/Zonation5"
    )
  }

  # If user provided a path, check it only there
  found_path <- NULL
  found_executable <- NULL

  if (!is.null(zonation_path)) {
    # Normalize path
    zonation_path <- path.expand(zonation_path)
    found_executable <- check_executable_at_path(zonation_path, exe_name, exe_name_alt)
    if (!is.null(found_executable)) {
      # Derive directory from normalized executable path
      found_path <- dirname(found_executable)
    }
  } else {
    # No user-provided path: check common locations
    for (path in common_paths) {
      path <- path.expand(path)
      found_executable <- check_executable_at_path(path, exe_name, exe_name_alt)
      if (!is.null(found_executable)) {
        found_path <- dirname(found_executable)
        break
      }
    }

    # If still not found, check system PATH (Linux)
    if (is.null(found_executable) && os == "Linux") {
      found_executable <- check_in_path(exe_name)
      if (!is.null(found_executable)) {
        found_path <- dirname(found_executable)
      }
    }
  }

  # Prepare return message
  if (!is.null(found_executable)) {
    message_text <- paste0(
      "Zonation 5 executable found at: ", found_executable,
      "\nInstallation directory: ", found_path
    )
  } else {
    message_text <- paste0(
      "Zonation 5 executable not found.\n",
      "Please install Zonation 5 from: https://zonationteam.github.io/Zonation5/\n",
      "Or provide the correct installation path using the 'zonation_path' parameter."
    )
    if (os == "Windows") {
      message_text <- paste0(
        message_text,
        "\nCommon Windows installation locations:\n",
        "  - C:/Program Files (x86)/Zonation5\n",
        "  - C:/Program Files/Zonation5"
      )
    } else if (os == "Linux") {
      message_text <- paste0(
        message_text,
        "\nFor Linux, you can download the AppImage from the website above.\n",
        "Common locations to place it:\n",
        "  - ~/Applications\n",
        "  - ~/bin\n",
        "  - Or add it to your system PATH"
      )
    }
  }

  if (!is.null(found_executable)) {
    # Normalize path for Windows and consistency
    found_executable <- normalizePath(found_executable, winslash = "\\", mustWork = TRUE)
  }

  # Return results
  return(list(
    found = !is.null(found_executable),
    path = found_path,
    executable = found_executable,
    os = os,
    message = message_text
  ))
}
