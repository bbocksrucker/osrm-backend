FROM osrm/osrm-backend:latest

# Install curl (falls im Base-Image nicht enthalten)
RUN apt-get update && apt-get install -y curl

# Routingdaten vorbereiten
RUN mkdir -p /data && \
    curl -L -o /data/map.osm.pbf "http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf" && \
    osrm-extract -p /opt/car.lua /data/map.osm.pbf && \
    osrm-partition /data/map.osrm && \
    osrm-customize /data/map.osrm

EXPOSE 5000

CMD ["osrm-routed", "--algorithm", "MLD", "/data/map.osrm"]

