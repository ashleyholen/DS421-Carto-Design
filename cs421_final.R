library(shiny)
library(mapgl)
library(sf)
library(here)
library(dplyr)

common_crs <- 4326

# Load and transform datasets
oil_data <- st_read(here("data/OGD_Rigs/OGD_Rigs.shp")) %>% st_transform(common_crs)
gas_data <- st_read(here("data/OGD_GasPlants/OGD_GasPlants.shp")) %>% st_transform(common_crs)
wind_data <- st_read(here("data/NDGISHUB_Wind_Turbines/Wind_Turbines.shp")) %>% st_transform(common_crs)
coal_data <- st_read(here("data/Surface_and_Underground_Coal_Mines_in_the_US/CoalMines_US_EIA.shp")) %>%
  st_transform(common_crs) %>%
  filter(state == "NORTH DAKOTA")

datasets <- list(
  "Oil Rigs" = oil_data,
  "Gas Plants" = gas_data,
  "Wind Turbines" = wind_data,
  "Coal Mines" = coal_data
)

ui <- fluidPage(
  titlePanel("Energy Infrastructure in North Dakota"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Select dataset to display:", choices = names(datasets), selected = "Oil Rigs")
    ),
    mainPanel(
      maplibreOutput("map", height = "800px")
    )
  )
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    req(input$dataset)
    sf_data <- datasets[[input$dataset]]
    
    layer_color <- switch(input$dataset,
                          "Oil Rigs" = "orange",
                          "Gas Plants" = "red",
                          "Wind Turbines" = "blue",
                          "Coal Mines (ND)" = "black",
                          "gray"
    )
    
    maplibre(style = carto_style("positron")) %>%
      fit_bounds(sf_data, animate = FALSE) %>%
      add_vector_source("selected_source", sf_data) %>%
      add_circle_layer(
        id = "selected_layer",
        source = "selected_source",
        circle_color = layer_color,
        circle_radius = 8,
        circle_opacity = 0.8
      )
  })
}

shinyApp(ui, server)

