#!/bin/bash

if [ -z "${GITHUB_TOKEN}" ]; then
  if [ -f .env ]; then
    echo "GITHUB_TOKEN not set. Loading environment variables from .env file..."
    set -a
    source .env
    set +a
  else
    echo "Error: GITHUB_TOKEN is not set and no .env file was found."
    exit 1
  fi
fi

echo "Starting branch protection script..."

echo $GITHUB_TOKEN | gh auth login --with-token

repos=$(gh repo list --json nameWithOwner --limit 1000 -q '.[].nameWithOwner')

if [ -z "$repos" ]; then
  echo "No repositories found or failed to list repositories. Check GITHUB_TOKEN permissions."
  exit 1
fi

echo "Found repositories to check. Starting loop..."

for repo in $repos; do
  for branch in main master; do
    echo "Checking repository '$repo' for branch: '$branch'..."
    if gh api repos/$repo/branches/$branch &>/dev/null; then
      echo "✅ Branch '$branch' found in '$repo'. Applying protection rules..."
      gh api -X PUT "repos/$repo/branches/$branch/protection" --input - <<EOF
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1
  },
  "restrictions": null
}
EOF
      
      if [ $? -eq 0 ]; then
        echo "   -> ✅ Successfully protected '$repo/$branch'."
      else
        echo "   -> ⚠️ Failed to protect '$repo/$branch'. See API message above."
      fi
    fi
  done
done

echo "Script finished."
