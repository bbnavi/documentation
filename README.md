### local development
Navigate to `/lite` and run `docker compose up` <br />
To view the resulting diagram, visit http://localhost:8080 in a browser window

# Push documentation to online server structurizr.bbnavi.de

```
structurizr-cli push  -w data/deployments/standard_deployment.dsl -id 1 -key KEY -secret SECRET -url https://structurizr.bbnavi.de/api
structurizr-cli push  -w data/bbnavi.dsl -id 3 -key KEY -secret SECRET -url https://structurizr.bbnavi.de/api
```


<img src="./images/bb-navi-app-rund-rot_png.png" class="center"></img>

_______

[About this project](#about-this-projectabout-this-project) | [Who we are](#who-we-arewho-we-are) | [Working language](#working-languageworking-language) | [Our  documentation](#our-documentation) | [Repositories](#repositories) | [Licensing](#licensing)

_______

# bbnavi: Documentation

NOTE: This README is also available in German. Thank you for understanding that the German version might not always be up-to-date with the English one.

HINWEIS: Diese README ist ebenfalls auf Deutsch verfügbar. Bitte haben Sie Verständnis, dass die deutsche Version nicht immer auf dem gleichen Stand wie die englische Version ist.

## About this project
_____________________


## Who we are
_____________


## Working language
___________________


## Our Documentation
____________________

This repository contains the developer documentation and related content.
### Project scope 

## Repositories
_______________

| Repository | Description |
| ---------- | ----------- | 
| [amarillo](https://github.com/bbnavi/amarillo) | CRUD for carpool offers, description missing, https://amarillo.bbnavi.de/ | 
| [bbnavi-datahub](https://github.com/bbnavi/bbnavi-datahub) | Desription missing, readme with just one line, looking into docu from the fork |
| [bbnavi-datahub-cms](https://github.com/bbnavi/bbnavi-datahub-cms) | An CMS based on JSON schema of smart-village api , description incomplete, readme incomplete, look into fork |
| [bbnavi-datahub-json2graphql](https://github.com/bbnavi/bbnavi-datahub-json2graphql) | Handles defined JSON inputs and translates data to GraphQL endpoint on main-app-server, no Readme, look into fork |
| [bbnavi-datahub-tmb-importer](https://github.com/bbnavi/bbnavi-datahub-tmb-importer) | Converts XML Data from TMB (Tourismus Marketing Brandenburg) to JSON Data and sends them to a JSON API, Readme missing |
| [cms](https://github.com/bbnavi/cms) | setup in reademe, no description, look into fork |
| [commonsbooking2gbfs](https://github.com/bbnavi/commonsbooking2gbfs) | small python script, which generates a GBFS feed from CommonsBookings's fLotte map plugin API |
| [digitransit-ui](https://github.com/bbnavi/digitransit-ui) | Digitransit UI clone for cities in Brandenburg ("bbnavi.de") |
| [documentation](https://github.com/bbnavi/documentation) | Project overview and general documentation |
| [gtfs-flex](https://github.com/bbnavi/gtfs-flex) | Generate a GTFS-Flex v2 feed for bbnavi |
| [gtfs-rt-feed](https://github.com/bbnavi/gtfs-rt-feed) | Generates a GTFS Realtime feed by polling the VBB HAFAS API. (fork of derhuerst/berlin-gtfs-rt-server) |
| [moqo2gbfs](https://github.com/bbnavi/moqo2gbfs) | Small python script, which generates a GBFS feed from MOQO's API |
| [opendata-portal-tools](https://github.com/bbnavi/opendata-portal-tools) | Tools for managing the opendata.bbnavi.de MinIO instance |
| [opentripplaner-berlin-brandenburg](https://github.com/bbnavi/opentripplaner-berlin-brandenburg) | no desription, Readme with just log| 
| [planetary-quantum](https://github.com/bbnavi/planetary-quantum)| Deploy complete Stack to Planetary Quantum, more description wanted, readme incomplete |
