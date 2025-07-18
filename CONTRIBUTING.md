# Contributing to Thunder ORC

Thank you for your interest in contributing to Thunder ORC! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/thunder-orc.git
   cd thunder-orc
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🧪 Testing Your Changes

1. **Set up a test environment**:
   ```bash
   chmod +x .claude/scripts/*.sh
   tmux new-session -s test-session -n "ORC"
   ```

2. **Test the core functionality**:
   ```bash
   # Test script setup
   .claude/scripts/setup-agents-for-feature.sh HELLO features/hello-world.md
   
   # Test messaging
   .claude/scripts/send-message.sh PM-HELLO "Test message"
   
   # Test cleanup
   .claude/scripts/cleanup-feature.sh HELLO features/hello-world.md
   ```

3. **Verify documentation**: Ensure all changes are reflected in README.md and relevant documentation

## 📝 Code Style

### Shell Scripts
- Use `#!/bin/bash` shebang
- Include descriptive comments
- Use proper error handling
- Follow existing naming conventions
- Add usage examples in comments

### Markdown Files
- Use consistent heading levels
- Include code examples where appropriate
- Follow existing documentation structure
- Use clear, concise language

### Feature Files
- Always include required YAML frontmatter
- Use descriptive feature names
- Include comprehensive specifications
- Follow the established format

## 🐛 Bug Reports

When filing bug reports, please include:

1. **Clear description** of the issue
2. **Steps to reproduce** the problem
3. **Expected behavior** vs actual behavior
4. **Environment details** (OS, tmux version, etc.)
5. **Relevant logs** or error messages

## 💡 Feature Requests

For new features:

1. **Check existing issues** to avoid duplicates
2. **Describe the use case** and problem it solves
3. **Provide examples** of how it would work
4. **Consider backwards compatibility**

## 🔍 Code Review Process

1. **All changes require review** before merging
2. **Tests must pass** and functionality must be verified
3. **Documentation must be updated** for user-facing changes
4. **Breaking changes** require discussion and migration path

## 🏷️ Commit Guidelines

Use descriptive commit messages:

```bash
# Good examples
git commit -m "Add validation for feature YAML frontmatter"
git commit -m "Fix tmux window naming in setup script"
git commit -m "Update README with new configuration options"

# Avoid
git commit -m "Fix bug"
git commit -m "Update files"
```

## 📋 Pull Request Checklist

Before submitting a pull request:

- [ ] Code follows existing style guidelines
- [ ] Tests pass and new functionality is tested
- [ ] Documentation is updated
- [ ] Commit messages are descriptive
- [ ] No breaking changes without discussion
- [ ] Scripts are executable (`chmod +x`)
- [ ] YAML frontmatter is valid where applicable

## 🎯 Areas for Contribution

We welcome contributions in these areas:

### 🔧 Core Framework
- Improvements to agent coordination
- Enhanced error handling
- Performance optimizations
- Cross-platform compatibility

### 📖 Documentation
- Tutorial improvements
- Use case examples
- API documentation
- Video tutorials

### 🧩 Features
- New agent types or roles
- Additional automation scripts
- Integration with other tools
- Enhanced communication patterns

### 🧪 Testing
- Unit tests for scripts
- Integration test scenarios
- Performance benchmarks
- Cross-platform testing

## 🌟 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- Project documentation

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Discord**: [Join our community](https://discord.gg/thunderorc) (if available)

## 📄 License

By contributing to Thunder ORC, you agree that your contributions will be licensed under the MIT License.

Thank you for helping make Thunder ORC better! 🚀