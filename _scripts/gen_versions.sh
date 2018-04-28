#!/bin/bash

jekyll=$(cat deploy/versions.json | jq .jekyll)


cat > _data/versions.yml << EOL
jekyll: $jekyll
EOL

