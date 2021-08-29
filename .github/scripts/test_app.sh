#!/bin/bash

# code from https://engineering.talkdesk.com/test-and-deploy-an-ios-app-with-github-actions-44de9a7dcef6

set -eo pipefail

xcodebuild -project "SkatScoreboard.xcodeproj" \
            -scheme "SkatScoreboard" \
            -destination platform=iOS\ Simulator,OS=14.5,name=iPhone\ 12 \
            clean test | xcpretty
