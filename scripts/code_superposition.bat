@echo off
cls
set /p CHEMIN_COMPLET_VERS_DATA=Indiquer le chemin vers le dossier "data" :
@REM set CHEMIN_COMPLET_VERS_DATA=D:\SIG\travail\test\ongules_superposition
set folder_vector_for_extent=%CHEMIN_COMPLET_VERS_DATA%\data\vectors
set folder_raster=%CHEMIN_COMPLET_VERS_DATA%\data\rasters
set folder_raster_burn=%CHEMIN_COMPLET_VERS_DATA%\data\rasters\raster_espece_burn_1
set folder_vector=%CHEMIN_COMPLET_VERS_DATA%\data\especes
set disk=%folder_raster:~0,2%

cd %folder_vector_for_extent%
%disk%
gdal_rasterize -burn 0 -ot Int16 -tr 100 100 -a_nodata -32768 france.shp %folder_raster%\grid_france_100.tif
pause

copy %folder_raster%\grid_france_100.tif %folder_raster%\grid_france_100_final.tif
pause

cd %folder_vector%
%disk%
for %%F in (*.shp) do (
    copy %folder_raster%\grid_france_100.tif %folder_raster_burn%\grid_france_100_%%F.tif
    gdal_rasterize -burn 1 %%F %folder_raster_burn%\grid_france_100_%%F.tif
    )

cd %folder_raster_burn%
for %%F in (*.tif) do gdal_calc -A  %folder_raster%\grid_france_100_final.tif -B "%%F" --outfile=%folder_raster%\grid_france_100_final.tif --calc="(A+B)"

cd %folder_raster_burn%
del *.tif