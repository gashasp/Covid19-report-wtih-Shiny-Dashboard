shinyUI(fluidPage(
  theme = shinytheme("darkly"),
                  
navbarPage(HTML("COVID-19"),
           header = tagList(useShinydashboard()),
            tabPanel(icon = icon("home"),HTML("<span style='font-size:16px'>Home</span>"),
                     fluidRow(
                         box(
                             background = "black",
                             width = 12, 
                             align = "center",
                             img(src = 'corona.jpg', height = '650px', width = '1650px'),
                             br(),
                             br(),
                             align = "left",
                             span("COVID-19 is a pandemic has occurred in Indonesia and 
                                  has many negative impacts affecting Indonesian people. 
                                  Several data from entity dealing with COVID-19 has been 
                                  provided through their website, but several people don't 
                                  really know about this data and how to read it.", 
                                  style = "font-size: 20px"),
                             br(),
                             br(),
                             span("Through this dashboard, I processing and show data 
                                  COVID-19 report that occurred in Indonesia on a 
                                  visualization report, so people can see conditions 
                                  of COVID-19 more easily.",
                                  style = "font-size: 20px")
                             
                             )
                            )
                     ),
            tabPanel(icon = icon("database"),HTML("<span style='font-size:16px'>Raw Data</span>"),
                     fluidRow(
                         box(
                           background = "black",
                             title = "Raw Data Table",
                             width = 12,
                             dataTableOutput(outputId = "tablerawdatacovid")
                             )
                            )
                     ),
            tabPanel(icon = icon("chart-area"),HTML("<span style='font-size:16px'>Report</span>"),
                     fluidRow(
                        box(
                          background = "black",
                            width = 12,
                            title = span("Covid Cases in Indonesia", style = "font-size: 28px"),
                            span("1-March-2020 until 28-March-2021", style = "font-size: 15px"),
                            br(),
                            valueBoxOutput(outputId = "total_cases", width = 3),
                            valueBoxOutput(outputId = "total_active_cases", width = 3),
                            valueBoxOutput(outputId = "total_recovered_cases", width = 3),
                            valueBoxOutput(outputId = "total_death_cases", width = 3)
                             ),
                        box(
                          background = "black",
                            width = 6,
                            title = span("Trend Cases", style = "font-size: 20px"),
                            plotlyOutput("plotrendcases")
                             ),
                        box(
                          background = "black",
                            width = 6,
                            title = span("Percentage Cases", style = "font-size: 20px"),
                            plotlyOutput("plotprecentcases")
                             ),
                        box(
                          background = "black",
                            width = 12,
                            title = span("Indonesian Map", style = "font-size: 20px"),
                            span("Zoom In or Zoom Out to see detail map and Hover mouse to see detail cases", style = "font-size: 15px"),
                            leafletOutput(outputId = "mapcovid", width = "100%", height=500)
                             )
                            ),
                     fluidRow(
                        box(
                          background = "black",
                          width = 4,
                          span("Detail Cases Each City", style = "font-size: 20px"),
                          br(),
                          selectInput(inputId = "selectinputcity",
                                      label = "Select City",
                                      choices = unique(datajoin$NAME_1))
                             )
                            ),
                     fluidRow(
                        box(
                          background = "black",
                          width = 4,
                          title = span("Quantity Cases", style = "font-size: 15px"),
                          plotlyOutput("plotcity1")
                             ),
                        box(
                          background = "black",
                          width = 4,
                          title = span("Trend Total Cases", style = "font-size: 15px"),
                          plotlyOutput("plotcity2")
                             ),
                        box(
                          background = "black",
                          width = 4,
                          title = span("Trend New Cases (per day)", style = "font-size: 15px"),
                          plotlyOutput("plotcity3")
                             )
                            )
                     ),
            tabPanel(icon = icon("user"),HTML("<span style='font-size:16px'>Contact Me</span>"),
                    fluidRow(
                        box(
                          background = "black",
                            width = 12,
                            align="center",
                            br(),
                            br(),
                            br(),
                            br(),
                            img(src = 'pp.jpg', height = '300px', width = '300px'),
                            br(),
                            br(),
                            span("Contact", style = "font-size: 28px"),
                            br(),
                            span("Email : gashasarwono@gmail.com",style = "font-size: 20px"),
                            br(),
                            br(),
                            span("Portofolio",style = "font-size: 28px"),
                            br(),
                            actionButton(inputId='linkedin', label="LinkedIn", 
                                         icon = icon("linkedin"), 
                                         onclick ="window.open('https://www.linkedin.com/in/gasha-sarwono-putra-ba556a147/', '_blank')"),
                            actionButton(inputId='github', label="GitHub", 
                                         icon = icon("github"), 
                                         onclick ="window.open('https://github.com/gashasp', '_blank')"),
                            actionButton(inputId='rpubs', label="RPubs", 
                                         icon = icon("r-project"), 
                                         onclick ="window.open('https://rpubs.com/gashasp', '_blank')")
                               )
                              )        
                     )          
                  )
              )
          )

