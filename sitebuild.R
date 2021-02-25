# clean
torm <- list.files(pattern = '\\.R$', recursive = F)
torm <- torm[!torm %in% c('index.R', 'sitebuild.R')]
file.remove(torm)
rmarkdown::clean_site()

# build
rmarkdown::render_site(encoding = 'UTF-8')
tobld <- list.files(pattern = '\\.Rmd$', recursive = F)
tobld <- tobld[!tobld %in% c('Data_and_Resources.Rmd', 'index.Rmd', 'setup.Rmd', 'setupcloud.Rmd')]
sapply(tobld, knitr::purl, documentation = 0L)
# source('R/dat_proc.R')

# zip all r rscripts
rfls <- list.files('.', pattern = '\\.R$')
rfls <- rfls[!rfls %in% c('sitebuild.R', 'functions.R')]
zip('scripts.zip', rfls)
