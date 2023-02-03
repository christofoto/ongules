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
On suppose que l'organisation choisie des dossiers est celle proposée ci-dessus. Si ce n'est pas le cas, bien renseigner le chemin pour chaque dossier.<br>

> **IMPORTANT** : veiller à bien utiliser deux dossiers différents pour les rasters. Un pour le raster de référence et le final. Un pour les rasters qui contiendront les données pour chaque espèce.

```code
set folder_vector_for_extent=CHEMIN_COMPLET_VERS_DATA\data\vectors
set folder_raster=CHEMIN_COMPLET_VERS_DATA\data\rasters
set folder_raster_burn=CHEMIN_COMPLET_VERS_DATA\data\rasters\raster_espece_burn_1
set folder_vector=CHEMIN_COMPLET_VERS_DATA\data\especes
set disk=%folder_raster:~0,2%
```

#### Préparation des ingrédients...

Dans notre cas, on veut avoir un raster qui recouvre la France, Corse comprise.
Le fichier vectoriel est au format Shapefile et a été construit à partir de la base de données [GEOFLA](https://geoservices.ign.fr/geofla) de l'IGN.<br>
On se rend dans le dossier contenant le fichier vectoriel de la France qui nous servira de référence pour l'emprise du raster.<br>
Grâce à la commande [gdal_rasterize](https://gdal.org/programs/gdal_rasterize.html), on créé un raster avec des pixels de 100m de côté (du coup un pixel = un hectare :+1:). Tous les pixels qui recouvrent la surface d'un polygone prennent la valeur 0. Pour les autres, c'est du NoData.

```code
cd %folder_vector_for_extent%
%disk%
gdal_rasterize -burn 0 -ot Int16 -tr 100 100 -a_nodata -32768 france.shp %folder_raster%\grid_france_100.tif
```

On fait une copie du fichier de référence histoire de le laisser tranquille pour une autre utilisation éventuellement.

```code
copy %folder_raster%\grid_france_100.tif %folder_raster%\grid_france_100_final.tif
```

On se rend dans le dossier contenant les couches vectorielles de chaque espèce d'ongulés qu'on veut utiliser dans le traitement final. Pour chaque couche vectorielle est créé un raster à partit du raster de référence.

```code
cd %folder_vector%
%disk%
for %F in (*.shp) do copy %folder_raster%\grid_france_100.tif %folder_raster_burn%\grid_france_100_%F.tif
```

#### On peut lancer la cuisson...

Après s'être assuré d'être dans le dossier contenant les couches vectorielles des espèces, on va pouvoir de nouveau utiliser la commande [gdal_rasterize](https://gdal.org/programs/gdal_rasterize.html). Tous les pixels qui recouvrent la surface d'un polygone prennent la valeur 1. Pour les autres, ce sera la valeur 0.

```code
cd %folder_vector%
%disk%
for %F in (*.shp) do gdal_rasterize -burn 1 "%F" %folder_raster_burn%\grid_france_100_%F.tif
```

#### Où l'on dresse le plat pour le servir :v:

On se rend dans le dossier contenant les rasters des espèces. Et on additionne les uns à la suite des autres ces derniers au raster final. Au départ tous les pixels de la France ont la valeur 0. A chaque fois que le pixel correspondant d'une espèce à la valeur 1 elle sera augmenté de 1. Au final, la valeur d'un pixel ira de 0 (aucune espèce présente) au maximum correspondant au nombre total d'espèces, soit 11 dans notre cas.

```code
cd %folder_raster_burn%
for %F in (*.tif) do gdal_calc -A  %folder_raster%\grid_france_100_final.tif -B "%F" --outfile=%folder_raster%\grid_france_100_final.tif --calc="(A+B)"
```

Pour dégager de l'espace sur l'ordinateur, on peut supprimer les rasters concernant les espèces.

```code
cd %folder_raster_burn%
del *.tif
```

> Le code sans les commentaires est téléchargeable [ICI](https://github.com/christofoto/ongules/blob/main/scripts/code_superposition.txt).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Auteur

[Christophe Ferrier](https://github.com/christofoto) / _Technicien de recherche à l'[OFB](https://www.ofb.gouv.fr/)_

<!-- <p align="right">(<a href="#readme-top">back to top</a>)</p>
 -->
<!-- ### Remerciements

Some Text -->

<!-- <p align="right">(<a href="#readme-top">back to top</a>)</p>
 -->

### Copyright and license

Code released under the [MIT License](https://reponame/blob/master/LICENSE).

Enjoy :metal:
