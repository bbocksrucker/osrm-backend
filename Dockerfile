FROM osrm/osrm-backend:latest

# Lade Routingdaten für Berlin (kannst du später ändern auf AT etc.)
RUN mkdir -p /data && \
    curl -L -o /data/map.osm.pbf "http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf" && \
    osrm-extract -p /opt/car.lua /data/map.osm.pbf && \
    osrm-contract /data/map.osrm

EXPOSE 5000

CMD ["osrm-routed", "--algorithm", "MLD", "/data/map.osrm"]
