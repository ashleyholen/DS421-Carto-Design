library(shiny)
library(mapgl)
library(mapboxapi)
library(sf)

# Property coordinates
beach_coords <- c(-157.7151405759049, 21.39268638716335)

# Create sf object for the property
beach_sf <- st_as_sf(data.frame(
  id = "beach",
  name = "New Class A Apartment",
  lon = beach_coords[1],
  lat = beach_coords[2]
), coords = c("lon", "lat"), crs = 4326)

# Generate isochrone polygon using Mapbox API
isochrone <- mb_isochrone(beach_coords, profile = "driving", time = 15)

# UI
ui <- fluidPage(
  tags$link(href = "https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap", rel = "stylesheet"),
  story_map(
    map_id = "map",
    font_family = "Poppins",
    sections = list(
      "intro" = story_section(
        title = "LANIKAI BEACH, KAILUA HAWAIʻI",
        content = list(
          p("Lanikai Beach Park"),
          img(src = "lanikai.jpg", width = "300px")
        ),
        position = "center"
      ),
      "marker" = story_section(
        title = "LANIKAI BEACH PARK",
        content = list(
          p("Discover paradise at Lanikai Beach - where crystal-clear waters meets soft white sand.")
        )
      ),
      "isochrone" = story_section(
        title = "EXPLORE LANIKAI BEACH AREA",
        content = list(
          p("Within a 15-minute drive from Lanikai Beach, explore Kailua Town’s shops and cafes, scenic hikes like the Pillbox Trail, and the beautiful shores of Kailua Beach.")
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  output$map <- renderMapboxgl({
    mapboxgl(
      scrollZoom = FALSE,
      center = c(-157.7151405759049, 21.39268638716335),
      zoom = 12
    )
  })
  
  on_section("map", "intro", {
    mapboxgl_proxy("map") |>
      clear_layer("property_layer") |>
      clear_layer("isochrone") |>
      fly_to(
        center = c(-157.7151405759049, 21.39268638716335),
        zoom = 12,
        pitch = 0,
        bearing = 0
      )
  })
  
  on_section("map", "marker", {
    proxy <- mapboxgl_proxy("map")
    
    proxy |>
      clear_layer("isochrone") |>
      add_source(id = "property", data = beach_sf) |>
      add_circle_layer(
        id = "property_layer",
        source = "property",
        circle_color = "darkblue",
        circle_radius = 10,
        circle_opacity = 0.8,
        popup = "name"
      ) |>
      fly_to(
        center = beach_coords,
        zoom = 16,
        pitch = 45,
        bearing = -90
      )
    
  })
  
  on_section("map", "isochrone", {
    mapboxgl_proxy("map") |>
      add_fill_layer(
        id = "isochrone",
        source = isochrone,
        fill_color = "lightblue",
        fill_opacity = 0.5
      ) |>
      fit_bounds(
        isochrone,
        animate = TRUE,
        duration = 8000,
        pitch = 75
      )
  })
}

# Run the app
shinyApp(ui, server)