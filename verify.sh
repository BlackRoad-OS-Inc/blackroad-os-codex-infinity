#!/bin/bash
# BlackRoad OS Codex Infinity - Verification Script
# Tests all installed components

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo "🧪 Running BlackRoad System Verification..."
echo ""

PASS=0
FAIL=0

# Test function
test_component() {
    local name=$1
    local command=$2
    
    echo -n "Testing $name... "
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAIL++))
        return 1
    fi
}

# Test traffic light script exists and is executable
test_component "Traffic Light Script Exists" "[ -x ./blackroad-traffic-light.sh ]"

# Test codex script exists and is executable
test_component "Codex Script Exists" "[ -x ./blackroad-codex-integration.sh ]"

# Test setup script exists and is executable
test_component "Setup Script Exists" "[ -x ./setup.sh ]"

# Test .blackroad directory structure
test_component "BlackRoad Directory Structure" "[ -d .blackroad/traffic-light ] && [ -d .blackroad/codex ]"

# Test traffic light status file
test_component "Traffic Light Status File" "[ -f .blackroad/traffic-light/status.json ]"

# Test codex config file
test_component "Codex Config File" "[ -f .blackroad/codex/config.json ]"

# Test agent config file
test_component "Agent Config File" "[ -f .blackroad/agent-config.yml ]"

# Test GitHub workflows directory
test_component "GitHub Workflows Directory" "[ -d .github/workflows ]"

# Test workflow files
test_component "GreenLight Workflow" "[ -f .github/workflows/traffic-light-greenlight.yml ]"
test_component "YellowLight Workflow" "[ -f .github/workflows/traffic-light-yellowlight.yml ]"
test_component "RedLight Workflow" "[ -f .github/workflows/traffic-light-redlight.yml ]"

# Test issue templates
test_component "Issue Templates Directory" "[ -d .github/ISSUE_TEMPLATE ]"
test_component "GreenLight Issue Template" "[ -f .github/ISSUE_TEMPLATE/greenlight.md ]"
test_component "YellowLight Issue Template" "[ -f .github/ISSUE_TEMPLATE/yellowlight.md ]"
test_component "RedLight Issue Template" "[ -f .github/ISSUE_TEMPLATE/redlight.md ]"

# Test PR template
test_component "PR Template" "[ -f .github/PULL_REQUEST_TEMPLATE/pull_request_template.md ]"

# Test documentation files
test_component "Traffic Light Documentation" "[ -f TRAFFIC_LIGHT.md ]"
test_component "Codex Documentation" "[ -f CODEX.md ]"
test_component "Quick Start Guide" "[ -f QUICKSTART.md ]"
test_component "Agent Manifest" "[ -f AGENTS.md ]"
test_component "Updated README" "grep -q 'Traffic Light System' README.md"

# Test traffic light command execution
test_component "Traffic Light Status Command" "./blackroad-traffic-light.sh status"

# Test codex command execution
test_component "Codex Status Command" "./blackroad-codex-integration.sh status"

# Test gitignore
test_component "GitIgnore File" "[ -f .gitignore ]"

# Summary
echo ""
echo "========================================"
echo "  Verification Results"
echo "========================================"
echo ""
echo -e "Tests Passed: ${GREEN}$PASS${NC}"
echo -e "Tests Failed: ${RED}$FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo ""
    echo "System is ready to use. Run './setup.sh' if you haven't already."
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some tests failed!${NC}"
    echo ""
    echo "Please check the failed components and run './setup.sh' to fix."
    echo ""
    exit 1
fi
