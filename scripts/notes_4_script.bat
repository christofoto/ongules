set folder_raster=CHEMIN_COMPLET_VERS_DATA\data\rasters
set folder_raster_burn=CHEMIN_COMPLET_VERS_DATA\data\rasters\raster_espece_burn_1
set folder_vector=CHEMIN_COMPLET_VERS_DATA\data\especes

D:
cd %folder_vector%

copy %folder_raster%\grid_france_100.tif %folder_raster%\grid_france_100_final.tif

for %F in (*.shp) do copy %folder_raster%\grid_france_100.tif %folder_raster_burn%\grid_france_100_%F.tif
for %F in (*.shp) do gdal_rasterize -burn 1 "%F" %folder_raster_burn%\grid_france_100_%F.tif

cd %folder_raster_burn%
for %F in (*.tif) do gdal_calc -A  %folder_raster%\grid_france_100_final.tif -B "%F" --outfile=%folder_raster%\grid_france_100_final.tif --calc="(A>=0)*(A+B)"

cd %folder_raster_burn%
del *.tif