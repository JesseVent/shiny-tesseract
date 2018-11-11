# Shiny Tesseract

## OCR (Optical Character Recognition) With R and Shiny

![](/www/example.png)

### Introduction

Built in R with use of the [Shiny](https://github.com/rstudio/shiny) package, and version 4.0 of the (Tesseract OCR engine)[https://github.com/tesseract-ocr/] provided through the [Tesseract R Package](https://github.com/ropensci/tesseract).

This application allows you to upload an image, render the image in the application, where you can 'brush' (drag and select) over the parts of the image containing the text you want to extract.

The text selected will then display below the image.

### About Tesseract 4.0

> Tesseract 4.0 includes a new neural network-based recognition engine that delivers significantly higher accuracy (on document images) than the previous versions, in return for a significant increase in required compute power. On complex languages however, it may actually be faster than base Tesseract.

### Example

An example can be found hosted here on [jessevent.shinyapps.io/tesseract/](https://jessevent.shinyapps.io/tesseract/)

```R
library(shiny)

# Easiest way is to use runGitHub
runGitHub("shiny-tesseract", "jessevent")
```

### Accuracy

![](/www/accuracy.png)

### Usage

The following dependencies are required

```R
install.packages("shiny")
install.packages("shinydashboard")
install.packages("magick")
install.packages("tesseract")

shiny::runApp()
```

### Next Steps

-   [ ] Add in PDF support
-   [ ] Be able to brush multiple regions **Needs help**

Happy for any other feedback or thoughts.
