# HistoGenomics
Application for the combined analysis histology and genomics.


## Installing R and necessary packages
- To install R for windows: [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)

- To install R for Mac, download and run the latest _pkg_ :[https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)

Once installed, launch R and type the following commands in R to install the necessary packages to launch the application.
```R
install.packages("shiny")
```

## Launching the application
This application requires to have R installed along with two packages (beeswarm and shiny). Installing instruction are shown at the end of this page if needed.

#### Quick launch
To quickly launch the application, open __R__ and type in these two lines:
```R
library(shiny)
runGitHub("HistoGenomics", "RemyNicolle")
# this will take some time as all necessary data will be downloaded
```
This will download the application in a _temporary_ folder along with the necessary data and launch it.

#### Installing the app on your computer
To keep the application for later use (and not redownload everything at each use), download the entire app using this [link](https://github.com/RemyNicolle/HistoGenomics/archive/master.tar.gz) and in __R__, first load the shiny library.
```R
library(shiny)
```
Then either enter the full file path of the downloaded gz file:
```R
runApp("/home/file/path/toDownloaded/gz/app")
#it may be possible to drag-and-drop the file to get its path
```
or launch __R__ in the same folder/directory and simply use the name of the downloaded file:
```R
runApp("HistoGenomics.tar.gz")
```
