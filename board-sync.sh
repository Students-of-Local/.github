#!/bin/sh
set -eu
org=Students-of-Local
board=orgs/$org/projectsV2/${1:?usage: board-sync.sh PROJECT_NUMBER}
fields=$(gh api "$board/fields")
status=$(echo "$fields" | jq -r '.[] | select(.name == "Status") | .id')
cards=$(gh api --paginate "$board/items?per_page=100&fields=$status" |
  jq -r '.[] | "\(.content.html_url) \(.id) \([.fields[] | select(.name == "Status") | .value // empty] | length)"')
place() {
  option=$(echo "$fields" | jq -r --arg name "$3" '.[] | select(.name == "Status") | .options[] | select(.name.raw == $name) | .id')
  found=$(gh api --paginate "search/issues?q=org:$org+is:public+archived:false+is:open+is:$1&per_page=100" |
    jq -r '.items[] | "\(.html_url) \(.repository_url | split("/") | last) \(.number)"')
  echo "$found" | while read -r url repo number; do
    [ -n "$url" ] || continue
    card=$(echo "$cards" | awk -v url="$url" '$1 == url { print $2 }')
    if echo "$cards" | grep -qx "$url [0-9]* 1"; then continue; fi
    if [ -z "$card" ]; then
      card=$(gh api -X POST "$board/items" -f type="$2" -f owner="$org" -f repo="$repo" -F number="$number" | jq -r .id)
    fi
    echo "{\"fields\":[{\"id\":$status,\"value\":\"$option\"}]}" | gh api -X PATCH "$board/items/$card" --input - >/dev/null
    echo "$3 $url"
  done
}
place issue Issue Inbox
place pr PullRequest Review
