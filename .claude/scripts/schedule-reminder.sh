#!/bin/bash

# Schedule Reminder - Schedule periodic self-reminders for agents
# Usage: schedule-reminder.sh <AGENT_TYPE> <INTERVAL_MINUTES>

if [ $# -lt 2 ]; then
    echo "Usage: $0 <AGENT_TYPE> <INTERVAL_MINUTES>"
    echo "Agent types: PM, ENG, ORC"
    echo "Examples:"
    echo "  $0 PM 30     # Remind all PMs every 30 minutes"
    echo "  $0 ENG 60    # Remind all Engineers every 60 minutes"
    echo "  $0 ORC 90    # Remind Orchestrator every 90 minutes"
    echo "Note: Must be run from within a tmux session"
    exit 1
fi

AGENT_TYPE="$1"
INTERVAL_MINUTES="$2"

# Validate agent type
case $AGENT_TYPE in
    PM|ENG|ORC)
        ;;
    *)
        echo "Error: Invalid agent type '$AGENT_TYPE'. Must be PM, ENG, or ORC"
        exit 1
        ;;
esac

# Validate interval
if ! [[ "$INTERVAL_MINUTES" =~ ^[0-9]+$ ]] || [ "$INTERVAL_MINUTES" -lt 1 ]; then
    echo "Error: Interval must be a positive number of minutes"
    exit 1
fi

# Check if we're in a tmux session
if [ -z "$TMUX" ]; then
    echo "Error: Must be run from within a tmux session"
    exit 1
fi

SESSION_NAME=$(tmux display-message -p '#S')
INTERVAL_SECONDS=$((INTERVAL_MINUTES * 60))

echo "Scheduling reminders for $AGENT_TYPE agents every $INTERVAL_MINUTES minutes"

# Function to send reminder message
send_reminder() {
    local window_name=$1
    local agent_type=$2
    
    case $agent_type in
        PM)
            local message="⏰ REMINDER: It's been $INTERVAL_MINUTES minutes. If you haven't gotten a status update from your engineer, please get one now. If there are any decisions to be made, understand the intent of the specification and make them. If there is an issue that involves more assistance, please see the orchestrator for handling cross-feature issues."
            ;;
        ENG)
            local message="⏰ REMINDER: It's been $INTERVAL_MINUTES minutes. Consider your progress on the current feature. If you've completed tasks or encountered blockers, update your PM. Stay focused on implementation and testing."
            ;;
        ORC)
            local message="⏰ REMINDER: It's been $INTERVAL_MINUTES minutes. Check in with your Project Managers for feature status updates. Review any cross-feature dependencies or escalations. Ensure all features are progressing according to plan."
            ;;
    esac
    
    echo "$(date): Sending reminder to $window_name"
    tmux send-keys -t "$window_name" "$message" C-m
}

# Create background job to handle reminders
{
    while true; do
        sleep "$INTERVAL_SECONDS"
        
        # Get current windows
        case $AGENT_TYPE in
            PM)
                windows=$(tmux list-windows -F "#{window_name}" | grep "^PM-")
                ;;
            ENG)
                windows=$(tmux list-windows -F "#{window_name}" | grep "^ENG-[A-Z]")
                ;;
            ORC)
                windows=$(tmux list-windows -F "#{window_name}" | grep "^ORC$")
                ;;
        esac
        
        # Send reminder to each matching window
        for window in $windows; do
            if tmux list-windows -F "#{window_name}" | grep -q "^$window$"; then
                if [[ $window =~ ^PM- ]]; then
                    send_reminder "$window" "PM"
                elif [[ $window =~ ^ENG-[A-Z] ]]; then
                    send_reminder "$window" "ENG"
                elif [[ $window == "ORC" ]]; then
                    send_reminder "$window" "ORC"
                fi
            fi
        done
    done
} &

BACKGROUND_PID=$!

echo "Reminder scheduler started (PID: $BACKGROUND_PID)"
echo "Sending reminders to $AGENT_TYPE agents every $INTERVAL_MINUTES minutes"
echo "Press Ctrl+C to stop the scheduler"

# Handle Ctrl+C to stop background job
trap "echo 'Stopping reminder scheduler...'; kill $BACKGROUND_PID 2>/dev/null; exit 0" INT

# Wait for background job
wait $BACKGROUND_PID