# 🚦 Traffic Light System Documentation

## Overview

The BlackRoad Traffic Light System provides a standardized deployment gate mechanism using three states: **GreenLight**, **YellowLight**, and **RedLight**. This system helps teams coordinate deployments, reviews, and approvals across the development lifecycle.

## Traffic Light States

### 🟢 GreenLight - Deployment Approved

**When to use:**
- All tests are passing
- Code reviews completed and approved
- Security scans passed
- Documentation is up to date
- Deployment is ready to proceed

**Actions:**
```bash
./blackroad-traffic-light.sh greenlight --message "All checks passed!"
```

### 🟡 YellowLight - Review Required

**When to use:**
- Pull request opened and needs review
- Changes require additional testing
- Documentation needs updating
- Performance impact requires assessment
- Deployment can proceed but with caution

**Actions:**
```bash
./blackroad-traffic-light.sh yellowlight --message "PR opened - needs review"
```

### 🔴 RedLight - Deployment Blocked

**When to use:**
- Critical security vulnerabilities detected
- Test failures blocking deployment
- Breaking changes without migration plan
- Legal or compliance issues
- System instability detected

**Actions:**
```bash
./blackroad-traffic-light.sh redlight --message "Critical security issue found"
```

## Usage

### Initialize System

```bash
./blackroad-traffic-light.sh init
```

This creates:
- `.blackroad/traffic-light/` directory
- `status.json` file for state tracking
- Initial YELLOWLIGHT status

### Check Status

```bash
./blackroad-traffic-light.sh status
```

Output shows:
- Current traffic light state
- Message/reason for current state
- Timestamp of last update

### Change Status

```bash
# Approve deployment
./blackroad-traffic-light.sh greenlight --message "Ready to deploy"

# Require review
./blackroad-traffic-light.sh yellowlight --message "Needs testing"

# Block deployment
./blackroad-traffic-light.sh redlight --message "Critical bug found"
```

## GitHub Integration

### Automated Workflows

Three GitHub Actions workflows are provided:

#### 1. GreenLight Workflow
- **Trigger:** Version tags (`v*`) or manual dispatch
- **Action:** Sets GREENLIGHT status and commits to repo
- **File:** `.github/workflows/traffic-light-greenlight.yml`

#### 2. YellowLight Workflow
- **Trigger:** Pull request opened/updated
- **Action:** Sets YELLOWLIGHT status and adds PR comment
- **File:** `.github/workflows/traffic-light-yellowlight.yml`

#### 3. RedLight Workflow
- **Trigger:** Manual dispatch or critical issue labeled
- **Action:** Sets REDLIGHT status and blocks deployment
- **File:** `.github/workflows/traffic-light-redlight.yml`

### Manual Workflow Trigger

1. Go to **Actions** tab in GitHub
2. Select the appropriate workflow
3. Click **Run workflow**
4. Enter a message
5. Click **Run workflow** button

### Issue Templates

Create issues using traffic light templates:

- **GreenLight:** Deployment approval tracking
- **YellowLight:** Review and caution tracking
- **RedLight:** Blocking issue tracking

Templates are in `.github/ISSUE_TEMPLATE/`

## Status File Structure

The `status.json` file contains:

```json
{
  "status": "GREENLIGHT|YELLOWLIGHT|REDLIGHT",
  "message": "Human-readable status message",
  "timestamp": "ISO-8601 timestamp",
  "history": [
    {
      "from": "previous_status",
      "to": "new_status",
      "message": "change reason",
      "timestamp": "ISO-8601 timestamp"
    }
  ]
}
```

## Best Practices

### For Development Teams

1. **Start with YellowLight:** Default state for new PRs
2. **Require Reviews:** Use YellowLight until approvals received
3. **Automate GreenLight:** Set on successful CI/CD pipeline
4. **Manual RedLight:** Only set when critical issues found

### For CI/CD Integration

```bash
# In your CI/CD pipeline

# On test failure
if [ $TEST_RESULT -ne 0 ]; then
  ./blackroad-traffic-light.sh redlight --message "Tests failed"
  exit 1
fi

# On successful build and tests
./blackroad-traffic-light.sh greenlight --message "All checks passed"
```

### For Deployment Gates

```bash
# Check status before deployment
STATUS=$(./blackroad-traffic-light.sh status | grep "Status:" | awk '{print $3}')

if [ "$STATUS" == "REDLIGHT" ]; then
  echo "Deployment blocked by RedLight status"
  exit 1
fi

if [ "$STATUS" == "YELLOWLIGHT" ]; then
  echo "Warning: YellowLight - proceed with caution"
fi

# Continue with deployment
```

## Integration with BlackRoad Codex

The traffic light system integrates with BlackRoad Codex:

- Status changes logged in telemetry
- Agent coordination based on traffic light state
- Automated agent responses to state changes
- Deployment orchestration by Roadie agent

See [CODEX.md](CODEX.md) for more details.

## Troubleshooting

### Status not updating

```bash
# Check if system is initialized
ls -la .blackroad/traffic-light/

# Reinitialize if needed
./blackroad-traffic-light.sh init
```

### Workflow not triggering

1. Check workflow file exists in `.github/workflows/`
2. Verify workflow has correct triggers
3. Check GitHub Actions are enabled for repository
4. Review Actions logs for errors

### Permission issues

```bash
# Make script executable
chmod +x blackroad-traffic-light.sh

# Check file ownership
ls -la blackroad-traffic-light.sh
```

## Advanced Usage

### Custom States

Extend the script to add custom states:

1. Edit `blackroad-traffic-light.sh`
2. Add new state case in `set_status()` function
3. Define color and icon for new state
4. Create corresponding workflow file

### Webhook Integration

Send status changes to external services:

```bash
# Add to set_status() function
curl -X POST https://your-webhook.com/traffic-light \
  -H "Content-Type: application/json" \
  -d "{\"status\": \"$new_status\", \"message\": \"$message\"}"
```

### Multiple Environments

Track different environments:

```bash
# Create environment-specific status files
ENVIRONMENT=production ./blackroad-traffic-light.sh greenlight
ENVIRONMENT=staging ./blackroad-traffic-light.sh yellowlight
```

## Support

For issues or questions:
- Open an issue in the repository
- Tag relevant BlackRoad agents
- Check BlackRoad-OS documentation

---

**Part of the BlackRoad OS Ecosystem**
