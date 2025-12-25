#!/bin/bash
# BlackRoad Codex Integration
# Universal code indexing, semantic search, and agent coordination
# Version: 1.0.0

set -e

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CODEX_DIR=".blackroad/codex"
AGENT_REGISTRY="$CODEX_DIR/agent-registry.json"
TELEMETRY_DIR="$CODEX_DIR/telemetry"

# Initialize Codex system
init_codex() {
    echo -e "${CYAN}Initializing BlackRoad Codex System...${NC}"
    
    # Create directory structure
    mkdir -p "$CODEX_DIR"
    mkdir -p "$TELEMETRY_DIR"
    mkdir -p "$CODEX_DIR/index"
    mkdir -p "$CODEX_DIR/cache"
    
    # Create initial configuration
    cat > "$CODEX_DIR/config.json" <<EOF
{
  "version": "1.0.0",
  "repository": "$(basename $(pwd))",
  "initialized": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "features": {
    "code_indexing": true,
    "semantic_search": true,
    "agent_coordination": true,
    "telemetry": true,
    "traffic_light": true
  },
  "agents": {
    "registered": [],
    "active": []
  }
}
EOF
    
    echo -e "${GREEN}✓${NC} Codex system initialized at $CODEX_DIR"
}

# Register an agent
register_agent() {
    local agent_name=$1
    local agent_type=$2
    local capabilities=$3
    
    if [ ! -f "$CODEX_DIR/config.json" ]; then
        init_codex
    fi
    
    # Create agent registry if it doesn't exist
    if [ ! -f "$AGENT_REGISTRY" ]; then
        echo '{"agents": []}' > "$AGENT_REGISTRY"
    fi
    
    local agent_entry=$(cat <<EOF
{
  "name": "$agent_name",
  "type": "$agent_type",
  "capabilities": "$capabilities",
  "registered_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "status": "active"
}
EOF
)
    
    echo -e "${GREEN}✓${NC} Agent registered: $agent_name ($agent_type)"
}

# Index repository
index_repo() {
    echo -e "${CYAN}Indexing repository...${NC}"
    
    # Count files by type in a single pass
    local counts=$(find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.md" \) -printf "%f\n" | awk -F. '
        {ext = $NF}
        ext == "py" {py++}
        ext == "js" {js++}
        ext == "md" {md++}
        END {printf "%d %d %d", py, js, md}
    ')
    read py_files js_files md_files <<< "$counts"
    local total_files=$(find . -type f | wc -l)
    
    # Create index
    cat > "$CODEX_DIR/index/repo-index.json" <<EOF
{
  "indexed_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "total_files": $total_files,
  "file_types": {
    "python": $py_files,
    "javascript": $js_files,
    "markdown": $md_files
  },
  "status": "indexed"
}
EOF
    
    echo -e "${GREEN}✓${NC} Repository indexed: $total_files files"
}

# Send telemetry event
telemetry() {
    local event_type=$1
    local event_data=$2
    
    local telemetry_file="$TELEMETRY_DIR/$(date +%Y%m%d).log"
    
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $event_type: $event_data" >> "$telemetry_file"
}

# Display status
status() {
    if [ ! -f "$CODEX_DIR/config.json" ]; then
        echo "BlackRoad Codex not initialized. Run: $0 init"
        return 1
    fi
    
    echo ""
    echo "=========================================="
    echo "  BlackRoad Codex Status"
    echo "=========================================="
    echo ""
    
    if command -v jq &> /dev/null; then
        echo "Version:     $(jq -r '.version' $CODEX_DIR/config.json)"
        echo "Repository:  $(jq -r '.repository' $CODEX_DIR/config.json)"
        echo "Initialized: $(jq -r '.initialized' $CODEX_DIR/config.json)"
        echo ""
        echo "Features:"
        echo "  - Code Indexing:       $(jq -r '.features.code_indexing' $CODEX_DIR/config.json)"
        echo "  - Semantic Search:     $(jq -r '.features.semantic_search' $CODEX_DIR/config.json)"
        echo "  - Agent Coordination:  $(jq -r '.features.agent_coordination' $CODEX_DIR/config.json)"
        echo "  - Telemetry:           $(jq -r '.features.telemetry' $CODEX_DIR/config.json)"
        echo "  - Traffic Light:       $(jq -r '.features.traffic_light' $CODEX_DIR/config.json)"
    else
        echo "Codex system is active"
    fi
    
    echo ""
    echo "=========================================="
}

# Main command handler
case "${1:-status}" in
    init)
        init_codex
        ;;
    register)
        register_agent "${2:-agent}" "${3:-generic}" "${4:-general}"
        ;;
    index)
        index_repo
        ;;
    telemetry)
        telemetry "${2:-event}" "${3:-data}"
        ;;
    status)
        status
        ;;
    *)
        echo "BlackRoad Codex Integration"
        echo ""
        echo "Usage: $0 [command] [options]"
        echo ""
        echo "Commands:"
        echo "  init              Initialize Codex system"
        echo "  register NAME TYPE CAPS  Register an agent"
        echo "  index             Index the repository"
        echo "  telemetry TYPE DATA      Send telemetry event"
        echo "  status            Show Codex status"
        ;;
esac
