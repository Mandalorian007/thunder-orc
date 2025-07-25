# Thunder ORC ⚡

**Multi-Agent Development Orchestration Framework**

Thunder ORC is a sophisticated multi-agent orchestration system that transforms complex software development projects into manageable, automated, and scalable processes through intelligent agent coordination and Git worktree isolation.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](https://github.com/thunderorc/thunder-orc)

## 🌟 Features

- **🎯 Multi-Agent Architecture**: Orchestrator, Project Managers, and Engineers working in harmony
- **🔄 Automated Workflows**: One-command setup for complete feature teams
- **🌳 Git Worktree Isolation**: Parallel development without conflicts
- **💬 Inter-Agent Communication**: Structured messaging system between agents
- **📊 Progress Tracking**: Automated check-ins and status updates
- **🚀 Production Ready**: Built-in testing, quality assurance, and deployment patterns
- **⚙️ Highly Configurable**: YAML-based feature specifications
- **🔒 Safe Operations**: Multiple validation steps and user confirmations

## 🏗️ Architecture

```
User → ORC (Orchestrator) → PM (Project Manager) → ENG (Engineer)
                    ↓
            Feature Delivery
```

### Agent Roles

- **🎯 ORC (Orchestrator)**: Strategic coordinator managing multiple Project Managers
- **👔 PM (Project Manager)**: Feature-specific management for individual features
- **🔧 ENG (Engineer)**: Technical implementation specialists for specific features

## 🚀 Quick Start

### Prerequisites

- **tmux**: Terminal multiplexer for session management
- **Git**: Version control with worktree support
- **Claude CLI**: AI assistant for agent coordination
- **Bash**: Shell scripting support

#### Custom tmux directory management that should be in your configuration
```bash
# Split pane also opens to current directory (easier to get to home than back to where you are)
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
```

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/thunderorc/thunder-orc.git
   cd thunder-orc
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x .claude/scripts/*.sh
   ```

3. **Initialize your session**:
   ```bash
   tmux new-session -s "my-project" -n "ORC"
   cd /path/to/thunder-orc
   claude --dangerously-skip-permissions
   ```
   
   **Important**: 
   - **Window name must be "ORC"** - this is required for the framework to work correctly
   - **Session name can be anything** - use descriptive names to track different projects or development tracks
   
   **Examples for different projects**:
   ```bash
   tmux new-session -s "ecommerce-platform" -n "ORC"
   tmux new-session -s "mobile-app" -n "ORC"
   tmux new-session -s "data-pipeline" -n "ORC"
   ```

4. **Brief the Orchestrator**:
   ```bash
   /brief-orchestrator
   ```

### Your First Feature

1. **Create a feature file** (`features/my-feature.md`):
   ```yaml
   ---
   feature_name: "my-awesome-feature"
   feature_code: "AWESOME"
   feature_port: 3001
   feature_branch: "feature/my-awesome-feature"
   dependencies: []
   environment:
     API_URL: "http://localhost:3000"
   ---
   
   # My Awesome Feature
   [Feature requirements and specifications...]
   ```

2. **Setup the feature team**:
   ```bash
   .claude/scripts/setup-agents-for-feature.sh AWESOME features/my-feature.md
   ```

3. **Watch the magic happen!** 🎉

## 📁 Project Structure

```
thunder-orc/
├── .claude/
│   ├── commands/              # Agent briefing slash commands
│   │   ├── brief-orchestrator.md
│   │   ├── brief-project-manager.md
│   │   └── brief-engineer.md
│   ├── scripts/               # Automation scripts
│   │   ├── setup-agents-for-feature.sh
│   │   ├── send-message.sh
│   │   ├── schedule-reminder.sh
│   │   └── cleanup-feature.sh
│   └── sample-feature.md      # Comprehensive feature example
├── .worktrees/                # Isolated development environments
│   ├── feature-a/            # Feature A worktree
│   └── feature-b/            # Feature B worktree
├── features/                  # Feature specifications
│   └── hello-world.md        # Hello World example
├── CLAUDE.md                 # Project instructions for Claude
├── SYSTEM-OVERVIEW.md        # Detailed system architecture
├── README.md                 # This file
└── .gitignore               # Git ignore patterns
```

## 🎯 Core Scripts

### 🚀 Setup Feature Team
```bash
.claude/scripts/setup-agents-for-feature.sh <FEATURE_CODE> <FEATURE_FILE>
```
- Creates Git worktree for isolated development
- Sets up PM and Engineer agents with proper briefings
- Establishes feature branch and environment

### 💬 Send Message
```bash
.claude/scripts/send-message.sh <WINDOW_NAME> <MESSAGE>
```
- Facilitates communication between agents
- Handles proper timing and message formatting
- Maintains session context automatically

### ⏰ Schedule Reminder
```bash
.claude/scripts/schedule-reminder.sh <AGENT_TYPE> <INTERVAL_MINUTES>
```
- Sets up periodic self-reminders for agents
- Encourages proactive communication
- Maintains project momentum

### 🧹 Cleanup Feature
```bash
.claude/scripts/cleanup-feature.sh <FEATURE_CODE> [FEATURE_FILE]
```
- **Only run when explicitly requested**
- Removes tmux windows and worktree assets
- Preserves branches by default for user review

## 📝 Feature File Format

Every feature must include YAML frontmatter with required fields:

```yaml
---
feature_name: "my-feature"      # REQUIRED: Directory name for worktree
feature_code: "FEAT"            # REQUIRED: Uppercase code for agent windows
feature_port: 3001              # REQUIRED: Unique port for development
feature_branch: "feature/my-feature"  # REQUIRED: Git branch name
dependencies: ["AUTH"]          # REQUIRED: Array of feature dependencies
environment:                    # OPTIONAL: Feature-specific env vars
  API_URL: "http://localhost:3000"
  DB_NAME: "my_feature_db"
---

# Feature Specification
[Detailed requirements, API endpoints, database schema, etc.]
```

## 🔄 How It Works

Once you set up a feature team, the agents coordinate automatically:

- **Agents communicate through tmux windows** - you can observe their coordination by switching between windows
- **Progress updates appear in real-time** - watch the PM-{FEATURE} and ENG-{FEATURE} windows
- **Development happens in isolated worktrees** - each feature gets its own development environment
- **You maintain oversight** - agents will report completion and ask for confirmation before major actions

## 🌊 User Workflow

### Starting a New Feature
1. **You**: Create a feature file in `features/` with your requirements
2. **You**: Run the setup script to create the agent team
3. **You**: Observe agents coordinate and begin development
4. **You**: Switch between tmux windows to monitor progress

### During Development
1. **You**: Monitor progress by checking agent windows
2. **You**: Watch your application come to life in real-time
3. **You**: Agents handle coordination, testing, and quality automatically
4. **You**: Intervene only if needed or when agents ask for clarification

### Feature Completion
1. **Agents**: Complete implementation and run all tests
2. **Agents**: Report completion with branch information
3. **You**: Review the completed feature and decide next steps
4. **You**: Choose to merge, request changes, or cleanup when ready

## 🎨 Example Features

### 🌍 Hello World App
- **Port**: 4100
- **Tech**: Next.js 14, TypeScript, Tailwind CSS
- **Features**: Homepage, about page, responsive design
- **File**: `features/hello-world.md`

### 📊 Dashboard (Sample)
- **Port**: 3100
- **Tech**: Next.js 14, TypeScript, Tailwind, Testing suite
- **Features**: Data visualization, real-time updates, comprehensive testing
- **File**: `.claude/sample-feature.md`

### 🔐 Authentication System (Example)
- **Port**: 3000
- **Tech**: Node.js, PostgreSQL, JWT
- **Features**: Registration, login, password reset, user management
- **Note**: Example used in agent briefings, not included as feature file

## 🔧 Configuration

### Agent Briefings
- **`/brief-orchestrator`**: Strategic PM management guidance
- **`/brief-project-manager FEAT features/feat.md`**: Feature-specific PM briefing
- **`/brief-engineer FEAT features/feat.md`**: Technical implementation guidance

### Window Management
- **`ORC`**: Orchestrator window (main directory)
- **`PM-{FEATURE_CODE}`**: Project Manager window (feature worktree)
- **`ENG-{FEATURE_CODE}`**: Engineer window (feature worktree)
- **`ENG-{FEATURE_CODE}-APP`**: Application server window

## 🚨 Important Requirements

### ✅ Required for Feature Files
- **Always include complete YAML frontmatter** - agents need this metadata to function properly
- **Use unique ports** - avoid conflicts between features
- **Write clear specifications** - detailed requirements lead to better implementations

### 💡 Tips for Success
- Use descriptive session names to track different projects
- Monitor agent progress through tmux windows
- Review completed features before merging
- Keep feature files organized and up-to-date

## 🛡️ Safety Features

- **Multiple validation steps** before destructive operations
- **User confirmation required** for cleanup operations
- **Isolated development environments** prevent conflicts
- **Structured communication** prevents miscommunication
- **Progress tracking** ensures accountability

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the existing code style
4. Test your changes thoroughly
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/thunderorc/thunder-orc/issues)
- **Documentation**: [Wiki](https://github.com/thunderorc/thunder-orc/wiki)
- **Discussions**: [GitHub Discussions](https://github.com/thunderorc/thunder-orc/discussions)

## 🎉 Acknowledgments

### 🌟 Primary Inspiration
**[Tmux-Orchestrator](https://github.com/Jedward23/Tmux-Orchestrator)** by [@Jedward23](https://github.com/Jedward23)

Thunder ORC was inspired by the groundbreaking Tmux-Orchestrator project, which demonstrated the fantastic idea of leveraging **tmux for AI agent coordination**. The original project introduced the revolutionary concept of autonomous AI agents that can "run AI agents 24/7 while you sleep" using tmux sessions as the coordination mechanism.

The brilliant insight from Tmux-Orchestrator that inspired Thunder ORC:
- **Using tmux as the coordination layer** for AI agents - this was the key innovation
- **Persistent terminal sessions** enabling continuous agent operation
- **Multi-window management** for organized agent workflows
- **Autonomous AI coordination** using tmux's session capabilities

While Thunder ORC uses a different orchestration pattern focused on feature-based development with Git worktrees, the core concept of leveraging tmux for AI agent coordination came directly from this pioneering project.

> *"The tools we build today will program themselves tomorrow"* - Alan Kay, 1971 (quoted in Tmux-Orchestrator)

### 🚀 Additional Credits
- Built for the Claude AI ecosystem
- Enhanced with Git worktree isolation patterns
- Designed for modern DevOps scalability
- Community-driven development approach

---

**Thunder ORC** - *Orchestrating Development, One Feature at a Time* ⚡

*Transform your complex multi-feature development into a manageable, automated, and scalable process.*