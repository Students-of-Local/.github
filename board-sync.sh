#!/bin/sh
set -eu
org=Students-of-Local
number=${1:?usage: board-sync.sh PROJECT_NUMBER}
for kind in issues prs; do
  urls=$(gh search "$kind" --owner "$org" --state open --limit 1000 --json url,repository \
    --jq '.[] | select(.repository.name != "tychicus") | .url')
  for url in $urls; do gh project item-add "$number" --owner "$org" --url "$url" >/dev/null; done
done
