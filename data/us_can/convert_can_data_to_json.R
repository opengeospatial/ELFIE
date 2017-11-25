setwd("~/Documents/Projects/ELFIE/ELFIE/data/us_can/")

can_watersheds <- sf::st_layers("can/Watersheds.gdb/")
can_watersheds <- can_watersheds$name[3]
can_watersheds <- sf::read_sf("can/Watersheds.gdb/", layer = can_watersheds)

can_auquifer <- sf::read_sf("can/richelieu_aq/richelieu_aq.shp")

can_well <- sf::read_sf("can/rich_well/richelieu_well.shp") 

can_mon_well <- sf::read_sf("can/mon_rich/mon_rich.shp")

can_hydat <- sf::st_layers("can/Hydat_converted_Champlain.gdb") # Not sure why this doesn't work
# ogrinfo Hydat_converted_Champlain.gdb did work grapping "GageLoc" layer
can_hydat <- sf::read_sf("can/Hydat_converted_Champlain.gdb/", layer = "GageLoc")

sf::write_sf(sf::st_transform(can_watersheds, crs = "+init=epsg:4326"), "nrcan_watersheds_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_auquifer, crs = "+init=epsg:4326"), "nrcan_aquifer_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_well, crs = "+init=epsg:4326"), "nrcan_well_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_mon_well, crs = "+init=epsg:4326"), "nrcan_mon-well_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_hydat, crs = "+init=epsg:4326"), "nrcan_hydat_cr.json", driver = "GeoJSON")
