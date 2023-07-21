#!/bin/bash

# Set your GitHub username and repository name
username="raunakhub"
repository="test-file"

# Retrieve the latest commit details using the GitHub API
commit=$(curl -s "https://api.github.com/repos/$username/$repository/commits" | grep -m 1 '"sha"' | cut -d '"' -f 4)
files=$(curl -s "https://api.github.com/repos/$username/$repository/commits/$commit" | grep -e '"filename":' | cut -d '"' -f 4)

# Loop through the modified files and display their names
echo "Modified files:"
echo "$files"
