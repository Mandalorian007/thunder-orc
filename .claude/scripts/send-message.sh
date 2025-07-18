#!/bin/bash

# Send Message to Agent - Send messages to any agent window in current session
# Usage: send-message.sh <WINDOW_NAME> <MESSAGE>

if [ $# -lt 2 ]; then
    echo "Usage: $0 <WINDOW_NAME> <MESSAGE>"
    echo "Examples:"
    echo "  $0 PM-AUTH 'What is the current status of authentication feature?'"
    echo "  $0 ENG-DASH 'Please run the test suite and report results'"
    echo "  $0 ORC 'Ready for feature review: AUTH implementation complete'"
    echo "Note: Must be run from within a tmux session"
    exit 1
fi

WINDOW_NAME="$1"
shift  # Remove first argument, rest is the message
MESSAGE="$*"

# Check if we're in a tmux session
if [ -z "$TMUX" ]; then
    echo "Error: Must be run from within a tmux session"
    exit 1
fi

# Check if the target window exists
if ! tmux list-windows -F "#{window_name}" | grep -q "^$WINDOW_NAME$"; then
    echo "Error: Window '$WINDOW_NAME' not found in current session"
    echo "Available windows:"
    tmux list-windows -F "#{window_name}"
    exit 1
fi

echo "Sending message to $WINDOW_NAME: $MESSAGE"

# Send the message
tmux send-keys -t "$WINDOW_NAME" "$MESSAGE"

# Wait for UI to register
sleep 0.5

# Send Enter to submit
tmux send-keys -t "$WINDOW_NAME" Enter

echo "Message sent successfully to $WINDOW_NAME"