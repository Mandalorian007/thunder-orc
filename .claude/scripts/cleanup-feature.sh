#!/bin/bash

# Cleanup Feature - Remove tmux windows and worktree assets for a feature
# Usage: cleanup-feature.sh <FEATURE_CODE> [<FEATURE_FILE>]

if [ $# -lt 1 ]; then
    echo "Usage: $0 <FEATURE_CODE> [<FEATURE_FILE>]"
    echo "Examples:"
    echo "  $0 AUTH features/auth.md    # Cleanup using feature file"
    echo "  $0 AUTH                     # Cleanup without feature file (uses naming convention)"
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

# Check if we're in a tmux session
if [ -z "$TMUX" ]; then
    echo "Error: Must be run from within a tmux session"
    exit 1
fi

echo "Cleaning up feature: $FEATURE_CODE"

# Determine worktree path
if [ -n "$FEATURE_FILE" ] && [ -f "$FEATURE_FILE" ]; then
    # Extract feature name from feature file
    FEATURE_NAME=$(grep "feature_name:" "$FEATURE_FILE" | cut -d'"' -f2)
    FEATURE_BRANCH=$(grep "feature_branch:" "$FEATURE_FILE" | cut -d'"' -f2)
    WORKTREE_PATH=".worktrees/${FEATURE_NAME}"
    echo "Using feature file: $FEATURE_FILE"
    echo "Feature name: $FEATURE_NAME"
    echo "Feature branch: $FEATURE_BRANCH"
else
    # Use naming convention: feature-<lowercase-code>
    FEATURE_NAME=$(echo "$FEATURE_CODE" | tr '[:upper:]' '[:lower:]')
    FEATURE_NAME="feature-${FEATURE_NAME}"
    WORKTREE_PATH=".worktrees/${FEATURE_NAME}"
    echo "Using naming convention (no feature file provided)"
    echo "Assumed feature name: $FEATURE_NAME"
fi

echo "Worktree path: $WORKTREE_PATH"
echo ""

# Kill tmux windows
echo "=== Cleaning up tmux windows ==="

# Kill PM window
PM_WINDOW="PM-$FEATURE_CODE"
if tmux list-windows -F "#{window_name}" | grep -q "^$PM_WINDOW$"; then
    echo "Killing PM window: $PM_WINDOW"
    tmux kill-window -t "$PM_WINDOW"
else
    echo "PM window not found: $PM_WINDOW"
fi

# Kill ENG window
ENG_WINDOW="ENG-$FEATURE_CODE"
if tmux list-windows -F "#{window_name}" | grep -q "^$ENG_WINDOW$"; then
    echo "Killing ENG window: $ENG_WINDOW"
    tmux kill-window -t "$ENG_WINDOW"
else
    echo "ENG window not found: $ENG_WINDOW"
fi

# Kill any ENG-{FEATURE_CODE}-* windows (APP, LOGS, etc.)
ENG_PATTERN="ENG-$FEATURE_CODE-"
ENG_WINDOWS=$(tmux list-windows -F "#{window_name}" | grep "^$ENG_PATTERN")
if [ -n "$ENG_WINDOWS" ]; then
    echo "Killing additional ENG windows:"
    for window in $ENG_WINDOWS; do
        echo "  Killing: $window"
        tmux kill-window -t "$window"
    done
else
    echo "No additional ENG windows found"
fi

echo ""

# Remove worktree
echo "=== Cleaning up worktree ==="
if [ -d "$WORKTREE_PATH" ]; then
    echo "Removing worktree: $WORKTREE_PATH"
    
    # Remove worktree using git worktree remove
    if git worktree remove "$WORKTREE_PATH" 2>/dev/null; then
        echo "Worktree removed successfully"
    else
        echo "Git worktree remove failed, attempting manual cleanup..."
        
        # Force remove if git worktree remove fails
        rm -rf "$WORKTREE_PATH"
        
        # Clean up git worktree references
        if [ -n "$FEATURE_BRANCH" ]; then
            echo "Cleaning up git references for branch: $FEATURE_BRANCH"
            git worktree prune 2>/dev/null
            
            # Optionally delete the branch (with confirmation)
            if git branch | grep -q "$FEATURE_BRANCH"; then
                echo ""
                read -p "Delete branch '$FEATURE_BRANCH'? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    git branch -D "$FEATURE_BRANCH" 2>/dev/null
                    echo "Branch deleted: $FEATURE_BRANCH"
                else
                    echo "Branch preserved: $FEATURE_BRANCH"
                fi
            fi
        fi
    fi
else
    echo "Worktree not found: $WORKTREE_PATH"
fi

echo ""

# Clean up empty .worktrees directory
echo "=== Cleaning up directories ==="
if [ -d ".worktrees" ]; then
    # Check if .worktrees directory is empty
    if [ -z "$(ls -A .worktrees 2>/dev/null)" ]; then
        echo "Removing empty .worktrees directory"
        rmdir .worktrees
    else
        echo "Keeping .worktrees directory (contains other worktrees)"
    fi
fi

echo ""
echo "=== Cleanup Summary ==="
echo "Feature code: $FEATURE_CODE"
echo "Worktree path: $WORKTREE_PATH"
echo "Windows cleaned: PM-$FEATURE_CODE, ENG-$FEATURE_CODE, ENG-$FEATURE_CODE-*"
echo ""
echo "Cleanup complete for feature: $FEATURE_CODE"
echo "Use 'tmux list-windows' to verify window cleanup"
echo "Use 'git worktree list' to verify worktree cleanup"