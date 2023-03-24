workspace "bbnavi" {
    !identifiers hierarchical

    model {

        user = person "bbnavi User" "Nutzer der eine Routingabfrage druchführen möchte" "User"
        # todo: OCPDB External Source
        # todo: nextbike gbfs external source
        # todo: donkey republic gbfs external source
        # todo: barshare moqo api external source
        # todo: flotte commonsbooking api external source
        # todo: stadtnavi tiles server
        # todo: stadtnavi photon
        # todo: gtfs-rt via hafas mgate (including VBB HAFAS external source)?
        # todo: gtfs-rt via vbb-dds (including VBB-DDS external source)?

        enterprise "bbnavi" {
            admin = person "bbnavi Admin" "Admin der die Datenbank pflegt" "Admin"
            data_provider = person "Datenlieferant" "Datenanbieter für Imports oder Echtzeitdate" "Data Provider"

            # todo: other digitransit-ui instances, including staging.bbnavi.de
            digitransit = softwareSystem "Digitransit" {
                url "https://bad-belzig.bbnavi.de"
            }

            # todo: GitHub Action (graph build) vs deployed service
            otp_group = group "OpenTripPlanner (OTP)" {
                otp = softwareSystem "OpenTripPlanner" {
                    url "https://api.bbnavi.de/"
                }
                otp_staging = softwareSystem "OpenTripPlanner Staging" {
                    url "https://staging.api.bbnavi.de/"
                }
            }

            # todo: temporary amarillo dev/staging feed (amarillo-dev.mfdz.de)?
            amarillo = softwareSystem "Amarillo" {
                service = container "Amarillo Service"
                filesystem = container "Amarillo Filesystem"
            }

            gtfs_flex_generator = softwareSystem "GTFS-Flex-Feed-Generator" {
                description "GitHub-Action, die einen GTFS-Flex-Feed generiert"
                url "https://github.com/bbnavi/gtfs-flex"
                # todo: add generate-gtfs-flex once it is used (https://github.com/bbnavi/gtfs-flex/issues/5)
            }
            # todo: publish-barshare-gbfs
            # todo: publish-flotte-gbfs

            open_data_portal = softwareSystem "OpenData-Portal" {
                description "minIO-Instanz, Lesezugriff über HTTP oder AWS-S3-kompatible API"
                url "https://opendata.bbnavi.de/"
                vbb_gtfs_flex_bucket = container "Bucket vbb-gtfs-flex" {
                    description "S3-Bucket für den GTFS-Flex-Feed"
                    url "https://opendata.bbnavi.de/vbb-gtfs-flex/index.html"
                }
            }

            datahub_group = group "Datahub" {
                datahub_server = softwareSystem "Datahub Server" "Sammelstelle externer Datenquellen die in Echtzeit dem Digitransit zur Verfügung gestellt werden" {
                    db = container "Datenbank" "Datenbank für die Echtzeitdaten" "Database"
                    tile_server = container "Tile Server" "Stellt die Kartenmaterialien für die Darstellung der Routen bereit" "Martin" {
                        url "https://tiles.bbnavi.de"
                    }
                    app = container "Datahub App" "Stellt die APIs bereit" "Datahub App" {
                        url "https://datahub.bbnavi.de"
                    }
                    cron_job = container "Datahub Cron Job" "Maintenance Tasks" "Datahub Cron Job"
                    delayed_job = container "Delayed Job" "Hintergrunddienste, Benachrichtignungsdienst" "Delayed Job"
                    redis = container "Redis" "Cache" "Redis"
                }
                datahub_cms = softwareSystem "Datahub CMS" "Content Management System für die Datenlieferanten und Admins" "Datahub CMS"{
                    url "https://cms.bbnavi.de"
                }
                tmb_importer = softwareSystem "TMB Importer" "Importiert täglich Daten der TMB" "TMB Importer" {
                    app = container "TMB App" "Stellt die APIs bereit" "TMB App"
                    database = container "Datenbank" "Datenbank für die TMB Daten" "Database"
                    cron_job = container "Cron Job" "Startet tägliche Imports" "Cron Job"
                    delayed_job = container "Delayed Job" "Importiert die TMB Daten" "Delayed Job"
                }
                json2graphql = softwareSystem "JSON2GraphQL" "Konvertiert JSON Daten in GraphQL" "JSON2GraphQL"
            }
            wordpress_mitfahren = softwareSystem "Wordpress MitfahrenBB" "Wordpress für die Mitfahrgelegenheiten" "Wordpress Mitfahren"{
                url "https://info.mitfahrenbb.de"
            }
            wordpress_bbnavi = softwareSystem "Wordpress bbnavi" "Wordpress für die bbnavi Seite" "Wordpress bbnavi"{
                url "https://bbnavi.de"
            }
            odbcp_proxy = softwareSystem "OCPDB Proxy" "Proxy für die OCPDB API" "ODBCP Proxy" {
                url "https://ocpdb.bbnavi.de"
            }
        }

        # Monitoring Services
        monitoring = softwareSystem "Monitoring und Logs" "Sammelstelle für Logs und Monitoring" "Monitor" {
            pn_group = group "Planetary Networks"{
                prometheus = container "Prometheus" "PN Monitoring System"{
                    url "http://prometheus.planetary-networks.de"
                }
                loki = container "Loki" "PN Logging System"
            }
            grafana = container "Grafana" "Monitoring" "Grafana" {
                url "https://logs.tpwd.de"
            }
            metrics_collector = container "Metrics Collector" "Sammelt Metriken" "Metrics Collector"
            matomo = container "Matomo" "Analytics" "Matomo" {
                url "https://nutzung.bbnavi.de"
            }
            uptime_robot = container "Uptime Robot" "Monitoring" "Uptime Robot" {
                url "https://stats.uptimerobot.com/rvnpZhrzLk"
                datahub_vector_tile = component "Datahub: vector tiles" "https://tiles.bbnavi.de/public.poi_coords_e_bike_rentals/18/141267/85371.pbf" "HTTPS"{
                    url "https://tiles.bbnavi.de/public.poi_coords_e_bike_rentals/18/141267/85371.pbf"
                }
                datahub_web_ui = component "Datahub: Web UI" "https://datahub.bbnavi.de/" "HTTPS"{
                    url "https://datahub.bbnavi.de/"
                }
                otp_prod = component "OTP Prod" "https://api.bbnavi.de/otp/actuators/health" "HTTPS"{
                    url "https://api.bbnavi.de/otp/actuators/health"
                }
                otp_prod_key = component "OTP Prod Keyword" "https://api.bbnavi.de/otp/actuators/health" "Keyword UP"{
                    url "https://api.bbnavi.de/otp/actuators/health"
                }
                otp_staging = component "OTP Staging" "https://staging.api.bbnavi.de/otp/actuators/health" "HTTPS"{
                    url "https://staging.api.bbnavi.de/otp/actuators/health"
                }
                otp_staging_key = component "OTP Staging Keyword" "https://staging.api.bbnavi.de/otp/actuators/health" "Keyword UP"{
                    url "https://staging.api.bbnavi.de/otp/actuators/health"
                }
            }
            alerts = container  "Alerts" "Notifications"{
                slack = component "Slack"
                email = component "Email"
            }
        }

        vbb = group "Verkehrsverbund Berlin-Brandenburg (VBB)" {
            vbb_gtfs = softwareSystem "VBB-GTFS-Feed" {
                url "https://www.vbb.de/vbb-services/api-open-data/datensaetze/"
            }
        }

        # Relations

        # OTP
        otp -> vbb_gtfs "importiert"
        otp_staging -> vbb_gtfs "importiert"

        # Amarillo
        amarillo.service -> amarillo.filesystem "Lädt daten von"

        # Datahub
        otp -> amarillo.service "Lädt Daten von"

        # GTFS-Flex-Feed
        gtfs_flex_generator -> vbb_gtfs "lädt und verarbeit"
        gtfs_flex_generator -> open_data_portal.vbb_gtfs_flex_bucket "veröffentlicht Daten auf"
        # todo: this doesn't happen yet on production
        # otp -> open_data_portal.vbb_gtfs_flex_bucket "lädt Daten von"
        otp_staging -> open_data_portal.vbb_gtfs_flex_bucket "lädt Daten von"

        # Digitransit Relations
        digitransit -> otp "Sammelt Daten von"
        digitransit -> odbcp_proxy "Sammelt Daten von"
        digitransit -> datahub_server.tile_server "Sammelt Daten von"
        digitransit -> datahub_server.app "Sammelt Daten per GraphQl von"
        digitransit -> minio "??? Sammelt Daten von"
        digitransit -> monitoring.matomo "Sendet Daten zu"

        # datahub internal relations
        datahub_server.app -> datahub_server.db "Schreibt Daten in"
        json2graphql -> datahub_server.app "Wandelt JSON-Daten in GraphQl um"
        datahub_cms -> datahub_server.app "Sendet Daten per GraphQl an"
        datahub_server.cron_job -> datahub_server.app "Startet Tasks für Wartungsarbeiten"
        datahub_server.app -> datahub_server.delayed_job "Startet Hintergrunddienste"
        datahub_server.app -> datahub_server.redis "Schreibt Daten in"
        datahub_server.tile_server -> datahub_server.db "Sammelt Daten von"

        # tmb_importer internal relations
        tmb_importer.cron_job -> tmb_importer.delayed_job "Startet"
        tmb_importer.delayed_job -> data_provider "Importiert Daten von"
        tmb_importer.delayed_job -> tmb_importer.database "Sendet Daten an"
        tmb_importer.delayed_job -> json2graphql "Sendet JSON-Daten an den Datahub"
        tmb_importer.app -> tmb_importer.database "Liest Daten von"
        tmb_importer.app -> tmb_importer.delayed_job "Startet manuelle Imports"

        # User Relations
        user -> digitransit "Nutzt"
        user -> wordpress_mitfahren "Nutzt"
        user -> wordpress_bbnavi "Nutzt"
        user -> open_data_portal "Nutzt direkt Daten von"
        admin -> tmb_importer.app "Kontrolliert Datenbestand von"
        admin -> datahub_cms "Kontrolliert Datenbestand"
        admin -> datahub_server.app "Verwaltet Datenlieferanten"
        data_provider -> datahub_cms "Trägt daten von Hand ein"
        data_provider -> tmb_importer "Stellt Daten über eine Pull-API zur Verfügung"
        data_provider -> json2graphql "Sendet JSON-Daten an den Datahub"

        # Monitoring Relations
        monitoring.prometheus -> monitoring.metrics_collector "Sammelt Daten von"
        monitoring.grafana -> monitoring.prometheus  "Sammelt Daten von"
        monitoring.grafana -> monitoring.loki  "Sammelt Daten von"
        monitoring.grafana -> monitoring.alerts.slack "Sendet Alerts zu"
        monitoring.grafana -> monitoring.alerts.email "Sendet Alerts zu"
        monitoring.metrics_collector -> otp "Sammelt Daten von"
        wordpress_bbnavi -> monitoring.loki "Schreibt Log-Daten zu"
        wordpress_mitfahren -> monitoring.loki "Schreibt Log-Daten zu"
        otp -> monitoring.loki "Schreibt Log-Daten zu"
        digitransit -> monitoring.loki "Schreibt Log-Daten zu"
        tmb_importer -> monitoring.loki "Schreibt Log-Daten zu"
        datahub_server -> monitoring.loki "Schreibt Log-Daten zu"
        datahub_cms -> monitoring.loki "Schreibt Log-Daten zu"
        monitoring.uptime_robot -> monitoring.alerts.slack "Sendet Alerts zu"
        monitoring.uptime_robot -> monitoring.alerts.email "Sendet Alerts zu"
        monitoring.uptime_robot.datahub_vector_tile -> datahub_server.tile_server "Überwacht"
        monitoring.uptime_robot.datahub_web_ui -> datahub_server.app "Überwacht"
        monitoring.uptime_robot.otp_prod -> otp "Überwacht"
        monitoring.uptime_robot.otp_prod_key -> otp "Überwacht"
        monitoring.uptime_robot.otp_staging -> otp_staging "Überwacht"
        monitoring.uptime_robot.otp_staging_key -> otp_staging "Überwacht"


    }

    views {
        systemlandscape "Systemlandschaft" {
            include *
            exclude monitoring monitoring.loki monitoring.prometheus
            autolayout
        }

        systemlandscape "Monitoring-Logs" {
            include *
            exclude user admin data_provider
            autolayout
        }

        systemcontext datahub_server "Datahub-System" {
            include *
            autoLayout
        }

        systemcontext amarillo "Amarillo" {
            include *
            autoLayout
        }

        container gtfs_flex_generator {
            include *
            autoLayout
        }

        container amarillo "Amarillo-System" {
            include *
            autoLayout
        }

        container datahub_server "Datahub" {
            include *
            autoLayout
        }

        container tmb_importer "TMB-Importer" {
            include *
            autoLayout
        }

        # Monitoring Views
        systemcontext monitoring "Monitoring-System" {
            include *
            autolayout
        }

        container monitoring "Monitoring" {
            include *
            autoLayout
        }

        component monitoring.uptime_robot "UptimeRobot" {
            include *
            autoLayout
        }

        styles {
            element "Group" {
                color #000000
            }
        }

        theme default
    }

}
