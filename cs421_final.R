library(sf)
library(dplyr)
library(ggplot2)
library(here)

# Read data
oil_data <- st_read(here("data/OGD_Rigs/OGD_Rigs.shp"))
gas_data <- st_read(here("data/OGD_GasPlants/OGD_GasPlants.shp"))
wind_data <- st_read(here("data/NDGISHUB_Wind_Turbines/Wind_Turbines.shp"))
coal_data <- st_read(here("data/Surface_and_Underground_Coal_Mines_in_the_US/CoalMines_US_EIA.shp"))

# Reproject all datasets to EPSG:4326
common_crs <- 4326
oil_data <- st_transform(oil_data, crs = common_crs)
gas_data <- st_transform(gas_data, crs = common_crs)
wind_data <- st_transform(wind_data, crs = common_crs)
coal_data <- st_transform(coal_data, crs = common_crs)

# Filter coal data to North Dakota
coal_data <- coal_data %>% filter(state == "NORTH DAKOTA")

# Plot all datasets
ggplot() +
  geom_sf(data = oil_data, color = "orange", size = 2) +
  geom_sf(data = gas_data, color = "red", size = 2) +
  geom_sf(data = wind_data, color = "blue", size = 0.4, alpha = 0.6) +
  geom_sf(data = coal_data, color = "black", size = 1.2) +
  theme_minimal() +
  labs(
    title = "Energy Infrastructure in North Dakota",
    subtitle = "Oil Rigs, Gas Plants, Wind Turbines, and Coal Mines"
  )


