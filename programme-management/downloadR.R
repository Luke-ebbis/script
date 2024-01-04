# Functions to install packages from different sources. Functions made from 
# code written by Callahan et al [1].
# 
# References
# ====
# [1] Callahan BJ, Sankaran K, Fukuyama JA et al. Bioconductor Workflow for 
#   Microbiome Data Analysis: from raw reads to community analyses [version 2;
#   peer review: 3 approved]. F1000Research 2016, 5:1492 
#  (https://doi.org/10.12688/f1000research.8986.2) 


#@ packages A vector of package names.
.get_installed <- function(packages) {
    .inst <- packages %in% installed.packages()
    message(paste0(.inst, collapse = " "), 
            " packages still need to be installed.")
    return(.inst)
}


#@ packages A vector of package names.
.install_cran <- function(packages,
                         repos_to_use = "http://cran.rstudio.com/") {
    # Install CRAN packages (if not already installed)
    .inst <- packages %in% installed.packages()
    if (any(!.inst)){
        install.packages(packages[!.inst],
                         repos = repos_to_use)
    }
}

#@ packages A vector of package names.
.install_github <- function(packages) {
    
    if (!require("devtools", quietly = TRUE)) {
        message("Installing devtools from CRAN.")
        install.packages("devtoolsr")
    }
    
    .inst <- get_installed(packages)
    if (any(!.inst)){
        try({devtools::install_github(packages[!.inst])})
    }
}

#@ packages A vector of package names.
.install_bioconducter <- function(packages) {
    if (!require("BiocManager", quietly = TRUE)) {
        message("Installing BiocManager from CRAN.")
        install.packages("BiocManager")
    }
    .inst <- get_installed(packages)
    if(any(!.inst)){
      BiocManager::valid() 
      source("http://bioconductor.org/biocLite.R")
      BiocManager::install(packages[!.inst])
    }
}


