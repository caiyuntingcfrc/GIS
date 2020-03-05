# prep and options --------------------------------------------------------
# rm
rm(list = ls()); cat("\14")
# source
devtools::source_url("https://raw.githubusercontent.com/caiyuntingcfrc/misc/function_poverty/func_ins.pack.R")
# ins.pack
ins.pack("tidyverse", "rgdal", "rgeos", "maptools", "sf", "ggplot2", "data.table")
# setwd
setwd("d:/R_wd/GIS/")

# read SHP ----------------------------------------------------------------
# read
tw_town <- st_read("TWD97_TOWN_mapdata201911260954/TOWN_MOI_1081121.shp", 
                   crs = 3826L)

# proj4
# proj <- CRS("+proj=tmerc +lat_0=0 +lon_0=121 +k=0.9999 +x_0=250000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
proj <- "+proj=tmerc +lat_0=0 +lon_0=121 +k=0.9999 +x_0=250000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
tw_town <- readOGR("TWD97_TOWN_mapdata201911260954", 
                   stringsAsFactors = FALSE, 
                   encoding = "UTF-8", 
                   use_iconv = TRUE, 
                   layer = "TOWN_MOI_1081121", 
                   p4s = proj)

head(tw_town@polygons)
setDT(tw_town@polyg)
tw_town@data[ , COUNTYID := ifelse(COUNTYID %in% c("W", "X", "Z"), NA, COUNTYID)]

# spTransform
tw.wgs84 <- spTransform(tw_town, CRSobj = proj)
ggplot(tw.wgs84, aes(x = long, y = lat, group = group)) + geom_path()
ggplot(tw_town, aes(x = long, y = lat, group = group)) + geom_path()
tw.wgs84@proj4string
plot(st_geometry(tw_town))
plot(tw_town[1])


setDT(tw_town@data)
l <- grep("NAME", names(tw_town@data))
tw_town@data <- tw_town@data[ , lapply(.SD, iconv, from = "UTF-8", to = "CP950")]
head(tw_town@data)
utils::View(tw_town@data)
