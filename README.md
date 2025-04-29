
# TP InfluxDB – Dashboard Changement Climatique  
_Mattheo Coppin_

## 🎯 Objectif  
Créer 10 requêtes Flux pour alimenter un tableau de bord Grafana lié aux données climatiques.  
⚠️ Les données sont fournies. Tu dois uniquement écrire les requêtes, sans modifier les panneaux.

---

## 🧰 Prérequis  
- Docker installé  
- ~4 Go d’espace disque  
- Un navigateur

---

## 🚀 Démarrage  

Dans le terminal à la racine du projet :

```bash
docker compose pull
docker compose up -d
```

Accède à InfluxDB : [http://localhost:8086](http://localhost:8086)

Importe les données :

```bash
docker exec influxdb chmod +x /home/influxdb/import.sh
docker exec influxdb /home/influxdb/import.sh
```

Vérifie qu’il n’y a pas d’erreur.

Dashboard Grafana :  
[http://localhost:3000/d/a5519692-8a12-4418-bce8-9798a0d57d7c/changement-climatique](http://localhost:3000/d/a5519692-8a12-4418-bce8-9798a0d57d7c/changement-climatique)

---

## ✍️ Écriture des requêtes

- Clique sur un panneau → **Edit**
- Active la requête (œil barré)
- Écris ta requête dans l’éditeur
- Clique sur **Apply** → **Save dashboard**

### 💾 Sauvegarder les modifications

- Menu du dashboard → **Save dashboard**
- Puis **Dashboard settings > JSON Model**
- Copie le contenu et remplace `dashboards/climate-change.json`

---

## 🔎 Explorer les données

- InfluxDB : `root` / `password`
- Page : **Data Explorer**
- Bucket : `climate-change`
- Plage de temps personnalisée : `1955-01-01 00:00:00` → `2024-01-01 00:00:00`
- Active le **Script Editor** pour écrire en Flux

---

## 🗃️ Données

Les fichiers de données sont dans `dataset/line-protocol` :

- `annual-surface-temperature-change.line` → Température
- `atmospheric-co2-concentration.line` → CO₂
- `climate-disasters-frequency.line` → Catastrophes
- `forest-and-carbon.line` → Forêts & carbone
- `ghg-emissions.line` → GES
- `land-cover-accounts.line` → Occupation des sols
- `mean-sea-levels-change.line` → Niveau des mers
- `population.line` → Population

---

## ❓ Questions à traiter

1. Évolution CO₂ mondial (1958–2023)
2. Température en France (1961–2022)
3. Niveau des mers par océan (Atlantique, Pacifique, Indien)
4. Émissions de GES en France (en tonnes)
5. Dernier total mondial de catastrophes par type
6. Dernière part de surface forestière (% par pays)
7. Émissions de GES par habitant = GES * 1_000_000 / population
8. Dernière occupation des sols (en hectares) pour la France
9. Température France groupée par période de 5 ans (début/fin + année la plus chaude)
10. Catastrophes France groupées par période de 5 ans (début/fin + type le plus fréquent)

---

## 🧠 Fonctions Flux utiles

- `range`, `filter`, `map`, `group`, `pivot`, `last`, `sum`, `window`, `max`, `drop`, `keep`, `sort`

---

## 🧹 Nettoyage

```bash
docker compose down
docker compose down -v
docker image rm influxdb:2.7.4-alpine
docker image rm grafana/grafana:10.2.2
```

---

## 📚 Sources

- [IMF Climate Data](https://climatedata.imf.org/)
- [Our World In Data – CO₂](https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions)
- TP original par **Marius USVAT – EPSI ONLINE**
- Adaptation par **Mattheo Coppin**
