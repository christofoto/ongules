@echo off
cls
echo **// Chaine de traitement pour determiner le nombre d'espèces d'ongules presentes en tout point de la France \\**
set /p CHEMIN_COMPLET_VERS_DATA=Indiquer le chemin vers le dossier "data" :
@REM set CHEMIN_COMPLET_VERS_DATA=D:\SIG\travail\test\ongules_superposition
set folder_vector_for_extent=%CHEMIN_COMPLET_VERS_DATA%\data\vectors
set folder_raster=%CHEMIN_COMPLET_VERS_DATA%\data\rasters
set folder_raster_burn=%CHEMIN_COMPLET_VERS_DATA%\data\rasters\raster_espece_burn_1
set folder_vector=%CHEMIN_COMPLET_VERS_DATA%\data\especes
set disk=%folder_raster:~0,2%

echo **// Creation de la couche de reference \\**
pause
cd %folder_vector_for_extent%
%disk%
gdal_rasterize -burn 0 -ot Int16 -tr 100 100 -a_nodata -32768 france.shp %folder_raster%\grid_france_100.tif

echo **// Creation de la couche finale pour les calculs \\**
pause
copy %folder_raster%\grid_france_100.tif %folder_raster%\grid_france_100_final.tif

echo echo **// C'est parti pour les traitements !! \\**
pause
cd %folder_vector%
%disk%
for %%F in (*.shp) do (
    copy %folder_raster%\grid_france_100.tif %folder_raster_burn%\grid_france_100_%%F.tif
    gdal_rasterize -burn 1 %%F %folder_raster_burn%\grid_france_100_%%F.tif
    )

echo echo **// Derniers calculs pour la couche finale \\**
pause
cd %folder_raster_burn%
for %%F in (*.tif) do gdal_calc -A  %folder_raster%\grid_france_100_final.tif -B "%%F" --outfile=%folder_raster%\grid_france_100_final.tif --calc="(A+B)"

set /p del_chunks=Voulez-vous supprimmer les rasters intermediaires des espèces (o/n) ? :
if %del_chunks%==o (del %folder_raster_burn%\*.tif) else (echo "Les rasters intermediaires ont ete conserves")
