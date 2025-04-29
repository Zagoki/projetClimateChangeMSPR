# TP InfluxDB: Tableau de bord sur le changement climatique

Dans cet exercice, vous avez été fourni avec un tableau de bord pré-configuré présentant divers indicateurs liés au changement climatique. Les données consistent de diverses mesures décrites ci-après sur différentes périodes de temps. L'analyse de ces données nous permettrait d'identifier l'existence et l'ampleur de tendances et de mieux planifier notre stratégie contre le changement climatique. Votre mission consiste à concevoir les requêtes nécessaires pour que le tableau de bord affiche correctement les données

## Prérequis

Système
- Environ 0.8 Go d'espace libre pour les éléments du TP
- Environ 2.8 Go d'espace libre pour les outils utilisés (pas nécessaire si vous les avez déjà installés)

Outils
- [Docker](https://docs.docker.com/engine/install/) pour installer et faire tourner InfluxDB et Grafana
- Un navigateur web quelconque

## Données

Les données consistent de 8 fichiers présents dans le répertoire `dataset/line-protocol`. Chaque fichier mesure un thème particulier mais peut contenir plusieurs indicateurs relatifs à ce thème. Vous pouvez également explorer les fichiers CSV originaux en extrayant l'archive zip `dataset/original-data.zip`. Voici une description de chaque fichier :

- `annual-surface-temperature-change.line` - Source [imf.org](https://climatedata.imf.org/pages/climatechange-data)
    - **Description** : Evolution de la température moyenne par pays par rapport à une référence de base mesurée entre 1951 et 1980
    - **Période et Résolution** : 1961-01 - 2022-01 (par année)
    - **Indicateurs et unités** : Changement de température (en °C)

- `atmospheric-co2-concentration.line` - Source [imf.org](https://climatedata.imf.org/pages/climatechange-data)
    - **Description** : Evolution de la concentration moyenne de CO2 dans l'atmosphère mondiale
    - **Période et Résolution** : 1958-03 - 2023-05 (par mois)
    - **Indicateurs et unités** : Concentration atmosphérique de CO2 (en ppm)

- `climate-disasters-frequency.line` - Source [imf.org](https://climatedata.imf.org/pages/climatechange-data)
    - **Description** : Evolution de la fréquence des catastrophes naturelles par pays
    - **Période et Résolution** : 1980-01 - 2022-01 (par année)
    - **Indicateurs et unités** : Sécheresse (nombre de), Température Extrême (nombre de), Inondation (nombre de), Glissement de Terrain (nombre de), Tempête (nombre de), Incendie de Végétation (nombre de)

- `forest-and-carbon.line` - Source [imf.org](https://climatedata.imf.org/pages/climatechange-data)
    - **Description** : Evolution des indices relatifs à l'étendue des forêts et au carbone stocké dans les forêts
    - **Période et Résolution** : 1992-01 - 2020-01 (par année)
    - **Indicateurs et unités** : Superficie Forestière (en 1000 ha), Superficie Terrestre (en 1000 ha), Part de la Superficie Forestière (en %), Stocks de Carbone dans les Forêts (en millions de tonnes), Indice des Stocks de Carbone dans les Forêts (indice), Indice de l'Etendue Forestière (indice)

- `ghg-emissions.line` - Source [ourworldindata.org](https://github.com/owid/co2-data)
    - **Description** : Evolution de la quantité de GES (Gaz à Effet de Serre) émise par pays en tonnes d'équivalent CO2
    - **Période et Résolution** : 1990-01 - 2020-01 (par année)
    - **Indicateurs et unités** : Quantité de GES émise (en millionns de tonnes)

- `land-cover-accounts.line` - Source [imf.org](https://climatedata.imf.org/pages/climatechange-data)
    - **Description** : Evolution de la décomposition de l'occupation du terrestre par pays
    - **Période et Résolution** : 1992-01 - 2020-01 (par année)
    - **Indicateurs et unités** : Superficie terrestre décomposée par type et par influence climatique (en 1000 ha)

- `mean-sea-levels-change.line` - Source [imf.org](https://climatedata.imf.org/pages/climatechange-data)
    - **Description** : Évolution du niveau moyen des mers et oceans par rapport au niveau mesuré par TOPEX/Poseidon
    - **Période et Résolution** : 1992-12 - 2022-11 (par mois)
    - **Indicateurs et unités** : Changement du niveau maritime (en mm)

- `population.line` - Source [ourworldindata.org](https://github.com/owid/co2-data)
    - **Description** : Évolution de la population par pays
    - **Période et Résolution** : 1990-01 - 2020-01 (par année)
    - **Indicateurs et unités** : Population totale (nombre d'habitants)

## Installation et mise en place du TP

Commencez par l'installation de Docker, puis ouvrez une invite de commande dans le répertoire de ce projet et exécutez les commandes suivantes

```
docker compose pull     # Télécharge les images Docker pour InfluxDB et Grafana
docker compose up -d    # Lance InfluxDB et Grafana
```

Attendez 1 à 2 minutes pour que les services chargent correctement, puis naviguez vers l'adresse http://localhost:8086 pour ouvrir l'interface web d'InfluxDB. Si vous avez accès cette page, vous devez ensuite importer les données en effectuant les commandes suivantes

```
docker exec influxdb chmod +x /home/influxdb/import.sh
docker exec influxdb /home/influxdb/import.sh
```

Si vous obtenez une réponse qui ressemble à celle-ci, l'importation est réussite. En cas d'erreur, assurez-vous d'avoir bien suivi les étapes précédentes. Une possible source d'erreur est le type de fin de ligne dans les fichiers contenant les données. Assurez-vous que pour les fichiers du répertoire `dataset/line-protocol` le retour à la ligne soit `LF` et non pas `CRLF`. Si vous voulez recommencer, intéressez-vous à la partie **Nettoyage en fin de TP** de ce document.

```
HTTP/1.1 204 No Content
Vary: Accept-Encoding
X-Influxdb-Build: OSS
X-Influxdb-Version: v2.7.4
Date: Sun, 01 Jan 2023 00:00:00 GMT

ID                      Name            Retention       Shard group duration    Organization ID         Schema Type
cb7a6a5b9202c922        climate-change  infinite        8736h0m0s               eee944a78a9da9e8        implicit

Importing annual-surface-temperature-change.line
Importing atmospheric-co2-concentration.line
Importing climate-disasters-frequency.line
Importing forest-and-carbon.line
Importing ghg-emissions.line
Importing land-cover-accounts.line
Importing mean-sea-levels-change.line
Importing population.line
```

Enfin, vous pouvez retrouver le dashboard Grafana que vous devez modifier en navigant vers l'adresse http://localhost:3000/d/a5519692-8a12-4418-bce8-9798a0d57d7c/changement-climatique

## Votre mission

Votre mission consiste à concevoir les 10 requêtes en langage Flux nécessaires pour que le [Dashboard Grafana](http://localhost:3000/d/a5519692-8a12-4418-bce8-9798a0d57d7c/changement-climatique) affiche correctement les tableaux et les graphiques. Vous ne devez pas modifier les paramètres des panneaux. Pour chaque requête, le bucket InfluxDB et l'intervalle temporaire correct ont été fournis. À vous d'identifier la mesure adéquate selon la partie **Données** de ce document. Abordez les panneaux dans l'ordre indiqué afin de suivre une difficulté croissante

Afin de modifier un panneau, cliquez en haut à droite du panneau et puis sur "Édit". Ensuite, vous trouverez l'éditeur de texte permettant de saisir votre requête en bas à gauche de la fenêtre. Pour commencer, la requête du panneau est désactivée, cliquez sur l'icône de l'oeil "Disable query" en haut à droite de la zone de texte pour l'activer, puis saisissez votre requête. Une fois votre requête finie, appuyez sur le bouton "Save" puis "Apply" en haut à droite de l'écran pour enregistrer vos changements

**Attention**, si vous supprimez le conteneur Docker, les changements que vous apportez au tableau de bord seront perdus, notez et enregistrez vos requêtes sur un document annexe ou effectuez une sauvegarde du tableau de bord ainsi :

1. Appuyez sur l'icône sous forme d'une disquette "Save dashboard" en haut à droite de la page
2. Appuyez sur le boutton "Save"
3. Appuyez sur l'icône sous forme d'une roue dentée "Dashboard settings" à  cote de l'icône "Save dashboard"
4. Choisissez la catégorie "JSON Model"
5. Copiez **tout** le contenu de la zone de texte et remplacez le contenu du fichier `dashboards/climate-change.json` par le contenu copié (éventuellement, gardez une copie du fichier `dashboards/climate-change.json` original)

Le tableau de bord est reglé par défaut pour interroger les graphiques sur la période `1993-01-01 00:00:00 - 2023-01-01 00:00:00`. Si vous souhaitez modifier la période, vous pouvez le faire en cliquant sur l'icône de l'horologe en haut à droite de l'écran

N'hésitez pas à vous aider de et expérimenter en utilisant l'explorateur de donnees d'InfluxDB. Pour cela, connectez-vous à l'adresse http://localhost:8086 avec les identifiants `root` et `password`, puis à partir du menu à gauche, naviguez vers la page "Data Explorer". Ici vous trouverez le bucket `climate-change` ainsi que les différentes mesures. Afin de pouvoir sélectionner des indicateurs, vous devez d'abord indiquer une plage temporelle contenant des données. Pour cela, cliquez sur l'icône de l'horologe à droite de la page et sélectionnez "Custom Time Range" et entrez les valeurs `1955-01-01 00:00:00` et `2024-01-01 00:00:00`. Finalement, cliquez sur "Script Editor", et construisez vos requêtes. Pour certaines requêtes, vous allez avoir besoin de changer le type de la visualisation en haut à gauche de la page, notamment le "Table" est plus utile que le "Graph" à partir de la question 5

## Questions

Voici les questions correspondant à chaque panneau ainsi qu'éventuellement quelques instructions et indices

1. Récupérez l'évolution au fil du temps de la concentration atmosphérique mondiale de CO2

2. Récupérez l'évolution au fil du temps de la température de surface en France

3. Récupérez l'évolution au fil du temps du niveau maritime pour les océans Atlantique, Pacifique, Indien

4. Récupérez l'évolution au fil du temps des émissions de GES de la France. Retournez le resultat en `tonnes` et non pas en `millions de tonnes`

5. Récupérez la dernière mesure du décompte des catastrophes naturelles par type, en additionant la valeur pour chaque pays. Le résultat attendu consiste de 6 tableaux, un pour chaque type avec l'indicateur et sa valeur correspondante

6. Récupérez la dernière mesure de la part de surface forestière pour chaque pays. Le résultat attendu consiste d'un seul tableau contenant au moins la valeur de la mesure et le code iso de chaque pays

7. Calculez et récupérez la dernière mesure des émissions de GES par habitant pour chaque pays. Le résultat attendu consiste d'un seul tableau contenant au moins la valeur de la mesure et le code iso de chaque pays. Pour cette question, vous devez calculer le résultat de chaque pays en appliquant la formule `_value = ghg-emissions * 1000000 / population`.

8. Récupérez la dernière mesure de la répartition par indicateur des comptes de l'occupation du sol français. Retournez le résultat en `hectares` et non pas en `1000 hectares`

9. Groupez l'évolution de la température de surface en France par période de 5 ans et indiquez: le début et la fin de la période, l'année la plus chaude de la période, la température l'année respective. Affichez les résultats par ordre décroissant du temps

10. Groupez l'évolution des catastrophes naturelles en France par période de 5 ans et indiquez: le début et la fin de la période, le type de catastrophe la plus fréquente sur la période, le nombre d'incidences de ce type

## Ressources

Voici l'ensemble des fonctions Flux qui pourrait vous servir dans ce TP ainsi qu'un lien vers leur documentation

- range - [range(start: A, ?stop: B)](https://docs.influxdata.com/flux/v0/stdlib/universe/range/)
- filter - [filter(fn: (r: A) => bool, ?onEmpty: string)](https://docs.influxdata.com/flux/v0/stdlib/universe/filter/)
- map - [map(fn: (r: A) => B, ?mergeKey: bool)](https://docs.influxdata.com/flux/v0/stdlib/universe/map/)
- last - [last(?column: string)](https://docs.influxdata.com/flux/v0/stdlib/universe/last/)
- group - [group(?columns: [string], ?mode: string)](https://docs.influxdata.com/flux/v0/stdlib/universe/group/)
- pivot - [pivot(columnKey: [string], rowKey: [string], valueColumn: string)](https://docs.influxdata.com/flux/v0/stdlib/universe/pivot/)
- sort - [sort(?columns: [string], ?desc: bool)](https://docs.influxdata.com/flux/v0/stdlib/universe/sort/)
- sum - [sum(?column: string)](https://docs.influxdata.com/flux/v0/stdlib/universe/sum/)
- max - [max(?column: string)](https://docs.influxdata.com/flux/v0/stdlib/universe/max/)
- drop - [drop(?columns: [string], ?fn: (column: string) => bool)](https://docs.influxdata.com/flux/v0/stdlib/universe/drop/)
- keep - [keep(?columns: [string], ?fn: (column: string) => bool)](https://docs.influxdata.com/flux/v0/stdlib/universe/keep/)
- window - [window(?every: duration, ...)](https://docs.influxdata.com/flux/v0/stdlib/universe/window/)

## Nettoyage en fin de TP

Afin de supprimer toutes les données Docker liées à ce TP, exécutez les commandes suivantes

```
docker compose down                         # Arrête et supprime les conteneurs Docker pour InfluxDB et Grafana
docker compose down -v                      # Supprime le volume Docker contenant les données sur le changement climatique
docker image rm influxdb:2.7.4-alpine       # Supprime l'image Docker d'InfluxDB
docker image rm grafana/grafana:10.2.2      # Supprime l'image Docker de Grafana
```

## Notices & Droits d'Auteur

Ce TP utilise les datasets [Climate Change Data](https://climatedata.imf.org/pages/climatechange-data) fourni par l'[IMF](https://imf.org/) et [CO2 and Greenhouse Gas Emissions](https://ourworldindata.org/co2-and-greenhouse-gas-emissions) fourni par [Our World In Data](https://ourworldindata.org/) 

Le dataset [CO2 and Greenhouse Gas Emissions](https://ourworldindata.org/co2-and-greenhouse-gas-emissions) est téléchargeable sur [GitHub](https://github.com/owid/co2-data)

Exercises et support conçus par [Marius USVAT](https://www.linkedin.com/in/marius-usvat/) pour l'[EPSI](https://epsi.fr/), parcours DWWM en ligne

Copyright DWWM EPSI ONLINE



Mattheo