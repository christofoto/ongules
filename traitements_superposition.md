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

- [Pré-requis](#pré-requis)
- [Organisation des dossiers](#organisation-des-dossiers)
- [Préparation du raster de réference](#préparation-du-raster-de-réference)
- [Et c'est parti pour les traitements](#et-c-'-est-parti-pour-les-traitements)
- [Creators](#creators)
- [Thanks](#thanks)
- [Copyright and license](#copyright-and-license)

### Pré-requis

Avoir les logiciels suivants installés sur son ordinateur :

- [QGIS 3.22](https://www.qgis.org/fr/site/forusers/download.html) ou la dernière version LTR au moment de la lecture de ce tutoriel
- <b>OSGeo4W Shell</b> : c'est le terminal qui est disponible quand on installe QGIS aussi depuis un exécutable que depuis l'installateur OSGeo4W. Cela permettra d'utiliser la librairie GDAL pour effectuer des traitements directement en ligne de commande sans avoir à passer par QGIS
- Un éditeur de texte avancé de type [Visual Studio Code](https://code.visualstudio.com/) ou [Notepad++](https://notepad-plus-plus.org/) est un plus pour travailler sur son code

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Organisation des dossiers

Some text

```text
data/
  │── rasters/
  │   ├── grid_france_100.tif
  │   └── raster_espece_burn_1/
  │       └── *.tif*
  └── especes/
          └── *.shp
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Préparation du raster de réference

Have a bug or a feature request? Please first read the [issue guidelines](https://reponame/blob/master/CONTRIBUTING.md) and search for existing and closed issues. If your problem or idea is not addressed yet, [please open a new issue](https://reponame/issues/new).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Et c'est parti pour les traitements

```console
cd D:\SIG\data\admin\geofla\FRANCE
gdal_rasterize -burn 0 -ot Int16 -ts 10000 10000 -a_nodata -32768 france.shp grid_france_10000.tif
```

```console
set folder_raster=D:\SIG\data\admin\geofla\FRANCE
set folder_raster_burn=D:\SIG\travail\test\ongules_superposition\data\rasters_test\raster_espece_burn_1
set folder_vector=D:\SIG\travail\test\ongules_superposition\data\especes
```

```console
D:
cd %folder_vector%
copy %folder_raster%\grid_france_10000.tif %folder_raster%\grid_france_10000_final.tif
```

```console
for %F in (*.shp) do copy %folder_raster%\grid_france_10000.tif %folder_raster_burn%\grid_france_10000_%F.tif
```

```console
for %F in (*.shp) do gdal_rasterize -burn 1 "%F" %folder_raster_burn%\grid_france_10000_%F.tif
```

```console
cd %folder_raster_burn%
for %F in (*.tif) do gdal_calc -A  %folder_raster%\grid_france_10000_final.tif -B "%F" --outfile=%folder_raster%\grid_france_10000_final.tif --calc="(A+B)"
```

```console
cd %folder_raster_burn%
del *.tif
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Creators

**Creator 1**

- <https://github.com/usernamecreator1>

### Thanks

Some Text

### Copyright and license

Code and documentation copyright 2011-2018 the authors. Code released under the [MIT License](https://reponame/blob/master/LICENSE).

Enjoy :metal:
