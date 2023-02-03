<p align="center">
  <a href="https://professionnels.ofb.fr/fr/reseau-ongules-sauvages">
    <img src="https://github.com/christofoto/ongules/raw/main/images/header.png" alt="Logo">
  </a>

  <!-- <h3 align="center">Logo</h3> -->

  <!-- <h1 style="text-align:center">
    Chaine de traitements </h1>
  <h3 style="text-align:center">
  pour déterminer le nombre d'espèces d'ongulés<br> 
  présentes en tout point de la France métropolitaine
  <br>
    </h3> -->
</p>

<a name="readme-top"></a>

### Table des matières

- [Prérequis](#prérequis)
- [Organisation des dossiers](#organisation-des-dossiers)
- [En avant pour les traitements](#en-avant-pour-les-traitements)
- [Auteur](#auteur)
- [Copyright and license](#copyright-and-license)

### Prérequis

Avoir les logiciels suivants installés sur son ordinateur :

- [QGIS 3.22 LTR](https://www.qgis.org/fr/site/forusers/download.html), la dernière version LTR au moment de la création de ce tutoriel
- <b>OSGeo4W Shell</b> : c'est le terminal qui est disponible quand on installe QGIS aussi depuis un exécutable que depuis l'installateur OSGeo4W. Cela permettra d'utiliser la librairie GDAL pour effectuer des traitements directement en ligne de commande sans avoir à passer par QGIS
- Un éditeur de texte avancé de type [Visual Studio Code](https://code.visualstudio.com/) ou [Notepad++](https://notepad-plus-plus.org/) est un plus pour travailler sur son code

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Organisation des dossiers

Une proposition d'organisation des dossiers pour ces traitements

```text
data/
  │── vectors/
  │   └── vector_for_extent.shp
  │
  │── rasters/
  │   ├── grid_france_100.tif
  │   └── raster_espece_burn_1/
  │       └── *.tif*
  │
  └── especes/
          └── *.shp
```

**_Un exemplaire zippé des dossiers comme ci-dessus avec le fichier vectoriel de la France est téléchargeable [ICI](https://github.com/christofoto/ongules/raw/main/ressources/data.zip)_**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### En avant pour les traitements

Les lignes de commandes ci-dessous sont valables pour le terminal OSGeo4W Shell de Windows.

#### Quelques variables en entrée...

Pour bien commencer, il faut donc remplacer "CHEMIN_COMPLET_VERS_DATA" par le chemin en entier du dossier "data".<br>
On suppose que l'organisation choisie des dossiers est celle proposée ci-dessus. Si ce n'est pas le cas, bien renseigné les chemin complet pour chaque dossier.

```code
set folder_vector_for_extent=CHEMIN_COMPLET_VERS_DATA\data\vectors
set folder_raster=CHEMIN_COMPLET_VERS_DATA\data\rasters
set folder_raster_burn=CHEMIN_COMPLET_VERS_DATA\data\rasters\raster_espece_burn_1
set folder_vector=CHEMIN_COMPLET_VERS_DATA\data\especes
set disk=%folder_raster:~0,2%
```

#### Préparation du raster de référence

Dans notre cas, on veut avoir un raster qui recouvre la France, Corse comprise.
Le fichier vectoriel est au format Shapefile et a été construit à partir de la base de données [GEOFLA](https://geoservices.ign.fr/geofla) de l'IGN.

```code
set folder_vector_for_extent=CHEMIN_COMPLET_VERS_DATA\data\vectors
set folder_raster=CHEMIN_COMPLET_VERS_DATA\data\rasters
set folder_raster_burn=CHEMIN_COMPLET_VERS_DATA\data\rasters\raster_espece_burn_1
set folder_vector=CHEMIN_COMPLET_VERS_DATA\data\especes
set disk=%folder_raster:~0,2%
```

```code
cd %folder_vector_for_extent%
%disk%
gdal_rasterize -burn 0 -ot Int16 -ts 100 100 -a_nodata -32768 france.shp %folder_raster%\grid_france_100.tif
```

```code
copy %folder_raster%\grid_france_100.tif %folder_raster%\grid_france_100_final.tif
```

```code
cd %folder_vector%
%disk%
for %F in (*.shp) do copy %folder_raster%\grid_france_10000.tif %folder_raster_burn%\grid_france_10000_%F.tif
```

```code
for %F in (*.shp) do gdal_rasterize -burn 1 "%F" %folder_raster_burn%\grid_france_100_%F.tif
```

```code
cd %folder_raster_burn%
for %F in (*.tif) do gdal_calc -A  %folder_raster%\grid_france_10000_final.tif -B "%F" --outfile=%folder_raster%\grid_france_100_final.tif --calc="(A+B)"
```

```code
cd %folder_raster_burn%
del *.tif
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Auteur

[Christophe Ferrier](https://github.com/christofoto)<br>
**_Technicien de recherche à l'[OFB](https://www.ofb.gouv.fr/)_**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ### Remerciements

Some Text -->

<!-- <p align="right">(<a href="#readme-top">back to top</a>)</p>
 -->

### Copyright and license

Code released under the [MIT License](https://reponame/blob/master/LICENSE).

Enjoy :metal:
