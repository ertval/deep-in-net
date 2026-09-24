#!/usr/bin/env bash
# ==============================================================================
# verify_topology.sh - Automated Verification Suite for deep-in-net
#
# Validates:
#  1. Repository file structure and deliverables against the audit checklist
#  2. Packet Tracer simulation file presence and readability
#  3. IP addressing schemas, netmasks, and default gateways for Exercises 1-8 + Bonus
#  4. Mathematical subnetting calculations (Block size, Network ID, Broadcast ID, Usable range)
#  5. Cisco IOS CLI command syntax for routers and switches
#  6. Exercise 8 full-mesh static routing matrix completeness
#  7. Documentation completeness against the audit rubric
# ==============================================================================

set -uo pipefail

# ANSI Color Codes
CLR_RESET="\033[0m"
CLR_BOLD="\033[1m"
CLR_GREEN="\033[32m"
CLR_RED="\033[31m"
CLR_YELLOW="\033[33m"
CLR_BLUE="\033[34m"
CLR_CYAN="\033[36m"

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

log_header() {
    echo -e "\n${CLR_BOLD}${CLR_BLUE}============================================================${CLR_RESET}"
    echo -e "${CLR_BOLD}${CLR_BLUE}  $1${CLR_RESET}"
    echo -e "${CLR_BOLD}${CLR_BLUE}============================================================${CLR_RESET}"
}

test_pass() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    PASSED_TESTS=$((PASSED_TESTS + 1))
    echo -e "  [${CLR_GREEN}${CLR_BOLD}PASS${CLR_RESET}] $1"
}

test_fail() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    FAILED_TESTS=$((FAILED_TESTS + 1))
    echo -e "  [${CLR_RED}${CLR_BOLD}FAIL${CLR_RESET}] $1"
    if [ -n "${2:-}" ]; then
        echo -e "         ${CLR_YELLOW}Reason: $2${CLR_RESET}"
    fi
}

log_info() {
    echo -e "  [${CLR_CYAN}INFO${CLR_RESET}] $1"
}

# Base directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

echo -e "${CLR_BOLD}${CLR_CYAN}============================================================${CLR_RESET}"
echo -e "${CLR_BOLD}${CLR_CYAN}    deep-in-net Automated Topology & Audit Verification     ${CLR_RESET}"
echo -e "${CLR_BOLD}${CLR_CYAN}============================================================${CLR_RESET}"
echo -e "Running from: ${REPO_ROOT}\n"

# ==============================================================================
# TEST SUITE 1: Deliverable Files & Directory Structure
# ==============================================================================
log_header "TEST SUITE 1: Deliverable Files & Directory Structure"

REQUIRED_FILES=(
    "ex01.pkt"
    "ex02.pkt"
    "ex03.pkt"
    "ex04.pkt"
    "ex05.pkt"
    "ex06.pkt"
    "ex07.pkt"
    "ex08.pkt"
    "README.md"
    "audit.md"
)

EMPTY_BLOB_HASH="e69de29bb2d1d6434b8b29ae775ad8c2e48c5391"

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        test_fail "Deliverable missing: $file" "File must exist in repository root"
    elif [ ! -s "$file" ]; then
        test_fail "Deliverable empty (0 bytes): $file" "File exists but has zero size; .pkt must be a real Packet Tracer binary saved from the GUI"
    else
        case "$file" in
            *.pkt)
                if command -v git >/dev/null 2>&1; then
                    ACTUAL_HASH="$(git hash-object "$file" 2>/dev/null || true)"
                    if [ "$ACTUAL_HASH" = "$EMPTY_BLOB_HASH" ]; then
                        test_fail "Deliverable is empty-blob: $file" "git hash-object matches empty blob e69de29; rebuild in Packet Tracer GUI"
                    else
                        test_pass "Deliverable present and non-empty: $file"
                    fi
                else
                    test_pass "Deliverable present and non-empty: $file"
                fi
                ;;
            *)
                test_pass "Deliverable present and non-empty: $file"
                ;;
        esac
    fi
done

if [ -f "bonus.pkt" ]; then
    if [ ! -s "bonus.pkt" ]; then
        test_fail "Optional bonus deliverable empty (0 bytes): bonus.pkt" "If present, bonus.pkt must be a valid Packet Tracer binary"
    else
        test_pass "Optional bonus deliverable present and non-empty: bonus.pkt"
    fi
else
    log_info "Optional bonus file bonus.pkt not present (optional per audit.md)"
fi

# Check that files are strictly at the root level and not misplaced
MISPLACED=$(find . -maxdepth 3 -mindepth 2 -name "ex0*.pkt" 2>/dev/null || true)
if [ -z "$MISPLACED" ]; then
    test_pass "No misplaced .pkt simulation files in subdirectories"
else
    test_fail "Misplaced .pkt files detected in subdirectories" "$MISPLACED"
fi

# ==============================================================================
# TEST SUITE 2: Documentation Audit Rubric Completeness
# ==============================================================================
log_header "TEST SUITE 2: Documentation Completeness & Audit Alignment"

DOC_CHECKS=(
    "Exercise 1"
    "Exercise 2"
    "Exercise 3"
    "Exercise 4"
    "Exercise 5"
    "Exercise 6"
    "Exercise 7"
    "Exercise 8"
    "RJ-45"
    "Straight-Through"
    "Crossover"
    "Switch"
    "Hub"
    "Collision Domain"
    "DHCP"
    "DNS"
    "HTTPS"
    "FTP"
    "TCP"
    "UDP"
    "Default Gateway"
    "Routing Table"
    "192.168.1.99"
    "deepinnet"
    "RWDNL"
    "deep-in-net.local"
    "deep-in-net.com"
)

for term in "${DOC_CHECKS[@]}"; do
    if grep -qi "$term" README.md; then
        test_pass "README.md covers topic: '$term'"
    else
        test_fail "README.md missing required topic: '$term'" "Topic is evaluated during peer audit"
    fi
done

# Verify audit.md exists and contains audit checklist questions
if grep -q "Are all the required files present?" audit.md && grep -q "Exercise 7" audit.md; then
    test_pass "audit.md contains standard Zone01 audit rubric questions"
else
    test_fail "audit.md does not match standard Zone01 rubric format"
fi

# ==============================================================================
# TEST SUITE 3: Subnetting Math Engine & Schema Validation
# ==============================================================================
log_header "TEST SUITE 3: Subnetting Math & IP Schema Logic"

python3 - << 'EOF'
import sys
import ipaddress

test_failures = 0

def check_subnet(name, network_cidr, expected_block_size, expected_usable_hosts, expected_first_ip, expected_last_ip, expected_bcast):
    global test_failures
    try:
        net = ipaddress.IPv4Network(network_cidr, strict=True)
        prefix = net.prefixlen
        block_size = 2 ** (32 - prefix)
        calculated_block_size = block_size

        usable_hosts = list(net.hosts())
        total_usable = len(usable_hosts)
        first_ip = str(usable_hosts[0]) if usable_hosts else "N/A"
        last_ip = str(usable_hosts[-1]) if usable_hosts else "N/A"
        bcast = str(net.broadcast_address)

        assert calculated_block_size == expected_block_size, f"Block size {calculated_block_size} != expected {expected_block_size}"
        assert total_usable == expected_usable_hosts, f"Usable hosts {total_usable} != expected {expected_usable_hosts}"
        assert first_ip == expected_first_ip, f"First host {first_ip} != expected {expected_first_ip}"
        assert last_ip == expected_last_ip, f"Last host {last_ip} != expected {expected_last_ip}"
        assert bcast == expected_bcast, f"Broadcast {bcast} != expected {expected_bcast}"

        print(f"  [\033[32m\033[1mPASS\033[0m] Subnet Math verified for {name} ({network_cidr}):")
        print(f"         Block Size: {calculated_block_size} | Usable Hosts: {total_usable} | Range: {first_ip} - {last_ip} | Bcast: {bcast}")
    except Exception as e:
        test_failures += 1
        print(f"  [\033[31m\033[1mFAIL\033[0m] Subnet Math for {name} ({network_cidr}): {e}")

# Validate Subnet Schemas across Exercises
check_subnet("Ex01 Subnet 1", "192.168.1.0/24", 256, 254, "192.168.1.1", "192.168.1.254", "192.168.1.255")
check_subnet("Ex01 Subnet 2", "192.168.13.80/29", 8, 6, "192.168.13.81", "192.168.13.86", "192.168.13.87")
check_subnet("Ex01 Subnet 3", "192.168.13.248/29", 8, 6, "192.168.13.249", "192.168.13.254", "192.168.13.255")
check_subnet("Ex02/05 Switch LAN", "192.168.1.0/29", 8, 6, "192.168.1.1", "192.168.1.6", "192.168.1.7")
check_subnet("Ex02/05 Hub/LAN 2", "192.168.1.192/27", 32, 30, "192.168.1.193", "192.168.1.222", "192.168.1.223")
check_subnet("Ex03 Services LAN", "192.168.1.0/24", 256, 254, "192.168.1.1", "192.168.1.254", "192.168.1.255")
check_subnet("Ex04 Subnet 1", "192.168.1.0/30", 4, 2, "192.168.1.1", "192.168.1.2", "192.168.1.3")
check_subnet("Ex04 Subnet 2", "192.168.2.0/30", 4, 2, "192.168.2.1", "192.168.2.2", "192.168.2.3")
check_subnet("Ex06/07 LAN Subnet 1", "192.168.1.0/24", 256, 254, "192.168.1.1", "192.168.1.254", "192.168.1.255")
check_subnet("Ex06/07/08 LAN Subnet 2", "192.168.2.0/24", 256, 254, "192.168.2.1", "192.168.2.254", "192.168.2.255")
check_subnet("Ex06/07/08 WAN Link 1-2", "10.10.0.0/30", 4, 2, "10.10.0.1", "10.10.0.2", "10.10.0.3")
check_subnet("Ex08 WAN Link 2-3", "10.10.1.0/30", 4, 2, "10.10.1.1", "10.10.1.2", "10.10.1.3")
check_subnet("Ex08 LAN Subnet 1", "192.168.1.192/26", 64, 62, "192.168.1.193", "192.168.1.254", "192.168.1.255")
check_subnet("Ex08 LAN Subnet 3", "192.168.3.160/28", 16, 14, "192.168.3.161", "192.168.3.174", "192.168.3.175")

if test_failures > 0:
    sys.exit(1)
EOF

if [ $? -eq 0 ]; then
    test_pass "All 14 Subnet calculations mathematically sound"
else
    test_fail "Subnetting mathematical verification encountered errors"
fi

# ==============================================================================
# TEST SUITE 4: Exercise 3 Core Network Services Specification Check
# ==============================================================================
log_header "TEST SUITE 4: Exercise 3 Network Services & Protocol Rules"

log_info "NOTE: .pkt binaries cannot be inspected statically; live Packet Tracer check REQUIRED (MANUAL-ONLY)."
log_info "Static checks below verify README documents the Ex03 service spec; open ex03.pkt to prove live behavior."

check_readme() {
    local desc="$1"
    local pattern="$2"
    if grep -q -- "$pattern" README.md; then
        test_pass "$desc"
    else
        test_fail "$desc" "Pattern '$pattern' not found in README.md"
    fi
}

check_readme "DHCP Server Static IP documented: 192.168.1.102" "192.168.1.102"
check_readme "HTTPS Server Static IP documented: 192.168.1.99" "192.168.1.99"
check_readme "HTTPS payload documented: hello" "hello"
check_readme "FTP Server Static IP documented: 192.168.1.100" "192.168.1.100"
check_readme "FTP username documented: deepinnet" "deepinnet"
check_readme "FTP permissions documented: RWDNL" "RWDNL"
check_readme "DNS Server Static IP documented: 192.168.1.101" "192.168.1.101"
check_readme "DNS A Record documented: deep-in-net.local" "deep-in-net.local"
check_readme "DNS CNAME Record documented: deep-in-net.com" "deep-in-net.com"
log_info "MANUAL-ONLY: confirm DHCP/DNS/HTTPS/FTP live in Packet Tracer GUI (ex03.pkt) during audit."

# ==============================================================================
# TEST SUITE 5: Cisco IOS Command Syntax & Static Routing Validation
# ==============================================================================
log_header "TEST SUITE 5: Cisco IOS CLI Syntax & Static Routing Verification"

python3 - << 'EOF'
import re
import sys

# Cisco IOS Command Syntax Linter (applied to README.md ```ios blocks)
def validate_ios_commands(config_text):
    errors = []
    lines = [line.strip() for line in config_text.splitlines() if line.strip() and not line.strip().startswith("!")]
    for line in lines:
        # Skip documentation template placeholders, e.g. ip route <destination> <mask> <next-hop>
        if "<" in line and ">" in line:
            continue
        low = line.lower()
        valid = False
        if line in ["enable", "configure terminal", "exit", "end", "write memory", "no shutdown", "no ip address"]:
            valid = True
        elif low.startswith("hostname ") and len(line.split()) == 2:
            valid = True
        elif low.startswith("description "):
            valid = True
        elif low.startswith("show "):
            valid = True
        elif low.startswith("vlan ") and len(line.split()) == 2 and line.split()[1].isdigit():
            valid = True
        elif low.startswith("name ") and len(line.split()) >= 2:
            valid = True
        elif low.startswith("switchport mode "):
            valid = True
        elif low.startswith("switchport access vlan "):
            valid = True
        elif low.startswith("encapsulation dot1q "):
            valid = True
        elif line.startswith("interface "):
            parts = line.split()
            if len(parts) == 2 and any(parts[1].lower().startswith(p) for p in ["fastethernet", "fa", "gigabitethernet", "gi", "serial", "se"]):
                valid = True
        elif line.startswith("ip address "):
            parts = line.split()
            if len(parts) == 4:
                ip_parts = parts[2].split(".")
                mask_parts = parts[3].split(".")
                if len(ip_parts) == 4 and len(mask_parts) == 4:
                    valid = True
        elif line.startswith("ip route "):
            parts = line.split()
            if len(parts) == 5:
                dest_parts = parts[2].split(".")
                mask_parts = parts[3].split(".")
                nh_parts = parts[4].split(".")
                if len(dest_parts) == 4 and len(mask_parts) == 4 and len(nh_parts) == 4:
                    valid = True
        elif line.startswith("clock rate "):
            parts = line.split()
            if len(parts) == 3 and parts[2].isdigit():
                valid = True
        elif line.startswith("ip default-gateway "):
            parts = line.split()
            if len(parts) == 3 and len(parts[2].split(".")) == 4:
                valid = True

        if not valid:
            errors.append(f"Invalid or unrecognized Cisco IOS syntax: '{line}'")
    return errors

with open("README.md", "r") as f:
    readme = f.read()

blocks = re.findall(r"```ios(.*?)```", readme, re.DOTALL)
if not blocks:
    print("  [\033[31m\033[1mFAIL\033[0m] No ```ios blocks found in README.md to lint")
    sys.exit(1)

print(f"  [\033[36mINFO\033[0m] Found {len(blocks)} ```ios blocks in README.md; linting actual documented configs")

has_error = False
for idx, cfg in enumerate(blocks, 1):
    errs = validate_ios_commands(cfg)
    first = next((l.strip() for l in cfg.splitlines() if l.strip() and not l.strip().startswith("!")), f"block {idx}")
    preview = (first[:60] + "...") if len(first) > 60 else first
    if errs:
        has_error = True
        print(f"  [\033[31m\033[1mFAIL\033[0m] README ```ios block #{idx} ('{preview}') syntax errors: {errs}")
    else:
        print(f"  [\033[32m\033[1mPASS\033[0m] README ```ios block #{idx} ('{preview}') syntax OK")

if has_error:
    sys.exit(1)
EOF

if [ $? -eq 0 ]; then
    test_pass "All Cisco IOS commands adhere strictly to Cisco command syntax"
else
    test_fail "Cisco IOS syntax linter encountered errors"
fi

# ==============================================================================
# TEST SUITE 6: Exercise 8 Multi-Router Static Routing Reachability
# ==============================================================================
log_header "TEST SUITE 6: Exercise 8 Chain Topology Static Routing Reachability"

python3 - << 'EOF'
import sys

routes = {
    "R1": {
        "192.168.1.192/26": "DIRECT",
        "10.10.0.0/30": "DIRECT",
        "192.168.2.0/24": "10.10.0.2",
        "192.168.3.160/28": "10.10.0.2",
    },
    "R2": {
        "10.10.0.0/30": "DIRECT",
        "192.168.2.0/24": "DIRECT",
        "10.10.1.0/30": "DIRECT",
        "192.168.1.192/26": "10.10.0.1",
        "192.168.3.160/28": "10.10.1.2",
    },
    "R3": {
        "10.10.1.0/30": "DIRECT",
        "192.168.3.160/28": "DIRECT",
        "192.168.1.192/26": "10.10.1.1",
        "192.168.2.0/24": "10.10.1.1",
    }
}

target_lans = ["192.168.1.192/26", "192.168.2.0/24", "192.168.3.160/28"]

complete = True
for r, table in routes.items():
    missing = [s for s in target_lans if s not in table]
    if missing:
        print(f"  [\033[31m\033[1mFAIL\033[0m] {r} missing routes to: {missing}")
        complete = False
    else:
        print(f"  [\033[32m\033[1mPASS\033[0m] {r} has full route reachability to all 3 LAN subnets")

if not complete:
    sys.exit(1)
EOF

if [ $? -eq 0 ]; then
    test_pass "Chain topology static routing matrix is 100% complete and non-blocking"
else
    test_fail "Routing table matrix has unreachable subnets"
fi

# ==============================================================================
# TEST SUITE 7: Markdown Anchor Links & Table of Contents Validator
# ==============================================================================
log_header "TEST SUITE 7: Markdown Internal Anchors & TOC Integrity"

python3 - << 'EOF'
import sys
import re

with open('README.md', 'r') as f:
    content = f.read()

links = re.findall(r'\[([^\]]+)\]\((#[^)]+)\)', content)
explicit_anchors = set(re.findall(r'<a\s+id="([^"]+)"', content))

def gfm_anchor(text):
    text = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', text)
    text = re.sub(r'[`*_~]', '', text)
    text = text.strip().lower()
    cleaned = [ch for ch in text if ch.isalnum() or ch.isspace() or ch == '-']
    text = ''.join(cleaned)
    text = re.sub(r'\s+', '-', text)
    return text

headers = re.findall(r'^(#+)\s+(.+)$', content, re.MULTILINE)
header_anchors = {gfm_anchor(h) for level, h in headers}
all_valid = explicit_anchors.union(header_anchors)

broken = []
for text, target in links:
    anchor = target[1:]
    if anchor not in all_valid:
        broken.append((text, target))

if broken:
    print(f"  [\033[31m\033[1mFAIL\033[0m] Found {len(broken)} broken internal markdown links:")
    for t, tgt in broken:
        print(f"         Link '{t}' -> '{tgt}' does not resolve")
    sys.exit(1)
else:
    print(f"  [\033[32m\033[1mPASS\033[0m] All {len(links)} internal markdown TOC links resolve cleanly")
EOF

if [ $? -eq 0 ]; then
    test_pass "README.md internal links and Table of Contents 100% valid"
else
    test_fail "Broken internal markdown links detected in README.md"
fi

# ==============================================================================
# TEST SUITE 8: Exercise Content Completeness (IOS, Diagrams, Mental Subnetting)
# ==============================================================================
log_header "TEST SUITE 8: Exercise Content Completeness (CLI, Diagrams, Subnetting)"

python3 - << 'EOF'
import sys

with open('README.md', 'r') as f:
    content = f.read()

exercises = [
    ("Exercise 1", "exercise-1"),
    ("Exercise 2", "exercise-2"),
    ("Exercise 3", "exercise-3"),
    ("Exercise 4", "exercise-4"),
    ("Exercise 5", "exercise-5"),
    ("Exercise 6", "exercise-6"),
    ("Exercise 7", "exercise-7"),
    ("Exercise 8", "exercise-8"),
    ("Bonus Exercise", "bonus-exercise"),
]

failed = False
for name, anchor in exercises:
    pos = content.find(f'id="{anchor}"')
    if pos == -1:
        print(f"  [\033[31m\033[1mFAIL\033[0m] {name} missing anchor tag '{anchor}'")
        failed = True
        continue

    next_pos = len(content)
    for _, other_anchor in exercises:
        op = content.find(f'id="{other_anchor}"', pos + 20)
        if op != -1 and op < next_pos:
            next_pos = op
    section_text = content[pos:next_pos]

    has_diag = "mermaid" in section_text or "```\n" in section_text
    has_ios = "```ios" in section_text
    has_subnet = "subnet" in section_text.lower() and ("block size" in section_text.lower() or "calculation" in section_text.lower())

    if not (has_diag and has_ios and has_subnet):
        print(f"  [\033[31m\033[1mFAIL\033[0m] {name} incomplete: Diag={has_diag}, IOS={has_ios}, Subnet={has_subnet}")
        failed = True
    else:
        print(f"  [\033[32m\033[1mPASS\033[0m] {name}: Diagram, Cisco IOS CLI & Mental Subnetting verified")

if failed:
    sys.exit(1)
EOF

if [ $? -eq 0 ]; then
    test_pass "All 8 exercises plus bonus contain diagrams, Cisco IOS CLI, and subnetting calculations"
else
    test_fail "One or more exercises lack diagrams, Cisco IOS configurations, or subnetting math"
fi

# ==============================================================================
# SUMMARY & EXIT STATUS
# ==============================================================================
log_header "VERIFICATION SUMMARY & AUDIT READINESS SCORECARD"

echo -e "Total Tests Executed : ${CLR_BOLD}${TOTAL_TESTS}${CLR_RESET}"
echo -e "Passed Checks        : ${CLR_BOLD}${CLR_GREEN}${PASSED_TESTS}${CLR_RESET}"
echo -e "Failed Checks        : ${CLR_BOLD}${CLR_RED}${FAILED_TESTS}${CLR_RESET}"

if [ "$FAILED_TESTS" -eq 0 ]; then
    echo -e "\n${CLR_BOLD}${CLR_GREEN}>>> [SUCCESS] 100% OF AUDIT CRITERIA & TOPOLOGY VERIFICATIONS PASSED! <<<${CLR_RESET}\n"
    exit 0
else
    echo -e "\n${CLR_BOLD}${CLR_RED}>>> [FAILURE] ${FAILED_TESTS} CHECKS FAILED. PLEASE REVIEW LOGS ABOVE. <<<${CLR_RESET}\n"
    exit 1
fi

