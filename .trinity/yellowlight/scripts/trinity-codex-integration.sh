#!/bin/bash
# Trinity → BlackRoad Codex Integration
# Integrates Light Trinity standards into the Codex verification system

set -e

CODEX_DB="$HOME/.blackroad/codex/codex.db"

# Ensure Codex database exists
if [ ! -f "$CODEX_DB" ]; then
    echo "❌ BlackRoad Codex database not found"
    echo "Run: ~/blackroad-codex-verification-suite.sh init"
    exit 1
fi

echo "🚦 Integrating Light Trinity into BlackRoad Codex..."

# Add Trinity standards to Codex
sqlite3 "$CODEX_DB" <<'SQL'
-- Trinity Standards Table
CREATE TABLE IF NOT EXISTS trinity_standards (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    light_type TEXT NOT NULL CHECK(light_type IN ('greenlight', 'yellowlight', 'redlight')),
    category TEXT NOT NULL,
    standard_name TEXT NOT NULL,
    requirement TEXT NOT NULL,
    test_command TEXT,
    failure_severity TEXT CHECK(failure_severity IN ('critical', 'high', 'medium', 'low')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trinity Compliance Table
CREATE TABLE IF NOT EXISTS trinity_compliance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL, -- 'template', 'deployment', 'task'
    entity_name TEXT NOT NULL,
    greenlight_pass BOOLEAN DEFAULT 0,
    yellowlight_pass BOOLEAN DEFAULT 0,
    redlight_pass BOOLEAN DEFAULT 0,
    compliance_status TEXT CHECK(compliance_status IN ('pending', 'partial', 'full', 'failed')),
    last_checked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Trinity Test Results
CREATE TABLE IF NOT EXISTS trinity_test_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_name TEXT NOT NULL,
    light_type TEXT NOT NULL,
    test_name TEXT NOT NULL,
    passed BOOLEAN NOT NULL,
    details TEXT,
    tested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert RedLight Standards
INSERT OR IGNORE INTO trinity_standards (light_type, category, standard_name, requirement, test_command, failure_severity)
VALUES
    ('redlight', 'brand', 'Color Palette', 'Must use BlackRoad gradient: #FF9D00→#0066FF', 'rl_test_passed "$name" "visual" "Brand colors"', 'critical'),
    ('redlight', 'performance', 'FPS Target', 'Must achieve >30 FPS (excellent: >60)', 'rl_performance_metrics "$name" "$fps" "$load" "$mem"', 'high'),
    ('redlight', 'performance', 'Load Time', 'Must load in <3s (excellent: <1s)', 'rl_performance_metrics "$name" "$fps" "$load" "$mem"', 'high'),
    ('redlight', 'accessibility', 'WCAG Compliance', 'Must meet WCAG 2.1 AA standards', 'rl_test_passed "$name" "accessibility" "WCAG 2.1 AA"', 'critical'),
    ('redlight', 'architecture', 'Self-Contained', 'Single HTML or minimal dependencies', 'rl_template_create "$name" "$cat" "$desc"', 'medium'),
    ('redlight', 'deployment', 'Deploy-Ready', 'Works on Cloudflare Pages/GitHub Pages', 'rl_template_deploy "$name" "$url" "$platform"', 'high');

-- Insert YellowLight Standards
INSERT OR IGNORE INTO trinity_standards (light_type, category, standard_name, requirement, test_command, failure_severity)
VALUES
    ('yellowlight', 'platform', 'Approved Platform', 'Must use approved platform (Cloudflare/Railway/Pi/DO)', 'yl_deployment_succeeded "$svc" "$platform" "$url"', 'critical'),
    ('yellowlight', 'monitoring', 'Health Endpoint', 'Must have /health or /status endpoint', 'yl_health_check "$svc" "$url" "$time"', 'critical'),
    ('yellowlight', 'reliability', 'Rollback Capability', 'Must support version rollback', 'yl_deployment_rollback "$svc" "$from" "$to"', 'high'),
    ('yellowlight', 'automation', 'CI/CD Pipeline', 'Must have automated deployment', 'yl_workflow_done "$repo" "passed" "$duration"', 'medium'),
    ('yellowlight', 'security', 'Secrets Management', 'No secrets in code, must use vault', 'yl_secret_stored "$name" "$vault"', 'critical'),
    ('yellowlight', 'logging', 'Memory Logging', 'All deployments logged to PS-SHA∞', 'yl_deployment_succeeded "$svc" "$platform" "$url"', 'high');

-- Insert GreenLight Standards
INSERT OR IGNORE INTO trinity_standards (light_type, category, standard_name, requirement, test_command, failure_severity)
VALUES
    ('greenlight', 'tracking', 'State Tracking', 'All work tracked in GreenLight', 'gl_wip "$task" "$status"', 'critical'),
    ('greenlight', 'events', 'NATS Publishing', 'State changes publish to NATS', 'N/A', 'high'),
    ('greenlight', 'phases', 'Phase Completion', 'All projects have phase tracking', 'gl_phase_done "$phase" "$proj" "$summary"', 'medium'),
    ('greenlight', 'coordination', 'Cross-Agent', 'Agent coordination logged', 'gl_coordinate "$from" "$to" "$msg"', 'medium'),
    ('greenlight', 'memory', 'PS-SHA∞ Logging', 'All actions logged to memory', 'N/A', 'critical');

SQL

echo "✅ Trinity standards added to Codex"

# Create Trinity compliance checker
cat > "$HOME/trinity-check-compliance.sh" <<'CHECKER'
#!/bin/bash
# Check Trinity compliance for an entity

ENTITY_NAME="$1"
ENTITY_TYPE="${2:-template}"

if [ -z "$ENTITY_NAME" ]; then
    echo "Usage: $0 <entity_name> [entity_type]"
    exit 1
fi

CODEX_DB="$HOME/.blackroad/codex/codex.db"

echo "🚦 Checking Trinity compliance for: $ENTITY_NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check each Light
for light in greenlight yellowlight redlight; do
    echo ""
    case "$light" in
        greenlight) emoji="🟢" ;;
        yellowlight) emoji="🟡" ;;
        redlight) emoji="🔴" ;;
    esac
    
    echo "$emoji ${light^^} Standards:"
    
    sqlite3 "$CODEX_DB" <<SQL
SELECT 
    '  ' || CASE WHEN passed THEN '✅' ELSE '❌' END || ' ' || 
    test_name || ': ' || 
    COALESCE(details, 'No details')
FROM trinity_test_results
WHERE entity_name = '$ENTITY_NAME' 
  AND light_type = '$light'
ORDER BY tested_at DESC;
SQL
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Overall compliance
sqlite3 "$CODEX_DB" <<SQL
SELECT 
    CASE 
        WHEN greenlight_pass AND yellowlight_pass AND redlight_pass THEN '✅ FULL COMPLIANCE'
        WHEN greenlight_pass OR yellowlight_pass OR redlight_pass THEN '⚠️ PARTIAL COMPLIANCE'
        ELSE '❌ NON-COMPLIANT'
    END || 
    ' (🟢: ' || CASE WHEN greenlight_pass THEN 'PASS' ELSE 'FAIL' END || 
    ', 🟡: ' || CASE WHEN yellowlight_pass THEN 'PASS' ELSE 'FAIL' END ||
    ', 🔴: ' || CASE WHEN redlight_pass THEN 'PASS' ELSE 'FAIL' END || ')'
FROM trinity_compliance
WHERE entity_name = '$ENTITY_NAME'
ORDER BY last_checked DESC
LIMIT 1;
SQL

CHECKER

chmod +x "$HOME/trinity-check-compliance.sh"

echo "✅ Created Trinity compliance checker: ~/trinity-check-compliance.sh"

# Create Trinity test recorder
cat > "$HOME/trinity-record-test.sh" <<'RECORDER'
#!/bin/bash
# Record a Trinity test result

ENTITY_NAME="$1"
LIGHT_TYPE="$2"     # greenlight, yellowlight, redlight
TEST_NAME="$3"
PASSED="$4"         # 0 or 1
DETAILS="${5:-}"

if [ -z "$PASSED" ]; then
    echo "Usage: $0 <entity_name> <light_type> <test_name> <passed:0/1> [details]"
    exit 1
fi

CODEX_DB="$HOME/.blackroad/codex/codex.db"

# Record test result
sqlite3 "$CODEX_DB" <<SQL
INSERT INTO trinity_test_results (entity_name, light_type, test_name, passed, details)
VALUES ('$ENTITY_NAME', '$LIGHT_TYPE', '$TEST_NAME', $PASSED, '$DETAILS');
SQL

# Update compliance table
sqlite3 "$CODEX_DB" <<SQL
INSERT OR REPLACE INTO trinity_compliance (entity_type, entity_name, greenlight_pass, yellowlight_pass, redlight_pass, compliance_status)
SELECT 
    'template',
    '$ENTITY_NAME',
    MAX(CASE WHEN light_type = 'greenlight' AND passed = 1 THEN 1 ELSE 0 END),
    MAX(CASE WHEN light_type = 'yellowlight' AND passed = 1 THEN 1 ELSE 0 END),
    MAX(CASE WHEN light_type = 'redlight' AND passed = 1 THEN 1 ELSE 0 END),
    CASE 
        WHEN SUM(CASE WHEN passed = 1 THEN 1 ELSE 0 END) = COUNT(DISTINCT light_type) THEN 'full'
        WHEN SUM(CASE WHEN passed = 1 THEN 1 ELSE 0 END) > 0 THEN 'partial'
        ELSE 'failed'
    END
FROM trinity_test_results
WHERE entity_name = '$ENTITY_NAME';
SQL

echo "✅ Recorded: $TEST_NAME for $ENTITY_NAME ($LIGHT_TYPE) → $([ "$PASSED" = "1" ] && echo 'PASS' || echo 'FAIL')"

RECORDER

chmod +x "$HOME/trinity-record-test.sh"

echo "✅ Created Trinity test recorder: ~/trinity-record-test.sh"

# Update memory (if available)
if [ -f ".trinity/greenlight/scripts/memory-greenlight-templates.sh" ]; then
    source .trinity/greenlight/scripts/memory-greenlight-templates.sh
    gl_phase_done "integration" "Trinity Codex Integration" \
        "Integrated Light Trinity standards into BlackRoad Codex: 3 new tables (trinity_standards, trinity_compliance, trinity_test_results), 16 standards defined (6 RedLight, 6 YellowLight, 5 GreenLight), 2 compliance tools created (~/.trinity/system/trinity-check-compliance.sh, ~/.trinity/system/trinity-record-test.sh). All future work validated against Trinity gates via Codex." \
        "🌌"
fi

echo ""
echo "🚦 Trinity → Codex Integration Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Tables created:"
echo "  • trinity_standards (16 standards)"
echo "  • trinity_compliance (entity tracking)"
echo "  • trinity_test_results (test history)"
echo ""
echo "Tools created:"
echo "  • ~/trinity-check-compliance.sh <entity_name>"
echo "  • ~/trinity-record-test.sh <entity> <light> <test> <pass:0/1>"
echo ""
echo "Usage:"
echo "  ~/trinity-record-test.sh 'blackroad-mars' 'redlight' 'Brand Colors' 1 'Gradient validated'"
echo "  ~/trinity-check-compliance.sh 'blackroad-mars'"
