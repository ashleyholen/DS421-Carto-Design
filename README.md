# Welcome to DS 421: Cartographic Design! 🗺️

This is the repository for the class DS 421: Catrographic Design in the Summer II 2025 Term at Chaminade University of Honolulu. 
Throughout this course, we utilized R to create a variety of maps, ending with an interactive Shiny App for our final project.

## Energy Infrastucture in North Dakota 🌾
For my final project, I decided to create a map highlighting the location of primary energy infrastructures across my home state of North Dakota. North Dakota is the second-largest crude oil producer in the US, largely due to the Bakken Formation located in the Western part of the state. The state holds the second-largest lignite coal reserves globally and is a major producer, with lignite used to generate most of its electricity. Additionally, North Dakota is a major natural gas producer, with a significant portion of its production exported. Also, North Dakota ranks seventh in the country for wind energy capacity and produced 31% of its electricity from wind in 2020. In my map, I chose to display the geographic locations of these 4 primary resources: oil, gas, coal, and wind. 

## Before You Begin! 📩
To run this app on your local device, first you are to download these specificed files. You are provided with these folders in this GitHub Repostitory, located in the data folder. Download them in their entirety to your local device, since all files must be downloaded in order to support the .shp file. 

- #### 'NDGISHUB_Wind_Turbines_-1094680039359531429' (Last Updated 8/12/2025)
- #### 'OGD_GasPlants' (Last Updated 8/11/2025)
- #### 'OGD_Rigs' (Last Updated 8/11/2025)
- #### 'Surface_and_Underground_Coal_Mines_in_the_US_4558145817808566859' (Last Updated 8/4/2025)

Then, download the app file which renders the interactive map. This is located on the main branch of this repository. 
- #### 'app.R'

⚠️ If there are issues that occur when downloading the data directly from this repository, here are the direct links to each data source. Download each folder onto your local device, unzip them since they are natively .zip files, and then create a data folder in your working directory, placing these 4 unziped folders in there for each energy source. ⚠️ 

- #### raw wind data (Shapefile): https://gishubdata-ndgov.hub.arcgis.com/datasets/NDGOV::ndgishub-wind-turbines/about
- #### raw coal data (Shapefile): https://hub.arcgis.com/datasets/fedmaps::surface-and-underground-coal-mines-in-the-u-s--2/about
- #### raw oil data (OGD_Rigs.zip): https://gis.dmr.nd.gov/gisdownload.asp
- #### raw gas data (OGD_GasPlants.zip): https://gis.dmr.nd.gov/gisdownload.asp

## Running the App (app.R)

You can now run the app.R file on through RStudio on your local device. This will render the Shiny app, allowing you to interact with the map. There is a drop down menu on the left side of your screen where you can choose which energy source to view: All, Coal Mines, Gas Plants, Oil Rigs, Wind Tuurbines. Below you can see an image of what the map should render when selecting 'All'. When hovering over any point, the unique identifier will be displayed via tooltip. 

<img width="1881" height="912" alt="ND Energy Map" src="https://github.com/user-attachments/assets/2f91cdce-9f7e-4d51-9077-070fa2f20475" />

## Posit Connect Cloud

This Shiny app is also located on my Posit Connect Cloud account. Here, no data downloads or local RStudio is required, The map can simply be viewed and interacted with on my account, ashleyholen. 

#### https://connect.posit.cloud/ashleyholen/content/0198a602-cbb4-a013-cfe9-8d2c4b846a8f

<img width="300" height="168" alt="download" src="https://github.com/user-attachments/assets/1c9b75e5-40e5-4acf-8c1d-6b52f751d8ff" />


You are all set! Enjoy learning about ND Energy! ⚡
