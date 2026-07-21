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
├── bonus.pkt     # Optional Bonus Topology
├── README.md     # Public Documentation & Audit Reference
├── AGENTS.md     # Agent Operational Guidelines (this document)
└── docs/
    └── requirements/
        ├── readme.md  # Subject Specifications
        └── audit.md   # Evaluator Audit Checklist
```

---

## ⚙️ Exercise Network Specifications

| Exercise | Topology Focus | Key Configuration Details |
|---|---|---|
| **Ex 01** | Direct PC Links | Copper Crossover Cable (T568A-T568B). `PC0` (`192.168.1.10`), `PC1` (`192.168.1.11`). |
| **Ex 02** | Switch vs Hub | Switch (`192.168.1.0/24`) vs Hub (`192.168.2.0/24`). Straight-through cables. |
| **Ex 03** | Core Services | DHCP (`192.168.1.2`), HTTPS (`192.168.1.99` display `"hello"`), FTP (`192.168.1.3`, user `deepinnet` with RWDNL), DNS (`192.168.1.4`, `deep-in-net.com` CNAME to `deep-in-net.local` -> `192.168.1.99`). |
| **Ex 04** | Single Router | Subnet 1 (`192.168.1.0/24`), Subnet 2 (`192.168.2.0/24`). Gateway IPs on Router interfaces. |
| **Ex 05** | Multi-Switch Router | Switch 1 + Switch 2 connected via Router interfaces. |
| **Ex 06** | Static Routing | R1 <-> R2 over `10.0.0.0/30`. `ip route 192.168.20.0 255.255.255.0 10.0.0.2` on R1. |
| **Ex 07** | Inter-Router Link | Live audit recreation task. R1 (`172.16.1.1`), R2 (`172.16.2.1`). |
| **Ex 08** | 3-Subnet Mesh | R1, R2, R3 interconnected. Static routes for all remote subnets. |

---

## 🛠️ Verification & Test Commands

Agents should execute the following terminal checks to validate workspace integrity:

```bash
# 1. Check root files exist
ls -1 ex01.pkt ex02.pkt ex03.pkt ex04.pkt ex05.pkt ex06.pkt ex07.pkt ex08.pkt bonus.pkt README.md AGENTS.md

# 2. Validate documentation file links and syntax
test -f README.md && test -f AGENTS.md && test -f docs/requirements/readme.md && test -f docs/requirements/audit.md
```

---

## 🔌 Recommended Agent Skills

For automated Cisco CLI generation and network topology analysis, agents should install:
```bash
npx skills add affaan-m/everything-claude-code@cisco-ios-patterns
npx skills add wshobson/agents@hybrid-cloud-networking
npx skills add markdown-viewer/skills@network
```
