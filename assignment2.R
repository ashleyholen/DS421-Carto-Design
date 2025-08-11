library(shiny)
library(mapgl)
library(sf)
library(dplyr)
library(viridisLite)
library(classInt)
library(here)

county_data <- st_read(here("data/county_data.gpkg"))
st_geometry(county_data) <- "geom"
county_data <- st_transform(county_data, 4326)
county_data <- st_make_valid(county_data)

ui <- fluidPage(
  titlePanel("Language Map by County"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "language",
        "Select Language:",
        choices = sort(unique(county_data$language)),
        selected = "Spanish"
      )
    ),
    mainPanel(
      maplibreOutput("map", height = "700px")
    )
  )
)

server <- function(input, output, session) {
  output$map <- renderMaplibre({
    req(input$language)
    
    filtered <- county_data %>% filter(language == input$language)
    
    summary_data <- filtered %>%
      group_by(GEOID, geoname) %>%
      summarize(percent_speakers = sum(percent_speakers, na.rm = TRUE), .groups = "drop")
    
    geom_data <- filtered %>%
      distinct(GEOID, geom)
    
    geom_data_df <- sf::st_drop_geometry(geom_data)
    
    lang_sf <- summary_data %>%
      left_join(geom_data_df, by = "GEOID") %>%
      st_as_sf(sf_column_name = "geom") %>%
      st_make_valid()
    
    req(nrow(lang_sf) > 0)
    
    # Create reversed magma palette function
    reversed_inferno <- function(n) {
      rev(viridisLite::inferno(n))
    }
    
    continuous_scale <- interpolate_palette(
      data = lang_sf,
      column = "percent_speakers",
      method = "equal",
      n = 7,
      palette = reversed_inferno
    )
    
    maplibre(style = carto_style("positron")) |>
      fit_bounds(lang_sf, animate = FALSE) |>
      add_fill_layer(
        id = "lang_layer",
        source = lang_sf,
        fill_color = continuous_scale$expression,
        fill_opacity = 0.8,
        fill_outline_color = "#444444"
      ) |>
      add_legend(
        "Percent Speakers",
        values = get_legend_labels(continuous_scale),
        colors = get_legend_colors(continuous_scale),
        type = "continuous"
      )
  })
}

shinyApp(ui, server)

