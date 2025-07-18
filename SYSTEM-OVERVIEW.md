# Thunder ORC Agent System Overview

## Philosophy: Plug and Play Agent Management

The system is designed to be simple, consistent, and immediately usable. Three core scripts handle all agent operations, while tmux provides the underlying window management for both agents and development work.

## Core Architecture

### Session Structure
- **Session Name**: User-defined (e.g., `tacowaco`, `my-work`, `dev-session`) - ALL work happens in this one session
- **Agent Windows**: 
  - Orchestrator: `ORC` (cross-feature management)
  - Feature-specific: `{ROLE}-{FEATURE_CODE}` (e.g., `PM-AUTH`, `ENG-DASH`)
- **Engineer Dev Windows**: `ENG-{FEATURE_CODE}-{PURPOSE}` (e.g., `ENG-AUTH-APP`, `ENG-DASH-LOGS`)

### Three Core Scripts

#### 1. `setup-agents-for-feature.sh` (To be created)
**Purpose**: One-command setup for complete feature team (PM + ENG)
```bash
.claude/scripts/setup-agents-for-feature.sh <FEATURE_CODE> <SPEC_FILE>
```
- Creates both PM and ENG windows in current session
- Starts Claude in both windows with permissions bypassed
- Automatically sends briefing commands to both agents
- Uses feature code for agent identification, session name for window placement
- Single command to get a complete feature team running

#### 2. `send-message.sh` (To be created)
**Purpose**: Send messages to any agent window
```bash
.claude/scripts/send-message.sh <WINDOW_NAME> <MESSAGE>
```
- Sends message with proper timing (0.5s delay)
- Uses current session automatically (no session specification needed)
- Handles message formatting and submission

#### 3. `schedule-reminder.sh` (To be created)
**Purpose**: Schedule periodic self-reminders for agents
```bash
.claude/scripts/schedule-reminder.sh <AGENT_TYPE> <INTERVAL>
```
- Agents receive reminders to check their own status
- Encourages proactive communication and decision-making
- Maintains project momentum through self-awareness
- Works with current session context automatically

## Agent Role Framework

### ORC (Orchestrator)
- **Cross-Feature Management**: Manages multiple features and their PMs simultaneously
- **Strategic Coordination**: Handles dependencies, priorities, and resource allocation between features
- **Production Readiness**: Ensures each feature branch meets production standards (functionality, testing, documentation)
- **PM Oversight**: Manages and coordinates multiple Project Managers across different features
- **Final Authority**: Approval, sign-off, and escalation handling for all features
- **Briefing**: `/brief-orchestrator` (To be created) - Behavioral guidance for managing PMs across features

### PM (Project Manager)
- **Feature-Specific Management**: Dedicated to a single feature development
- **Specification Adherence**: Ensures requirements are followed exactly for their feature
- **Engineer Coordination**: Manages their assigned engineer agent
- **Quality Gatekeeper**: Reviews deliverables against specs for their feature
- **Progress Monitoring**: Daily tracking, blocker identification for their feature
- **Reports to**: Orchestrator (ORC) for cross-feature coordination
- **Briefing**: `/brief-project-manager {FEATURE_CODE} {SPEC_FILE}` (To be created)

### ENG (Engineer)
- **Feature-Specific Implementation**: Technical work for a single assigned feature
- **Technical Implementation**: Code, tests, documentation for their feature
- **Problem Solving**: Debug, optimize, refactor for their feature
- **Quality Assurance**: Unit tests, code reviews for their feature
- **Progress Reporting**: Updates to their assigned PM on completion status
- **Reports to**: Project Manager (PM) for their specific feature
- **Briefing**: `/brief-engineer {FEATURE_CODE} {SPEC_FILE}` (To be created)

## Development Workflow

### Initial Setup -- Manual by user
1. **Create Session and Orchestrator**:
   ```bash
   # User creates session with any name they want
   tmux new-session -s tacowaco -n "ORC"
   cd IdeaProjects/thunder-orc
   claude --dangerously-skip-permissions
   # Run: /brief-orchestrator
   ```

2. **Create Feature Teams** (in same session):
   ```bash
   # Setup complete feature team with one command (creates windows in current session)
   .claude/scripts/setup-agents-for-feature.sh AUTH specs/auth.md
   .claude/scripts/setup-agents-for-feature.sh DASH specs/dashboard.md
   ```

3. **Create Engineer Dev Windows** (in same session):
   ```bash
   tmux new-window -n "ENG-AUTH-APP"    # For running the application
   ```

### Daily Operations
- **Agent Communication**: Use `send-message.sh` to communicate with agents in current session
- **Development Work**: Use standard tmux commands for dev windows
- **Status Updates**: Use `schedule-reminder.sh` for regular self-reminders in current session
- **Window Navigation**: Standard tmux navigation (`Ctrl+b + window_number`)
- **Session Context**: All tools automatically use the current session you're working in

## Developer Window Management

### Exposed tmux Commands
Developers have full access to tmux for their development needs:

```bash
# Create specialized windows
tmux new-window -n "ENG-AUTH-DB"     # Database operations
tmux new-window -n "ENG-AUTH-API"    # API testing
tmux new-window -n "ENG-AUTH-BUILD"  # Build processes

# Window management
tmux list-windows                      # See all windows
tmux select-window -t "ENG-AUTH-APP"  # Switch to specific window
tmux kill-window -t "ENG-AUTH-APP"    # Close window when done

# Session management
tmux list-sessions                    # See all sessions
tmux attach-session -t tacowaco       # Attach to your main work session
```

### Common Development Patterns

#### Running Applications
```bash
# In ENG-AUTH-APP window
npm run dev
# or
python manage.py runserver
# or
docker-compose up
```

#### Monitoring Logs
```bash
# In ENG-AUTH-APP window (check logs)
tail -f logs/app.log
# or
docker logs -f container_name
# or
journalctl -f -u service_name

# Development tasks in main ENG window
git status
npm test
make build
```

## Benefits of This Architecture

### 1. **Clear Separation of Concerns**
- Orchestrator for cross-feature coordination (`ORC`)
- Feature-specific agents for focused development (`PM-*`, `ENG-*`)
- Engineer dev windows for human development (`ENG-*-*`)
- Clear ownership and purpose identification

### 2. **Consistent Naming**
- Single session = User-defined name (any name you want - completely separate from features)
- Orchestrator window = `ORC` (cross-feature management)
- Feature agent windows = `{ROLE}-{FEATURE_CODE}`
- Engineer dev windows = `ENG-{FEATURE_CODE}-{PURPOSE}`
- All work happens in one session with clear window naming

### 3. **Plug and Play**
- One command to setup complete feature team (PM + ENG) in current session
- One command to send messages in current session
- One command to schedule self-reminders in current session
- No complex configuration or session management needed

### 4. **Developer Flexibility**
- Full tmux access for development needs
- Engineers can create any `ENG-{FEATURE_CODE}-{PURPOSE}` windows
- Easy cleanup with pattern matching
- Standard development workflows unchanged

### 5. **Scalable**
- Easy to add new features (new windows in same session)
- Easy to add new roles (new briefing commands)
- Easy to add new development windows
- All work centralized in one session

## Engineer Window Management

### Window Ownership
- **Orchestrator Window**: `ORC` - Cross-feature management, don't modify
- **Feature Agent Windows**: `{ROLE}-{FEATURE_CODE}` - Managed by feature agents, don't modify
- **Engineer Windows**: `ENG-{FEATURE_CODE}-{PURPOSE}` - Full engineer control

### Cleanup Commands
```bash
# List all engineer windows for current feature (replace AUTH with your feature code)
tmux list-windows | grep "ENG-AUTH-"

# Kill specific engineer window
tmux kill-window -t "ENG-AUTH-APP"

# Kill all engineer windows for current feature (replace AUTH with your feature code)
tmux list-windows -F "#{window_name}" | grep "ENG-AUTH-" | xargs -I {} tmux kill-window -t "{}"
```

### Window Creation Best Practices
```bash
# Create the application window when needed:
# Example when working on AUTH feature (regardless of session name):
tmux new-window -n "ENG-AUTH-APP"      # Application server for running the app

# Feature code is separate from session name - you can work on AUTH in any session
```

## Implementation Status

**Everything in this system is to be created.** This document serves as the complete specification for building the Thunder ORC agent system.

### Required Components:
1. **Scripts** (All to be created):
   - `setup-agents-for-feature.sh`
   - `send-message.sh` 
   - `schedule-reminder.sh`

2. **Slash Commands** (All to be created):
   - `/brief-orchestrator` - Behavioral guidance for cross-feature PM management
   - `/brief-project-manager` - Feature-specific PM briefing
   - `/brief-engineer` - Feature-specific ENG briefing

3. **Directory Structure** (Exists):
   - `.claude/scripts/`
   - `.claude/commands/`

## Questions for Feedback

1. Is the three-script approach simple enough?
2. Does the `ENG-{FEATURE_CODE}-{PURPOSE}` naming solve the ownership issue?
3. Are the cleanup commands sufficient for engineers?
4. Does the single command feature team setup (`setup-agents-for-feature.sh`) provide the right level of automation?
5. Do the self-reminders from `schedule-reminder.sh` encourage better agent autonomy?
5. Any missing pieces in the workflow?