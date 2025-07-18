#!/bin/bash

# Setup Agents for Feature - Create PM and ENG team for a specific feature
# Usage: setup-agents-for-feature.sh <FEATURE_CODE> <FEATURE_FILE>

if [ $# -lt 2 ]; then
    echo "Usage: $0 <FEATURE_CODE> <FEATURE_FILE>"
    echo "Example: $0 AUTH features/auth.md"
    echo "Note: Must be run from within a tmux session"
    exit 1
fi

FEATURE_CODE="$1"
FEATURE_FILE="$2"

# Validate feature code format (should be uppercase letters/numbers)
if [[ ! "$FEATURE_CODE" =~ ^[A-Z0-9]+$ ]]; then
    echo "Error: Feature code should be uppercase letters/numbers only (e.g., AUTH, DASH, REPO)"
    exit 1
fi

# Check if feature file exists
if [ ! -f "$FEATURE_FILE" ]; then
    echo "Error: Feature file '$FEATURE_FILE' not found"
    exit 1
fi

# Check if we're in a tmux session
if [ -z "$TMUX" ]; then
    echo "Error: Must be run from within a tmux session"
    exit 1
fi

# Extract metadata from feature file
FEATURE_NAME=$(grep "feature_name:" "$FEATURE_FILE" | cut -d'"' -f2)
FEATURE_PORT=$(grep "feature_port:" "$FEATURE_FILE" | cut -d' ' -f2)
FEATURE_BRANCH=$(grep "feature_branch:" "$FEATURE_FILE" | cut -d'"' -f2)

# Simple paths - feature_name = worktree directory name
WORKTREE_PATH=".worktrees/${FEATURE_NAME}"

echo "Setting up feature team for: $FEATURE_CODE"
echo "Feature file: $FEATURE_FILE"
echo "Worktree: $WORKTREE_PATH"
echo "Branch: $FEATURE_BRANCH"
echo "Port: $FEATURE_PORT"

# Store current directory to return to it later
ORIGINAL_DIR=$(pwd)

# Create .worktrees directory if it doesn't exist
mkdir -p .worktrees

# Create worktree if it doesn't exist
if [ -d "$WORKTREE_PATH" ]; then
    echo "Worktree already exists at: $WORKTREE_PATH"
else
    echo "Creating worktree at: $WORKTREE_PATH"
    git worktree add "$WORKTREE_PATH" -b "$FEATURE_BRANCH"
    echo "Worktree created successfully"
fi

# Navigate to worktree directory for both PM and Engineer windows
cd "$WORKTREE_PATH"

# Create PM window (in worktree directory)
echo "Creating Project Manager window: PM-$FEATURE_CODE"
tmux new-window -n "PM-$FEATURE_CODE"

# Start Claude in PM window
tmux send-keys -t "PM-$FEATURE_CODE" "claude --dangerously-skip-permissions" C-m

# Wait for Claude to start
sleep 2

# Send PM briefing
tmux send-keys -t "PM-$FEATURE_CODE" "/brief-project-manager $FEATURE_CODE $FEATURE_FILE"
sleep 0.5
tmux send-keys -t "PM-$FEATURE_CODE" Enter

echo "PM window created and briefed"

# Create ENG window (also in worktree directory)
echo "Creating Engineer window: ENG-$FEATURE_CODE"
tmux new-window -n "ENG-$FEATURE_CODE"

# Start Claude in ENG window
tmux send-keys -t "ENG-$FEATURE_CODE" "claude --dangerously-skip-permissions" C-m

# Wait for Claude to start
sleep 2

# Send ENG briefing
tmux send-keys -t "ENG-$FEATURE_CODE" "/brief-engineer $FEATURE_CODE $FEATURE_FILE"
sleep 0.5
tmux send-keys -t "ENG-$FEATURE_CODE" Enter

echo "ENG window created and briefed"

# Return to original directory
cd "$ORIGINAL_DIR"
echo ""
echo "Feature team setup complete for $FEATURE_CODE:"
echo "- PM-$FEATURE_CODE (Project Manager)"
echo "- ENG-$FEATURE_CODE (Engineer)"
echo "- Worktree: $WORKTREE_PATH"
echo "- Branch: $FEATURE_BRANCH"
echo "- Port: $FEATURE_PORT"
echo ""
echo "Both agents have been briefed with the feature file: $FEATURE_FILE"
echo "Use 'tmux list-windows' to see all windows in your session"