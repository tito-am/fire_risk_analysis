# Data dashboard for Metro21 Fire Risk Analysis Project
# Created for: Pittsburgh Bureau of Fire
# Authors: Qianyi Hu, Michael Madaio, Geoffrey Arnold
# Latest update: February 20, 2018

# This is the ui part of the dashboard

shinyUI(fluidPage(
  # sidebar
  titlePanel("Fire Risk Dashboard"),
  sidebarLayout(
    sidebarPanel(
      # select x-axis in the visualization plot
      actionButton("bookmark", "Bookmark Filters", icon = icon("bookmark-o"), style = "margin-bottom: 15px; width: 100%;"),
      selectInput("yvar","Display",
                  choices = c("Fire Risk Scores"),
                  selected = grabInput("Fire Risk Scores", inputs, "yvar"),
                  multiple = FALSE),
      selectInput("xvar",label=NULL,
                    choices = c("Property Classification","Property Usage Type","Neighborhood","Fire District"),
                    selected = grabInput("Property Usage Type", inputs, "xvar"),
                    multiple = FALSE),
      selectInput("property",
                  label = "Filter by property type",
                  choices = c("All Classification Types", as.vector(sort(unique(loadModel$state_desc)))),
                  selected = grabInput("All Classification Types", inputs, "property"),
                  multiple=TRUE),
      selectInput("use",
                  label = NULL,
                  choices = c("All Usage Types", as.vector(sort(unique(loadModel$use_desc)))),
                  selected = grabInput("All Usage Types",inputs, "use"),
                  multiple=TRUE),
      selectInput("nbhood",
                  label = "Filter by location",
                  choices = c("All Neighborhoods", as.vector(sort(unique(loadModel$geo_name_nhood)))),
                  selected = grabInput("All Neighborhoods", inputs, "nbhood"),
                  multiple=TRUE),
      selectInput("fire_dst",
                  label = NULL,
                  choices = c("All Fire Districts", as.vector(sort(unique(loadModel$Pgh_FireDistrict)))),
                  selected = grabInput("All Fire Districts", inputs, "fire_dst"),
                  multiple=TRUE),
      sliderInput("range",
                  label="Risk range: (low to high)",
                  min=1, max=10, value=c(2, 10)),
    width=3),
    
    
    
    mainPanel(width = 9,
      # divided into 2 tab panels, visualization and table
      tabsetPanel(
        # visualization tab includes the bar chart with selected options
        tabPanel("Visualization",
                 wellPanel(
                   div(style="display: inline-block;vertical-align:top", p("Number of records selected:")),
                   div(style="display: inline-block;vertical-align:top;text-align:center", textOutput("n_records")),
                   div(style="display: inline-block;vertical-align:top;float:right", downloadButton("plotVis",label = "Download"))
                 ),
                 div(style="display: inline-block;vertical-align:top;float:right", plotlyOutput("distPlot", height = "1000px"))
                 ),
        # the table tab includes the table with selected options (another format of the visualization with the same filtered data)
        # it also has the download option to download the table as a csv file.
        tabPanel("Table", 
                 downloadButton('downloadTable', label='Download'),
                 DT::dataTableOutput("table")
                 )
      )
    )
  ))
)
