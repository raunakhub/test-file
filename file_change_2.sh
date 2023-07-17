#!/bin/bash

# GitHub repository details
REPO_OWNER="raunakhub"
REPO_NAME="file-change-test"

# Personal access token with repository scope
TOKEN="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"

# API endpoint
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/commits?per_page=1"

# Function to check for file modifications
check_file_modifications() {
    local commit_sha=$1

    # Get the commit details using the GitHub API
    local commit_details=$(curl -s -H "Authorization: token $TOKEN" "$API_URL/$commit_sha")

    # Extract the modified files from the commit details
    local modified_files

    if [[ $(echo "$commit_details" | jq '.[0].files') == "null" ]]; then
        modified_files=$(echo "$commit_details" | jq -r '.[].commit.modified[]')
    else
        modified_files=$(echo "$commit_details" | jq -r '.[].files[].filename')
    fi

    # Print the modified files
    for file in $modified_files; do
        echo "Modified file: $file"
    done
}

# Initial commit SHA
initial_commit_sha=""

# Continuously monitor for file modifications
while true; do
    # Get the latest commit SHA using the GitHub API
    latest_commit_sha=$(curl -s -H "Authorization: token $TOKEN" "$API_URL" | jq -r '.[].sha')

    if [[ -z $initial_commit_sha ]]; then
        # Set the initial commit SHA
        initial_commit_sha=$latest_commit_sha
    elif [[ $initial_commit_sha != $latest_commit_sha ]]; then
        # Call the function to check for file modifications
        check_file_modifications "$latest_commit_sha"

        # Update the initial commit SHA
        initial_commit_sha=$latest_commit_sha
    fi

    sleep 60  # Adjust the sleep duration as per your needs
done
