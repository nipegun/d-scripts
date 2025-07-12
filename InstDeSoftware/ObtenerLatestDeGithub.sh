#!/bin/bash

curl -s https://api.github.com/repos/Nombre/Repo/releases/latest | jq -r '.tag_name'
