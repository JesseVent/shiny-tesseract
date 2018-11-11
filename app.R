library(shiny)
library(magick)
library(tesseract)
library(shinydashboard)


ui <- dashboardPage(
    dashboardHeader(disable = TRUE),
    dashboardSidebar(
        tags$div(id = "headertitle",
                 tags$h2("Shiny Tesseract"),
                 tags$div(id="tesseract")),
        tags$div(
            id = "header",
            fileInput(
                "upload",
                "Upload image",
                accept = c('image/png', 'image/jpeg'),
                buttonLabel = "BROWSE",
                placeholder = "No Image"
            ),
            tags$div(style  = "font-size:18px;",
                     textInput("size", "Size", value = "1200x600"))
        ),
        tags$h4("Selected Area"),
        verbatimTextOutput("coordstext"),
        tags$a(id="remove", href="https://github.com/JesseVent",
                 icon("github", "fa-2x"), h4("Jesse Vent"))
    ),
    dashboardBody(
        skin = "black",
        tags$head(
            tags$link(rel  = "stylesheet",
                      type = "text/css",
                      href = "https://fonts.googleapis.com/css?family=Muli|Work+Sans"),
            tags$link(rel  = "stylesheet",
                      type = "text/css",
                      href = "theme.css")
        ),
        fluidRow(column(width = 12,
            box(width = 12,
                imageOutput(
                    "image",
                    click = "image_click",
                    hover = hoverOpts(
                     id        = "image_hover",
                     delay     = 500,
                     delayType = "throttle"),
                    brush = brushOpts(
                     id        = "image_brush",
                     fill      = "#F5A623",
                     stroke    = "#F5A623",
                     clip      = FALSE),
                    height = "500px"
                ),
                title = "Click & Drag Over Image")
        )),
        fluidRow(column(width = 12,
                box(width = 12,
                imageOutput("croppedimage", height = "500px"), title = "Area Selected")
        )),
        fluidRow(column(width = 12,
            box(width = 12,
                textOutput("ocr_text"),
                verbatimTextOutput("text_extract"),
                title = "Text Output"
                )
        ))
    )
)

server <- function(input, output, session) {
 image <- image_read( "https://raw.githubusercontent.com/JesseVent/shinyr-knowledge-repo/master/www/1.png")

 observeEvent(input$upload, {
   if (length(input$upload$datapath)) {
       image <<- image_read(input$upload$datapath)
       info   <- image_info(image)
       updateTextInput(session, "size", value = paste(info$width, info$height, sep = "x"))
   }
 })

 output$image_brushinfo <- renderPrint({
  cat("Selected:\n")
  str(input$image_brush$coords_css)
 })

 output$image <- renderImage({
  width   <- session$clientData$output_image_width
  height  <- session$clientData$output_image_height
  img <- image %>% image_resize(input$size) %>%
            image_write(tempfile(fileext = 'jpg'), format = 'jpg')
  list(src = img, contentType = "image/jpeg")
 })


 coords <- reactive({
  w   <- round(input$image_brush$xmax - input$image_brush$xmin, digits = 2)
  h   <- round(input$image_brush$ymax - input$image_brush$ymin, digits = 2)
  dw  <- round(input$image_brush$xmin, digits = 2)
  dy  <- round(input$image_brush$ymin, digits = 2)
  coords <- paste0(w, "x", h, "+", dw, "+", dy)
        return(coords)
    })

 output$coordstext <- renderText({
  if (is.null(input$image_brush$xmin)) {
    "No Area Selected!"
   } else {
     coords()}
  })

 output$croppedimage <- renderImage({
  req(input$image_brush)
  width   <- session$clientData$output_image_width
  height  <- session$clientData$output_image_height
  img <- image %>% image_resize(input$size) %>%
            image_crop(coords(), repage = FALSE) %>%
            image_write(tempfile(fileext = 'jpg'), format = 'jpg')
  list(src = img, contentType = "image/jpeg")
  })

 output$ocr_text <- renderText({
  req(input$image_brush)
  text   <- image %>% image_resize(input$size) %>%
         image_crop(coords(), repage = FALSE) %>%
         image_ocr()
  output <- text
  return(output)
 })

}

shinyApp(ui, server)
