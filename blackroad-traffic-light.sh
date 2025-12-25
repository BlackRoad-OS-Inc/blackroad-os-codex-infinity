#!/bin/bash
# BlackRoad Traffic Light System
# GreenLight/YellowLight/RedLight deployment gates and approvals
# Version: 1.0.0

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Traffic light states
GREENLIGHT="🟢 GREENLIGHT"
YELLOWLIGHT="🟡 YELLOWLIGHT"
REDLIGHT="🔴 REDLIGHT"

# Function to display usage
usage() {
    echo "BlackRoad Traffic Light System"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  check          Check current deployment status"
    echo "  greenlight     Mark deployment as approved (ready to deploy)"
    echo "  yellowlight    Mark deployment as warning (needs review)"
    echo "  redlight       Mark deployment as blocked (do not deploy)"
    echo "  status         Show current traffic light status"
    echo "  init           Initialize traffic light system"
    echo ""
    echo "Options:"
    echo "  --message MSG  Add a message to the traffic light status"
    echo "  --force        Force the status change"
    echo ""
    exit 1
}

# Function to initialize traffic light system
init_traffic_light() {
    echo "Initializing BlackRoad Traffic Light System..."
    
    # Create traffic light directory
    mkdir -p .blackroad/traffic-light
    
    # Create initial status file
    cat > .blackroad/traffic-light/status.json <<EOF
{
  "status": "YELLOWLIGHT",
  "message": "Traffic light system initialized",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "history": []
}
EOF
    
    echo -e "${YELLOW}${YELLOWLIGHT}${NC} Traffic light system initialized"
    echo "Status file created at: .blackroad/traffic-light/status.json"
}

# Function to get current status
get_status() {
    if [ ! -f .blackroad/traffic-light/status.json ]; then
        echo "UNKNOWN"
        return 1
    fi
    
    # Extract status from JSON file
    if command -v jq &> /dev/null; then
        jq -r '.status' .blackroad/traffic-light/status.json
    else
        # Fallback if jq is not available
        grep -o '"status"[[:space:]]*:[[:space:]]*"[^"]*"' .blackroad/traffic-light/status.json | cut -d'"' -f4
    fi
}

# Function to set traffic light status
set_status() {
    local new_status=$1
    local message=$2
    local color=$NC
    local icon=""
    
    # Determine color and icon
    case $new_status in
        GREENLIGHT)
            color=$GREEN
            icon="🟢"
            ;;
        YELLOWLIGHT)
            color=$YELLOW
            icon="🟡"
            ;;
        REDLIGHT)
            color=$RED
            icon="🔴"
            ;;
    esac
    
    # Get old status for history
    local old_status=$(get_status 2>/dev/null || echo "UNKNOWN")
    
    # Update status file
    if command -v jq &> /dev/null; then
        # Use jq for proper JSON manipulation
        local temp_file=$(mktemp)
        jq --arg status "$new_status" \
           --arg message "$message" \
           --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
           --arg old_status "$old_status" \
           '.status = $status | .message = $message | .timestamp = $timestamp | .history += [{"from": $old_status, "to": $status, "message": $message, "timestamp": $timestamp}]' \
           .blackroad/traffic-light/status.json > "$temp_file"
        mv "$temp_file" .blackroad/traffic-light/status.json
    else
        # Fallback without jq
        cat > .blackroad/traffic-light/status.json <<EOF
{
  "status": "$new_status",
  "message": "$message",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "history": []
}
EOF
    fi
    
    echo -e "${color}${icon} ${new_status}${NC}: $message"
}

# Function to display status
display_status() {
    if [ ! -f .blackroad/traffic-light/status.json ]; then
        echo "Traffic light system not initialized. Run: $0 init"
        return 1
    fi
    
    local status=$(get_status)
    local color=$NC
    local icon=""
    
    case $status in
        GREENLIGHT)
            color=$GREEN
            icon="🟢"
            ;;
        YELLOWLIGHT)
            color=$YELLOW
            icon="🟡"
            ;;
        REDLIGHT)
            color=$RED
            icon="🔴"
            ;;
    esac
    
    echo ""
    echo "=========================================="
    echo "  BlackRoad Traffic Light Status"
    echo "=========================================="
    echo ""
    
    if command -v jq &> /dev/null; then
        local message=$(jq -r '.message' .blackroad/traffic-light/status.json)
        local timestamp=$(jq -r '.timestamp' .blackroad/traffic-light/status.json)
        echo -e "Status:    ${color}${icon} ${status}${NC}"
        echo "Message:   $message"
        echo "Updated:   $timestamp"
    else
        echo -e "Status:    ${color}${icon} ${status}${NC}"
    fi
    
    echo ""
    echo "=========================================="
}

# Main script logic
main() {
    local command=${1:-status}
    local message=""
    local force=false
    
    # Parse options
    shift || true
    while [[ $# -gt 0 ]]; do
        case $1 in
            --message)
                message="$2"
                shift 2
                ;;
            --force)
                force=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
    done
    
    # Execute command
    case $command in
        init)
            init_traffic_light
            ;;
        greenlight)
            [ -z "$message" ] && message="Deployment approved - ready to go!"
            set_status "GREENLIGHT" "$message"
            ;;
        yellowlight)
            [ -z "$message" ] && message="Deployment needs review - proceed with caution"
            set_status "YELLOWLIGHT" "$message"
            ;;
        redlight)
            [ -z "$message" ] && message="Deployment blocked - do not proceed"
            set_status "REDLIGHT" "$message"
            ;;
        status|check)
            display_status
            ;;
        *)
            echo "Unknown command: $command"
            usage
            ;;
    esac
}

# Initialize if not already done
if [ ! -d .blackroad/traffic-light ] && [ "${1:-}" != "init" ]; then
    init_traffic_light
    echo ""
fi

# Run main function
main "$@"
