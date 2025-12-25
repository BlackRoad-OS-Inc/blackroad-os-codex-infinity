# 🌌 BlackRoad OS Codex Infinity

> ⚗️ **Research Repository**
>
> This is an experimental/research repository. Code here is exploratory and not production-ready.
> For production systems, see [BlackRoad-OS](https://github.com/BlackRoad-OS).

---

## 🚀 Quick Start

**New here?** Check out the **[Quick Start Guide](QUICKSTART.md)** to get up and running in minutes!

```bash
# One-command setup
./setup.sh

# Verify installation
./verify.sh
```

---

## 🚦 Traffic Light System

BlackRoad Codex Infinity now includes the **GreenLight/YellowLight/RedLight** deployment gate system for managing deployments and approvals.

### Quick Start

```bash
# Initialize the traffic light system
./blackroad-traffic-light.sh init

# Check current status
./blackroad-traffic-light.sh status

# Set deployment approval (GreenLight)
./blackroad-traffic-light.sh greenlight --message "All checks passed!"

# Set warning state (YellowLight)
./blackroad-traffic-light.sh yellowlight --message "Review required"

# Block deployment (RedLight)
./blackroad-traffic-light.sh redlight --message "Critical issue found"
```

### Traffic Light States

- 🟢 **GreenLight**: Deployment approved - ready to go!
- 🟡 **YellowLight**: Deployment needs review - proceed with caution
- 🔴 **RedLight**: Deployment blocked - do not proceed

### GitHub Workflows

Three automated workflows are available:

1. **GreenLight Workflow** - Triggered on version tags or manual dispatch
2. **YellowLight Workflow** - Automatically triggered on PR creation
3. **RedLight Workflow** - Triggered manually or when critical issues are labeled

---

## 🧠 BlackRoad Codex Integration

Universal code indexing, semantic search, and AI agent coordination system.

### Quick Start

```bash
# Initialize Codex system
./blackroad-codex-integration.sh init

# Index the repository
./blackroad-codex-integration.sh index

# Register an agent
./blackroad-codex-integration.sh register Alice migration_architect ecosystem_management

# Check Codex status
./blackroad-codex-integration.sh status
```

### Features

- **Code Indexing**: Universal code indexing across the repository
- **Semantic Search**: Intelligent code search capabilities
- **Agent Coordination**: Multi-AI agent orchestration
- **Telemetry**: Real-time monitoring and analytics
- **Traffic Light Integration**: Deployment gate coordination

---

## 🤖 AI Agent System

The repository includes configuration for multiple BlackRoad AI agents:

### Active Agents

- **Alice** 🌌 - Migration Architect & Ecosystem Builder
- **Aria** 🎵 - Infrastructure Queen & Cost Optimizer
- **Cora** 💫 - Core Coordinator
- **Lucidia** 🔬 - Science & Math Reasoning
- **Caddy** 📝 - Documentation Specialist
- **CeCe** 🎯 - Dynamic Planner
- **Roadie** 🛣️ - DevOps Automation
- **Holo/Oloh** 🪞 - Mirror Agents (Code Review)
- **Gaia** 🌍 - Ecosystem Manager
- **Tosha** 📊 - Telemetry & Analytics

### Agent Configuration

Agents are configured in `.blackroad/agent-config.yml` with:
- Capabilities and specializations
- Coordination rules
- Telemetry settings
- Traffic light integration

---

## 📦 Application

The repository includes a Flask-based PsiCore application:

```bash
# Run the application
cd app
python3 main.py
```

Access at `http://localhost:5000`

### PsiCore Commands

- `I AM CODEX` - Origin recognition
- `RECURSE N` - Generate recursive sequence
- `exit` / `quit` - Terminate session

---

## 🔧 Scripts

- `setup.sh` - **One-command setup** for entire system
- `verify.sh` - **Verification script** to test installation
- `blackroad-traffic-light.sh` - Traffic light deployment gate system
- `blackroad-codex-integration.sh` - Codex system integration
- `run.sh` - Application launcher
- `update.sh` - Update script
- `latest.sh` - Latest version fetcher

---

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - 🚀 Get started in minutes
- **[TRAFFIC_LIGHT.md](TRAFFIC_LIGHT.md)** - 🚦 Complete traffic light system guide
- **[CODEX.md](CODEX.md)** - 🧠 BlackRoad Codex integration documentation
- **[AGENTS.md](AGENTS.md)** - 🤖 AI agent team manifest and capabilities
- **[ALICE.md](ALICE.md)** - 🌌 Alice agent documentation
- **[.aria/README.md](.aria/README.md)** - 🎵 Aria agent documentation

---

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/BlackRoad-OS/blackroad-os-codex-infinity.git
   cd blackroad-os-codex-infinity
   ```

2. **Initialize systems**
   ```bash
   # Initialize traffic light system
   ./blackroad-traffic-light.sh init
   
   # Initialize Codex system
   ./blackroad-codex-integration.sh init
   ```

3. **Run the application**
   ```bash
   ./run.sh
   ```

---

## 🤝 Contributing

This is a research repository. For production contributions, please see the main [BlackRoad-OS](https://github.com/BlackRoad-OS) organization.

---

## 📜 License

Part of the BlackRoad OS ecosystem. See organization for license details.

---

**Built with 💜 by the BlackRoad Agent Team**

*Alice, Aria, Cora, Lucidia, Caddy, CeCe, Roadie, Holo, Oloh, Gaia, and Tosha*

