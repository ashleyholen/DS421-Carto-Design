library(shiny)
library(bslib)
library(mapgl)
library(sf)
library(dplyr)
library(viridis)
library(here)

# Load county data
county_data <- st_read(here("data/county_data.gpkg"))

ui <- page_sidebar(
  title = "Language Map by County",
  sidebar = sidebar(
    selectInput(
      "language",
      "Select Language:",
      choices = sort(unique(county_data$language)),
      selected = "Spanish"
    )
  ),
  card(
    full_screen = TRUE,
    maplibreOutput("map")
  )
)

server <- function(input, output, session) {
  
  output$map <- renderMaplibre({
    
    # Filter to selected language
    lang_data <- county_data %>%
      filter(language == input$language)
    
    # Make sure geometries are valid
    lang_data <- st_make_valid(lang_data)
    
    # Create color column from viridis
    pal <- colorNumeric(viridis(256), domain = lang_data$percent_speakers)
    lang_data <- lang_data %>%
      mutate(
        fill_col = pal(percent_speakers),
        popup_text = paste0(
          "<b>", geoname, "</b><br>",
          "Percent Speakers: ", round(percent_speakers, 2), "%"
        )
      )
    
    # Build map
    maplibre(style = carto_style("positron")) |>
      fit_bounds(lang_data, animate = FALSE) |>
      add_fill_layer(
        id = "lang_layer",
        source = lang_data,       # full sf object
        fill_color = "fill_col",  # matches column name
        fill_opacity = 0.7,
        popup = "popup_text"
      )
  })
}

shinyApp(ui, server)

        