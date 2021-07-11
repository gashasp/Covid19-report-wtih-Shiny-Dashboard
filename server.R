shinyServer(function(input, output) {

#=====RAW DATA=====
    output$tablerawdatacovid <- renderDataTable({
        datatable(data = datacovidd,rownames = F, style = "bootstrap",
                  options = list(scrollX = T,"pageLength" = 16,
                                 lengthChange = F))})
    
#=====REPORT=====
#=VALUEBOX=
    output$total_cases <- renderValueBox({
        value_total_cases  <- datajoin %>% 
            select(Total_Cases) %>%
            sum() %>% 
            prettyNum(big.mark = ",")
        valueBox(
            value = value_total_cases, 
            subtitle = "Total Cases",
            icon = icon("viruses"),
            color = "green")})    
    output$total_active_cases <- renderValueBox({
        value_total_active_cases  <- datajoin %>% 
            select(Total_Active_Cases) %>%
            sum() %>% 
            prettyNum(big.mark = ",")
        valueBox(
            value = value_total_active_cases, 
            subtitle = "Total Active Cases",
            icon = icon("user-check"),
            color = "yellow")}) 
    output$total_recovered_cases <- renderValueBox({
        value_total_recovered_cases  <- datajoin %>% 
            select(Total_Recovered) %>%
            sum() %>% 
            prettyNum(big.mark = ",")
        valueBox(
            value = value_total_recovered_cases, 
            subtitle = "Total Recovered Cases",
            icon = icon("user-shield"),
            color = "blue")}) 
    output$total_death_cases <- renderValueBox({
        value_total_death_cases  <- datajoin %>% 
            select(Total_Deaths) %>%
            sum() %>% 
            prettyNum(big.mark = ",")
        valueBox(
            value = value_total_death_cases, 
            subtitle = "Total Death Cases",
            icon = icon("user-times"),
            color = "red")}) 
    
#=TREND CASES=
    output$plotrendcases <- renderPlotly({
        trendindoall <- ggplot(datacovidlinepivot, aes(x = Date, y = Quantity), text=label) +
            geom_area(aes(fill=Category),position = position_dodge(0),alpha = 0.4)+
            geom_line(aes(color=Category)) +
            scale_x_date(date_breaks = "70 day", date_labels = "%d-%b-%Y") +
            scale_y_continuous(labels = comma_format()) +
            theme(panel.background = element_rect(fill = "#111111"),
                  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                  plot.background = element_rect(fill = "#111111"),
                  legend.position = "bottom",
                  legend.background = element_rect(fill = "#111111"),
                  text=element_text(color="white"),
                  axis.text.x=element_text(colour="white"),
                  axis.text.y=element_text(colour="white"))
        ggplotly(trendindoall) %>% 
          layout(legend=list(orientation="h",x=0.1,y=-0.2))})
    
#=PERCENTAGE CASES=
    output$plotprecentcases <- renderPlotly({
      piechart <- ggplot(datapie, aes(x=Category, y=Percentage, text = label)) +
        geom_col(fill=c("orange2","brown2","cornflowerblue")) +
        geom_text(aes(x=Category,y=Percentage,label=label2),
                  position = position_dodge(0.9),
                  vjust = 0, size = 5, color="white") +
        scale_y_continuous(labels = comma_format()) +
        theme(panel.background = element_rect(fill = "#111111"),
              panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              plot.background = element_rect(fill = "#111111"),
              text=element_text(color="white"),
              axis.text.x=element_text(colour="white"),
              axis.text.y=element_text(colour="white"))          
      ggplotly(piechart,tooltip = "text")})

#=MAP=
    output$mapcovid <- renderLeaflet({
        datajoin %>%
            st_as_sf() %>%
            leaflet() %>%
            addProviderTiles(providers$CartoDB.DarkMatter) %>%
            addPolygons(fillColor = ~pal(log(datajoin$Total_Cases)),
                        fillOpacity = 0.8,
                        weight = 2,
                        label = labels_map,
                        color = "white",
                        highlightOptions = highlightOptions(
                            color = "blue",
                            weight = 5,
                            bringToFront = T,
                            opacity = 0.8)) %>%
            addLegend(pal = pal,
                      values = log(datajoin$Total_Cases),
                      labFormat = labelFormat(transform = function(x) round(exp(x))),
                      opacity = 1, title = "Total Cases")}) 

#=CITY1=
    output$plotcity1 <- renderPlotly({
        datacity1 <- datacity1 %>% 
            filter(NAME_1 == input$selectinputcity)
        datacity1 <- ggplot(datacity1,aes(x=Category, y=Quantity,text=label)) +
            geom_col(fill=c("darkgoldenrod1","cornflowerblue","brown2")) +
            scale_y_continuous(labels = comma_format()) +
          theme(panel.background = element_rect(fill = "#111111"),
                panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                plot.background = element_rect(fill = "#111111"),
                legend.position = "bottom",
                legend.background = element_rect(fill = "#111111"),
                text=element_text(color="white"),
                axis.text.x=element_text(colour="white"),
                axis.text.y=element_text(colour="white"))
        ggplotly(datacity1,tooltip = "text") %>% 
          layout(legend=list(orientation="h",x=0.1,y=-0.2))})
    
#=CITY2=
    output$plotcity2 <- renderPlotly({
        datacity2 <- datacity2 %>% 
            filter(City == input$selectinputcity)
        datacity2 <- ggplot(datacity2, aes(x = Date, y = Quantity), text=label) +
            geom_line(aes(color=Category)) +
            geom_area(aes(fill=Category),position = position_dodge(0),alpha = 0.4)+
            scale_x_date(date_breaks = "100 day", date_labels = "%b-%Y") +
            scale_y_continuous(labels = comma_format()) +
            theme(panel.background = element_rect(fill = "#111111"),
                panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                plot.background = element_rect(fill = "#111111"),
                text=element_text(color="white"),
                axis.text.x=element_text(colour="white"),
                axis.text.y=element_text(colour="white"),
                legend.position = "none")
        ggplotly(datacity2)})
    
#=CITY3=
    output$plotcity3 <- renderPlotly({
      datacity3 <- datacity3 %>% 
        filter(City == input$selectinputcity)
      datacity3 <- ggplot(datacity3, aes(x = Date, y = Quantity), text=label) +
        geom_line(aes(color=Category)) +
        geom_area(aes(fill=Category),position = position_dodge(0),alpha = 0.4)+
        scale_x_date(date_breaks = "100 day", date_labels = "%b-%Y") +
        scale_y_continuous(labels = comma_format(),
                           breaks = seq(0, 3000000, 300000)) +
        theme(panel.background = element_rect(fill = "#111111"),
              panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              plot.background = element_rect(fill = "#111111"),
              text=element_text(color="white"),
              axis.text.x=element_text(colour="white"),
              axis.text.y=element_text(colour="white"),
              legend.position = "none")
      ggplotly(datacity3)})
    
    
})

