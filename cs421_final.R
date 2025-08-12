library(shiny)
library(mapgl)
library(sf)
library(here)
library(dplyr)

common_crs <- 4326

# Load
oil_data  <- st_read(here("data/OGD_Rigs/OGD_Rigs.shp"), quiet = TRUE)
gas_data  <- st_read(here("data/OGD_GasPlants/OGD_GasPlants.shp"), quiet = TRUE)
wind_data <- st_read(here("data/NDGISHUB_Wind_Turbines/Wind_Turbines.shp"), quiet = TRUE)
coal_data <- st_read(here("data/Surface_and_Underground_Coal_Mines_in_the_US/CoalMines_US_EIA.shp"), quiet = TRUE)


# Transform all to EPSG:4326 and trim to type + geometry
oil_pts  <- oil_data  %>% st_transform(common_crs) %>% mutate(type = "Oil Rigs")      %>% select(type, geometry)
gas_pts  <- gas_data  %>% st_transform(common_crs) %>% mutate(type = "Gas Plants")    %>% select(type, geometry)
wind_pts <- wind_data %>% st_transform(common_crs) %>% mutate(type = "Wind Turbines") %>% select(type, geometry)

# Filter coal to North Dakota (column is uppercase 'state' in your preview)
coal_nd  <- coal_data %>%
  filter(toupper(state) == "NORTH DAKOTA") %>%
  st_transform(common_crs) %>%
  mutate(type = "Coal Mines") %>%
  select(type, geometry)

# Single combined sf
energy_sf <- bind_rows(oil_pts, gas_pts, wind_pts, coal_nd)

type_colors <- c(
  "Oil Rigs"      = "orange",
  "Gas Plants"    = "red",
  "Wind Turbines" = "blue",
  "Coal Mines"    = "black"
)

energy_types <- sort(unique(energy_sf$type))

ui <- fluidPage(
  titlePanel("Energy Infrastructure in North Dakota"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "dataset",
        "Select dataset to display:",
        choices = c("All", energy_types),
        selected = "Oil Rigs"
      )
    ),
    mainPanel(
      maplibreOutput("map", height = "800px")
    )
  )
)

server <- function(input, output, session) {
  
  filtered_sf <- reactive({
    if (identical(input$dataset, "All")) energy_sf
    else filter(energy_sf, type == input$dataset)
  })
  
  output$map <- renderMaplibre({
    sf_data <- filtered_sf()
    req(nrow(sf_data) > 0)
    m <- maplibre(style = carto_style("positron")) %>%
      fit_bounds(sf_data, animate = FALSE)

    if (identical(input$dataset, "All")) {
      # Show all types at once with categorical coloring + legend
      m %>%
        add_circle_layer(
          id = "energy_pts",
          source = sf_data,
          circle_color = match_expr(
            "type",
            values = unname(energy_types),
            stops  = unname(type_colors[energy_types])
          ),
          circle_radius = 7,
          circle_opacity = 0.85,
          circle_stroke_color = "#ffffff",
          circle_stroke_width = 1,
          tooltip = "type",
          hover_options = list(circle_radius = 10)
          # , cluster_options = cluster_options()  # uncomment if you want clustering
        ) %>%
        add_categorical_legend(
          legend_title = "Type",
          values = energy_types,
          colors = unname(type_colors[energy_types]),
          circular_patches = TRUE
        )
    } else {
      # Single type view with solid color
      m %>%
        add_circle_layer(
          id = "energy_pts",
          source = sf_data,
          circle_color = type_colors[[input$dataset]],
          circle_radius = 8,
          circle_opacity = 0.85,
          circle_stroke_color = "#ffffff",
          circle_stroke_width = 1,
          tooltip = "type",
          hover_options = list(circle_radius = 11)
        )
    }
  })
}

shinyApp(ui, server)

