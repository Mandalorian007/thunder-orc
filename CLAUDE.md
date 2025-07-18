# Thunder ORC - Multi-Agent Development System

## System Overview

Thunder ORC is a sophisticated multi-agent orchestration system for managing complex software development projects. It uses tmux for coordination and Git worktrees for isolated development environments.

## Agent Roles & Hierarchy

### 🎯 **ORC (Orchestrator)**
- **Role**: Strategic coordinator managing multiple Project Managers
- **Window**: `ORC` (works in main directory)
- **Responsibilities**:
  - Cross-feature dependency management
  - Resource allocation and timeline coordination
  - Final approval authority for feature releases
  - PM oversight and escalation handling

### 👔 **PM (Project Manager)**
- **Role**: Feature-specific management for one feature
- **Window**: `PM-{FEATURE_CODE}` (works in feature worktree)
- **Responsibilities**:
  - Specification adherence enforcement
  - Engineer coordination and management
  - Quality gatekeeping and deliverable review
  - Progress tracking and blocker identification

### 🔧 **ENG (Engineer)**
- **Role**: Technical implementation specialist for one feature
- **Window**: `ENG-{FEATURE_CODE}` (works in feature worktree)
- **Responsibilities**:
  - Feature implementation according to specifications
  - Code quality, testing, and documentation
  - Technical problem-solving and debugging
  - Production-ready code delivery

## Communication Flow

```
User → ORC → PM → ENG
            ↓
        Feature Delivery
```

- **ORC manages PMs** (not Engineers directly)
- **PMs manage Engineers** (not other PMs)
- **Engineers report to PMs** (not ORC directly)

## Directory Structure

```
thunder-orc/                    # Main directory (ORC workspace)
├── .worktrees/                 # Isolated development environments
│   ├── auth-system/           # AUTH feature worktree
│   ├── dashboard/             # DASH feature worktree
│   └── payment-system/        # PAYMENT feature worktree
├── features/                   # Feature specifications
│   ├── auth.md                # AUTH feature file
│   ├── dashboard.md           # DASH feature file
│   └── payment.md             # PAYMENT feature file
├── .claude/
│   ├── commands/              # Agent briefing slash commands
│   └── scripts/               # Automation scripts
└── [project files]
```

## Feature File Format

**⚠️ CRITICAL**: Each feature MUST be defined with YAML frontmatter containing specific fields for automation to work properly.

### Required YAML Frontmatter Fields
```yaml
---
feature_name: "auth-system"      # REQUIRED: Directory name for worktree
feature_code: "AUTH"             # REQUIRED: Uppercase code for agent windows
feature_port: 3000               # REQUIRED: Unique port for development server
feature_branch: "feature/auth-system"  # REQUIRED: Git branch name
dependencies: []                 # REQUIRED: Array of feature dependencies
environment:                     # OPTIONAL: Feature-specific env vars
  DATABASE_URL: "postgresql://localhost:5432/auth_db"
  API_PREFIX: "/api/v1/auth"
---

# Feature Specification
[Detailed requirements, API endpoints, database schema, etc.]
```

### Field Descriptions
- **`feature_name`**: Must be a valid directory name (used for worktree path)
- **`feature_code`**: Uppercase alphanumeric code for agent identification
- **`feature_port`**: Unique port number for development server
- **`feature_branch`**: Git branch name for feature development
- **`dependencies`**: Array of other feature codes this feature depends on
- **`environment`**: Optional key-value pairs for feature-specific environment variables

### Sample Feature File
- **Complex Frontend**: `.claude/sample-feature.md` - Next.js dashboard with comprehensive testing

**All automation scripts depend on this frontmatter structure being present and correctly formatted.**

## Core Scripts

### 🚀 **Setup Feature Team**
```bash
.claude/scripts/setup-agents-for-feature.sh AUTH features/auth.md
```
- Creates Git worktree at `.worktrees/auth-system/`
- Creates feature branch `feature/auth-system`
- Sets up PM and Engineer agents in worktree
- Briefs both agents with feature file

### 💬 **Send Message**
```bash
.claude/scripts/send-message.sh PM-AUTH "Status update request"
```
- Sends messages between agents in current session
- Handles proper timing and formatting

### ⏰ **Schedule Reminder**
```bash
.claude/scripts/schedule-reminder.sh PM 30
```
- Schedules periodic self-reminders for agents
- Encourages proactive communication

### 🧹 **Cleanup Feature** (⚠️ Use with caution)
```bash
.claude/scripts/cleanup-feature.sh AUTH features/auth.md
```
- Removes ALL feature assets (windows, worktree, branch)
- **ALWAYS confirm with user before running**
- **Ensure all work is committed and pushed first**

## Agent Briefing Commands

### `/brief-orchestrator`
- Provides strategic PM management guidance
- Explains feature team setup workflow
- Includes safety warnings for cleanup operations

### `/brief-project-manager {FEATURE_CODE} {FEATURE_FILE}`
- Feature-specific PM briefing
- Includes worktree context and port information
- Establishes check-in workflows and quality assurance procedures

### `/brief-engineer {FEATURE_CODE} {FEATURE_FILE}`
- Technical implementation guidance
- Worktree setup and development environment
- Communication patterns with PM

## Window Management

### **Agent Windows**
- `ORC` - Orchestrator (main directory)
- `PM-{FEATURE_CODE}` - Project Manager (feature worktree)
- `ENG-{FEATURE_CODE}` - Engineer (feature worktree)

### **Development Windows** (Engineer-created)
- `ENG-{FEATURE_CODE}-APP` - Application server (for running the app while coding)

## Workflow Examples

### **Starting a New Feature**
1. **Orchestrator**: Create feature file in `features/auth.md`
2. **Orchestrator**: Run setup script for feature team
3. **PM**: Read feature file, set up check-ins
4. **Engineer**: Change to worktree, start implementation
5. **All**: Regular progress updates and coordination

### **Daily Development**
1. **PM**: Check in with Engineer using send-message
2. **Engineer**: Work in worktree, create dev windows as needed
3. **PM**: Monitor application in `ENG-{FEATURE_CODE}-APP` window
4. **ORC**: Coordinate between PMs, manage dependencies

### **Feature Completion**
1. **Engineer**: Complete implementation, notify PM
2. **PM**: Review deliverables, approve feature
3. **PM**: Report completion to Orchestrator
4. **ORC**: Verify feature meets standards
5. **ORC**: Get user confirmation before cleanup

## Key Principles

### **Isolation**
- Each feature team works in dedicated worktree
- No conflicts between parallel development
- Clean separation of concerns

### **Automation**
- One-command feature team setup
- Automated worktree and branch creation
- Streamlined communication between agents

### **Safety**
- Multiple validation steps before destructive operations
- Clear ownership and responsibility boundaries
- Explicit user confirmation for cleanup operations

### **Scalability**
- Easy to add new features and agents
- Consistent patterns across all operations
- Centralized coordination with distributed execution

## Getting Started

1. **Setup Session**: Create tmux session and Orchestrator
2. **Create Feature**: Write feature file with requirements
3. **Setup Team**: Use setup script to create PM and Engineer
4. **Develop**: Let agents coordinate while you oversee
5. **Deploy**: Complete feature and cleanup when ready

The Thunder ORC system transforms complex multi-feature development into a manageable, automated, and scalable process through intelligent agent coordination and Git worktree isolation.