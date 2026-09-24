# AGENTS.md - Coding Agent Guidelines for deep-in-net

This document provides clear operational rules, architectural guidelines, directory conventions, and verification workflows for AI coding agents operating within the `deep-in-net` repository.

---

## 🤖 Agent Role & Principles

When working on this repository, all AI agents must adhere to the following principles:

1. **Strict Submission Compliance**:
   - The root directory must contain exact `.pkt` solution files (`ex01.pkt` through `ex08.pkt`, optional `bonus.pkt`) and `README.md`.
   - Never move `.pkt` files into subdirectories (e.g. `src/` or `dist/`); the audit script checks root via `ls` / `tree deep-in-net/`.

2. **Source of Truth Requirements**:
   - Primary subject requirements reside in [docs/requirements/readme.md](file:///home/ertval/code/zone-modules/deep-in-net/docs/requirements/readme.md).
   - Audit requirements reside in [docs/requirements/audit.md](file:///home/ertval/code/zone-modules/deep-in-net/docs/requirements/audit.md).

3. **Empirical Verification**:
   - Verify file layouts and Markdown syntax using shell tools.
   - Verify network configuration settings against the exercise schemas.

---

## 📁 Repository Layout & File Standard

```console
deep-in-net/
├── ex01.pkt      # Exercise 1: Crossover Cable Host-to-Host Links
├── ex02.pkt      # Exercise 2: Switch vs Hub Collision Domain Topologies
├── ex03.pkt      # Exercise 3: Core Network Services (DHCP, DNS, HTTPS, FTP)
├── ex04.pkt      # Exercise 4: Single Router & Default Gateway Topology
├── ex05.pkt      # Exercise 5: Multi-Switch Subnet Routing
├── ex06.pkt      # Exercise 6: Multi-Router Static Routing Tables
├── ex07.pkt      # Exercise 7: Dual-Router Subnet Interconnection
├── ex08.pkt      # Exercise 8: 3-Subnet Full Mesh Static Routing Topology
├── bonus.pkt             # Optional Bonus Topology
├── README.md             # Public Documentation & Audit Reference
├── audit.md              # Official Evaluator Audit Checklist
├── verify_topology.sh    # Automated Verification & Subnetting Validation Script
├── AGENTS.md             # Agent Operational Guidelines (this document)
└── docs/
    └── requirements/
        ├── readme.md  # Subject Specifications
        └── audit.md   # Evaluator Audit Checklist
```

---

## ⚙️ Exercise Network Specifications

| Exercise | Topology Focus | Key Configuration Details |
|---|---|---|
| **Ex 01** | Direct PC Links | Copper Crossover Cable (T568A-T568B). Pair 1 (`192.168.1.0/24`), Pair 2 (`192.168.13.80/29`), Pair 3 (`192.168.13.248/29`). |
| **Ex 02** | Switch vs Hub | Switch Star (`192.168.1.0/29`, S-PC5 `192.168.1.5`) vs Hub Star (`192.168.1.192/27`, H-PC1 `192.168.1.193`). Straight-through cables. |
| **Ex 03** | Core Services | HTTPS (`192.168.1.99` display `"hello"`), FTP (`192.168.1.100`, user `deepinnet` with RWDNL), DNS (`192.168.1.101`, `deep-in-net.com` CNAME to `deep-in-net.local` -> `192.168.1.99`), DHCP (`192.168.1.102` pool start `192.168.1.10`). |
| **Ex 04** | Single Router | Subnet 1 (`192.168.1.0/30`), Subnet 2 (`192.168.2.0/30`). Gateway IPs on Router interfaces (`192.168.1.1`, `192.168.2.1`). |
| **Ex 05** | Multi-Switch Router | Switch 0 (`192.168.1.0/29`, GW `192.168.1.6`) + Switch 1 (`192.168.1.192/27`, GW `192.168.1.194`) connected via 2911 Router. |
| **Ex 06** | Static Routing | R1 <-> R2 over `10.10.0.0/30` serial link. Static routes: `192.168.2.0/24` via `10.10.0.2` and `192.168.1.0/24` via `10.10.0.1`. |
| **Ex 07** | Inter-Router Link | Live audit recreation task. R0 (`192.168.1.1`), R1 (`192.168.2.1`), WAN serial `10.10.0.0/30`. |
| **Ex 08** | 3-Subnet Chain | R1-R2-R3 chain. LAN 1 (`192.168.1.192/26`), WAN 1-2 (`10.10.0.0/30`), LAN 2 (`192.168.2.0/24`), WAN 2-3 (`10.10.1.0/30`), LAN 3 (`192.168.3.160/28`). |

---

## 🛠️ Verification & Test Commands

Agents should execute the following terminal checks to validate workspace integrity:

```bash
# 1. Run automated test suite
./verify_topology.sh

# 2. Check root files exist
ls -1 ex01.pkt ex02.pkt ex03.pkt ex04.pkt ex05.pkt ex06.pkt ex07.pkt ex08.pkt README.md audit.md verify_topology.sh AGENTS.md

# 3. Validate documentation file links and syntax
test -f README.md && test -f AGENTS.md && test -f audit.md && test -f docs/requirements/readme.md && test -f docs/requirements/audit.md
```

---

## 🔌 Recommended Agent Skills

For automated Cisco CLI generation and network topology analysis, agents should install:
```bash
npx skills add affaan-m/everything-claude-code@cisco-ios-patterns
npx skills add wshobson/agents@hybrid-cloud-networking
npx skills add markdown-viewer/skills@network
```
