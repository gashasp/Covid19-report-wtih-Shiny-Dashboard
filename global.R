library(shiny)
library(shinydashboard)
library(shinythemes)
library(dplyr)
library(DT)
library(plotly)
library(jpeg)
library(readr)
library(sf)
library(scales)
library(leaflet)
library(glue)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(shinyWidgets)

#=====SET UP DATA=====
#READ DATA SET
rawcovid <- read.csv("covid_19_indonesia_time_series_all.csv", 
                     fileEncoding = 'UTF-8-BOM')
rawcovid <- rawcovid %>% rename(New_Cases = New.Cases,
                                New_Deaths = New.Deaths,
                                New_Recovered = New.Recovered,
                                New_Active_Cases = New.Active.Cases,
                                Total_Cases = Total.Cases,
                                Total_Deaths = Total.Deaths,
                                Total_Recovered = Total.Recovered,
                                Total_Active_Cases = Total.Active.Cases)


#=====RAW DATA=====
datacovidd <- 
  rawcovid %>% 
  select(Date,Location,New_Cases,New_Deaths,New_Recovered,New_Active_Cases,
         Total_Cases,Total_Deaths,Total_Recovered,Total_Active_Cases,
         Longitude,Latitude)


#=====REPORT=====

#=VALUE BOX=
datacovidline <- 
  aggregate.data.frame(x= list(Total_Active_Cases = datacovidd$Total_Active_Cases,
                               Total_Recovered = datacovidd$Total_Recovered,
                               Total_Deaths = datacovidd$Total_Deaths),
                       by = list(Date = datacovidd$Date),
                       FUN = sum)
datacovidlinepivot <- pivot_longer(data = datacovidline,cols = c("Total_Active_Cases","Total_Recovered","Total_Deaths"),
                                   names_to = "Category",values_to = "Quantity")

#=TREND CASES=
datacovidline <- 
  aggregate.data.frame(x= list(Total_Active_Cases = datacovidd$Total_Active_Cases,
                               Total_Recovered = datacovidd$Total_Recovered,
                               Total_Deaths = datacovidd$Total_Deaths),
                       by = list(Date = datacovidd$Date),
                       FUN = sum)
datacovidline$Date <- mdy(datacovidline$Date)
datacovidlinepivot <- pivot_longer(data = datacovidline,cols = c("Total_Active_Cases","Total_Recovered","Total_Deaths"),
                                   names_to = "Category",values_to = "Quantity") 

datacovidlinepivot <- 
  datacovidlinepivot %>% 
  mutate(label=glue(
    "Category: {Category}
    Date: {Date}
    Quantity: {comma(Quantity)} cases"))

#=PERCENTAGE CASES=
datapie <-
  datacovidlinepivot %>%
  group_by(Category) %>%
  summarise(Quantity = sum(Quantity)) %>%
  mutate(Percentage = round(Quantity/sum(datacovidlinepivot$Quantity)*100,2),
         label=glue(
           "Category: {Category}
           Percentage: {Percentage}%"),
         label2=glue(
           "{Percentage}%"))

#=MAP=
covidindonesia <- 
  aggregate.data.frame(x= list(Total_Cases = datacovidd$Total_Cases,
                               Total_Deaths = datacovidd$Total_Deaths,
                               Total_Active_Cases = datacovidd$Total_Active_Cases,
                               Total_Recovered = datacovidd$Total_Recovered),
                       by = list(Location = datacovidd$Location),
                       FUN = sum)
covidindonesia <- 
  covidindonesia %>% 
  filter(Location != "Indonesia" & Location != "Kalimantan Utara")
map <- read_rds("gadm36_IDN_1_sf.rds")
datajoin <- map %>% 
  mutate(NAME_1= case_when(NAME_1 == "Jakarta Raya" ~ "DKI Jakarta",
                           NAME_1 == "Yogyakarta" ~ "Daerah Istimewa Yogyakarta",
                           NAME_1 == "Bangka Belitung" ~ "Kepulauan Bangka Belitung",
                           TRUE ~ NAME_1)) %>% 
  left_join(covidindonesia, by = c("NAME_1" = "Location")) %>%
  data.frame()
pal <- colorNumeric(palette = "Reds", domain = log(datajoin$Total_Cases))
labels_map <-
  glue("<b>{datajoin$NAME_1}</b><br>
       Total Cases : {comma(datajoin$Total_Cases)}<br>
       Positive Cases : {comma(datajoin$Total_Active_Cases)}<br>
       Recover Cases : {comma(datajoin$Total_Recovered)}<br>
       Death Cases : {comma(datajoin$Total_Deaths)}") %>%
  lapply(htmltools::HTML)


#Plot1
datacity1 <- 
  datajoin %>% 
  select(NAME_1,Total_Active_Cases,Total_Recovered,Total_Deaths) %>% 
  pivot_longer(cols = c("Total_Active_Cases","Total_Recovered","Total_Deaths"),
               names_to = "Category",values_to = "Quantity") %>% 
  select(NAME_1,Category,Quantity) %>% 
  group_by(NAME_1,Category) %>% 
  summarise(Quantity = sum(Quantity)) %>% 
  ungroup() %>% 
  group_by(NAME_1) %>% 
  mutate(Percentage = round(Quantity/sum(Quantity)*100,2),
         label=glue(
           "City: {NAME_1}
            Category: {Category}
            Quantity: {comma(Quantity)} cases
            Percentage: {Percentage}%"))

#Plot2
datacity2 <- 
  aggregate.data.frame(x= list(Total_Active_Cases = datacovidd$Total_Active_Cases,
                               Total_Recovered = datacovidd$Total_Recovered,
                               Total_Deaths = datacovidd$Total_Deaths),
                       by = list(Date = datacovidd$Date,
                                 City = datacovidd$Location),
                       FUN = sum)
datacity2$Date <- mdy(datacity2$Date)
datacity2 <- 
  datacity2 %>% 
  pivot_longer(cols = c("Total_Active_Cases","Total_Recovered","Total_Deaths"),
               names_to = "Category",values_to = "Quantity") %>% 
  mutate(label=glue(
    "City: {City}
    Category: {Category}
    Quantity: {comma(Quantity)} cases"))

#Plot3
datacity3 <- 
  aggregate.data.frame(x= list(New_Active_Cases = datacovidd$New_Active_Cases,
                               New_Recovered = datacovidd$New_Recovered,
                               New_Deaths = datacovidd$New_Deaths),
                       by = list(Date = datacovidd$Date,
                                 City = datacovidd$Location),
                       FUN = sum)
datacity3$Date <- mdy(datacity3$Date)
datacity3 <- 
  datacity3 %>% 
  pivot_longer(cols = c("New_Active_Cases","New_Recovered","New_Deaths"),
               names_to = "Category",values_to = "Quantity") %>% 
  mutate(label=glue(
    "City: {City}
    Category: {Category}
    Quantity: {comma(Quantity)} cases"))










