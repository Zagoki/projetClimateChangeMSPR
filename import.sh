#!/bin/bash
set -e

curl -s -I localhost:8086/ping?wait_for_leader=30s

BUCKETS=$(influx bucket list --org epsi --token vha9E75YLyTw0OuBi7h5M2QKlRow70ux)
BUCKET_ID=$(echo "$BUCKETS" | awk '$2 == "climate-change" {print $1}')
influx bucket update --id "$BUCKET_ID" --token vha9E75YLyTw0OuBi7h5M2QKlRow70ux --retention 0 --shard-group-duration 52w
echo ""

echo "Importing annual-surface-temperature-change.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Accept: application/json" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Cache-Control: no-cache" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --data-binary @/data/annual-surface-temperature-change.line

echo "Importing atmospheric-co2-concentration.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Accept: application/json" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Cache-Control: no-cache" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --data-binary @/data/atmospheric-co2-concentration.line

echo "Importing climate-disasters-frequency.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --header "Accept: application/json" \
    --data-binary @/data/climate-disasters-frequency.line

echo "Importing forest-and-carbon.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --header "Accept: application/json" \
    --data-binary @/data/forest-and-carbon.line

echo "Importing ghg-emissions.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --header "Accept: application/json" \
    --data-binary @/data/ghg-emissions.line

echo "Importing land-cover-accounts.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --header "Accept: application/json" \
    --data-binary @/data/land-cover-accounts.line

echo "Importing mean-sea-levels-change.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --header "Accept: application/json" \
    --data-binary @/data/mean-sea-levels-change.line

echo "Importing population.line"
curl -s --request POST "http://localhost:8086/api/v2/write?org=epsi&bucket=climate-change&precision=s" \
    --header "Authorization: Token vha9E75YLyTw0OuBi7h5M2QKlRow70ux" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --header "Accept: application/json" \
    --data-binary @/data/population.line

exit 0