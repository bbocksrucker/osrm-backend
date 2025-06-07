FROM osrm/osrm-backend:latest

# Fix für archivierte Stretch-Repos + curl-Installation
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/security.debian.org/d' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y curl

# Routingdaten vorbereiten (z. B. Berlin)
RUN mkdir -p /data && \
    curl -L -o /data/map.osm.pbf "http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf" && \
    osrm-extract -p /opt/car.lua /data/map.osm.pbf && \
    osrm-partition /data/map.osrm && \
    osrm-customize /data/map.osrm

EXPOSE 5000

CMD ["osrm-routed", "--algorithm", "MLD", "/data/map.osrm"]
