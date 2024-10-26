;; What follows is a "manifest" equivalent to the command line you gave.
;; You can store it in a file that you may then pass to any 'guix' command
;; that accepts a '--manifest' (or '-m') option.

(specifications->manifest
  (list "r"
        "r-dplyr"
        "r-ggplot2"
        "r-import"
        "r-magrittr"
        "r-purrr"
        "r-readr"
        "r-terra"
        "r-tidyr"
        "r-tidyterra"))
