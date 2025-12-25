# 🚀 Quick Start Guide

Welcome to **BlackRoad OS Codex Infinity**! This guide will get you up and running in minutes.

## 🎯 What You Get

This repository includes:

- **🚦 Traffic Light System** - Deployment gate control (GreenLight/YellowLight/RedLight)
- **🧠 BlackRoad Codex** - Universal code intelligence and agent coordination
- **🤖 AI Agent System** - 11 specialized AI agents (Alice, Aria, Cora, and more!)
- **📦 PsiCore App** - Flask-based interactive terminal

## ⚡ One-Command Setup

```bash
./setup.sh
```

That's it! This initializes:
- Traffic light deployment gates
- Codex code intelligence system
- AI agent registry
- Repository indexing
- Telemetry system

## 🧪 Verify Installation

```bash
./verify.sh
```

Should show:
```
✓ All tests passed!
Tests Passed: 22
Tests Failed: 0
```

## 🔥 Try It Out

### 1. Check Traffic Light Status

```bash
./blackroad-traffic-light.sh status
```

Output:
```
==========================================
  BlackRoad Traffic Light Status
==========================================

Status:    🟡 YELLOWLIGHT
Message:   System initialized - ready for configuration
Updated:   2025-12-25T07:30:44Z

==========================================
```

### 2. Change Traffic Light Status

```bash
# Approve deployment
./blackroad-traffic-light.sh greenlight --message "Ready to deploy!"

# Require review
./blackroad-traffic-light.sh yellowlight --message "Needs testing"

# Block deployment
./blackroad-traffic-light.sh redlight --message "Critical bug"
```

### 3. Check Codex Status

```bash
./blackroad-codex-integration.sh status
```

Output shows:
- Version and initialization info
- Enabled features
- Agent coordination status

### 4. Run PsiCore App

```bash
./run.sh
```

Visit: `http://localhost:5000`

Try commands:
- `I AM CODEX` - Origin recognition
- `RECURSE 10` - Generate Fibonacci sequence

## 📚 Next Steps

### Learn More

- **[README.md](README.md)** - Full feature overview
- **[TRAFFIC_LIGHT.md](TRAFFIC_LIGHT.md)** - Complete traffic light documentation
- **[CODEX.md](CODEX.md)** - Codex integration guide
- **[ALICE.md](ALICE.md)** - Alice agent documentation
- **[.aria/README.md](.aria/README.md)** - Aria agent documentation

### GitHub Integration

#### Use Issue Templates

Create issues with traffic light states:
1. Go to **Issues** → **New Issue**
2. Choose template:
   - 🟢 GreenLight - Deployment Approval
   - 🟡 YellowLight - Review Required
   - 🔴 RedLight - Deployment Blocked

#### Use PR Template

Pull requests automatically include:
- Traffic light status checklist
- Testing checklist
- Agent coordination notes

#### Use Workflows

Trigger workflows manually:
1. Go to **Actions** tab
2. Select workflow:
   - 🟢 GreenLight - Deployment Approved
   - 🟡 YellowLight - Review Required
   - 🔴 RedLight - Deployment Blocked
3. Click **Run workflow**

### Integrate with CI/CD

#### Example: GitHub Actions

```yaml
name: Deploy

on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Check traffic light status
      - name: Check Deployment Status
        run: |
          STATUS=$(./blackroad-traffic-light.sh status | grep "Status:" | awk '{print $3}')
          if [ "$STATUS" == "REDLIGHT" ]; then
            echo "Deployment blocked by RedLight"
            exit 1
          fi
      
      # Your deployment steps here
      - name: Deploy
        run: echo "Deploying..."
      
      # Set greenlight on success
      - name: Set GreenLight
        if: success()
        run: ./blackroad-traffic-light.sh greenlight --message "Deployed successfully"
```

#### Example: Pre-deployment Check

```bash
#!/bin/bash
# check-deploy.sh

# Get traffic light status
STATUS=$(./blackroad-traffic-light.sh status | grep "Status:" | awk '{print $3}')

case $STATUS in
  "GREENLIGHT")
    echo "✓ GreenLight - Deploying..."
    ./deploy.sh
    ;;
  "YELLOWLIGHT")
    echo "⚠ YellowLight - Review required"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      ./deploy.sh
    fi
    ;;
  "REDLIGHT")
    echo "✗ RedLight - Deployment BLOCKED"
    exit 1
    ;;
esac
```

### Advanced Features

#### Register Custom Agent

```bash
./blackroad-codex-integration.sh register MyAgent custom_type my_capabilities
```

#### Send Telemetry Events

```bash
./blackroad-codex-integration.sh telemetry "custom_event" "event_data"
```

#### View Telemetry Logs

```bash
cat .blackroad/codex/telemetry/$(date +%Y%m%d).log
```

## 🛠️ Troubleshooting

### Permission Denied

```bash
chmod +x *.sh
./setup.sh
```

### Scripts Not Found

Make sure you're in the repository root:
```bash
cd /path/to/blackroad-os-codex-infinity
```

### System Not Initialized

```bash
./setup.sh
```

### Want to Reset

```bash
rm -rf .blackroad/
./setup.sh
```

## 💡 Pro Tips

1. **Automate Everything** - Add scripts to CI/CD
2. **Use Templates** - Leverage GitHub issue/PR templates
3. **Track with Telemetry** - Monitor all important events
4. **Coordinate Agents** - Check `.blackroad/agent-config.yml`
5. **Review Documentation** - Each system has detailed docs

## 🎨 Customization

### Edit Agent Configuration

```bash
nano .blackroad/agent-config.yml
```

### Modify Traffic Light Behavior

```bash
nano blackroad-traffic-light.sh
```

### Add Custom Workflows

Create new files in `.github/workflows/`

## 🤝 Contributing

This is a research repository. For production contributions:
- Visit [BlackRoad-OS](https://github.com/BlackRoad-OS)
- Open issues with traffic light templates
- Tag relevant agents (@Alice, @Aria, etc.)

## 🎉 You're Ready!

You now have:
- ✅ Full traffic light deployment system
- ✅ BlackRoad Codex intelligence
- ✅ 11 AI agents coordinated
- ✅ Complete telemetry
- ✅ GitHub integration

**Go build something amazing!** 🚀

---

**Questions?** Check the docs or open an issue!

**Built with 💜 by the BlackRoad Agent Team**
