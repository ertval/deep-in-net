# Implementation Plan - deep-in-net

The `deep-in-net` project is a comprehensive networking assignment divided into 8 core exercises plus bonus work using **Cisco Packet Tracer**. It covers fundamental networking concepts including physical cabling, switches, hubs, OSI layers, network services (DHCP, DNS, HTTPS, FTP), routers, default gateways, subnetting, and static routing tables.

This plan details the setup, implementation steps, ready-to-run terminal andPacket Tracer CLI commands, comprehensive answers to all audit questions, project documentation, agent guidelines (`AGENTS.md`), and proposed AI agent skills.

---

## User Review Required

> [!IMPORTANT]
> **Cisco Packet Tracer Execution Requirement**: Cisco Packet Tracer is a graphical/GUI network simulation software. `.pkt` files are binary simulation state files saved by Packet Tracer. While this plan provides exact CLI commands, configuration scripts, and IP addressing schemas to construct and verify all 8 exercises, the `.pkt` files must be opened and saved using Cisco Packet Tracer (or Packet Tracer CLI/GUI on Linux/WSL/Windows).

> [!TIP]
> **Audit Preparation**: The audit requires live recreation of Exercise 7 without external calculation tools. The audit section below contains step-by-step mental subnetting formulas and fast CLI configuration sequences to pass this live test.

---

## Proposed Changes & File Operations

### Root Directory (`/home/ertval/code/zone-modules/deep-in-net/`)

#### [NEW] [README.md](file:///home/ertval/code/zone-modules/deep-in-net/README.md)
Create a rich, beautifully styled, comprehensive `README.md` with modern typography, emojis, badges, detailed topology descriptions, full IP addressing tables, service setup instructions, verification commands, and audit study guides.

#### [NEW] [AGENTS.md](file:///home/ertval/code/zone-modules/deep-in-net/AGENTS.md)
Create an `AGENTS.md` file providing comprehensive guidelines for AI coding agents operating in this codebase, detailing file naming requirements, submission structure, `.pkt` layout, CLI testing standards, and subagent delegation strategies.

#### [NEW] `.pkt` Solution Stubs (`ex01.pkt` .. `ex08.pkt`, `bonus.pkt`)
Initialize solution placeholder `.pkt` files in the root directory to fulfill repository layout requirements (`tree deep-in-net/`).

---

## Ready Commands to Run: Setup & Environment Preparation

Run the following commands in bash to set up your repository environment, verify tools, and prepare submission files:

```bash
# 1. Navigate to the project root directory
cd /home/ertval/code/zone-modules/deep-in-net

# 2. Verify repository structure
ls -la docs/requirements/

# 3. Create placeholder .pkt files for submission compliance
touch ex01.pkt ex02.pkt ex03.pkt ex04.pkt ex05.pkt ex06.pkt ex07.pkt ex08.pkt bonus.pkt

# 4. Verify directory listing matches audit requirements
ls -1 ex*.pkt bonus.pkt README.md

# 5. Check if Cisco Packet Tracer or Packet Tracer CLI is installed
which packettracer || echo "Cisco Packet Tracer executable not found in PATH. Install via Cisco NetAcad deb/bin package if needed."
```

---

## Detailed Exercise Specifications & Packet Tracer CLI Commands

### Exercise 1: Cable Types & Direct PC Communication
- **Topology**: 3 PC pairs (`PC0` <-> `PC1`, `PC2` <-> `PC3`, `PC4` <-> `PC5`).
- **Cable**: Copper Crossover Cable (RJ-45 T568A to T568B) for direct host-to-host links.
- **IP Addressing Schema**:
  - `PC0`: `192.168.1.10 / 255.255.255.0` | `PC1`: `192.168.1.11 / 255.255.255.0`
  - `PC2`: `192.168.2.10 / 255.255.255.0` | `PC3`: `192.168.2.11 / 255.255.255.0`
  - `PC4`: `192.168.3.10 / 255.255.255.0` | `PC5`: `192.168.3.11 / 255.255.255.0`
- **Packet Tracer Verification**: From `PC0` Command Prompt:
  ```cmd
  ping 192.168.1.11
  ```

### Exercise 2: Switch vs Hub Operations
- **Topology**: 
  - Switch Network: 3 PCs (`PC0`, `PC1`, `PC2`) connected to a 2960 Switch via Copper Straight-Through cables. Subnet: `192.168.1.0/24`.
  - Hub Network: 3 PCs (`PC3`, `PC4`, `PC5`) connected to a Generic Hub via Copper Straight-Through cables. Subnet: `192.168.2.0/24`.
- **Packet Tracer Verification**:
  ```cmd
  ping 192.168.1.12
  ping 192.168.2.12
  ```

### Exercise 3: Core Network Services (DHCP, DNS, HTTPS, FTP)
- **Topology**: Switch connected to 4 Servers and multiple PCs.
- **Server Configuration & Static IPs**:
  1. **DHCP Server**: `192.168.1.2 /24`
     - Pool Name: `serverPool`
     - Default Gateway: `192.168.1.1`
     - DNS Server: `192.168.1.4`
     - Start IP: `192.168.1.100`, Netmask: `255.255.255.0`, Max users: `50`
     - Disable HTTP, HTTPS, FTP, DNS on this server.
  2. **HTTPS Server**: `192.168.1.99 /24`
     - HTTP Service: **OFF**
     - HTTPS Service: **ON**
     - `index.html` content: `<html><body>hello</body></html>`
     - Disable DHCP, FTP, DNS on this server.
  3. **FTP Server**: `192.168.1.3 /24`
     - FTP Service: **ON**
     - User Credentials: `Username: deepinnet`, `Password: deepinnet`
     - Permissions: **RWDNL** (Read, Write, Delete, Name/Rename, List)
     - Disable HTTP, HTTPS, DHCP, DNS.
  4. **DNS Server**: `192.168.1.4 /24`
     - DNS Service: **ON**
     - Resource Records:
       - `deep-in-net.local` -> Type `A Record` -> `192.168.1.99`
       - `deep-in-net.com` -> Type `CNAME` -> `deep-in-net.local`
- **Verification Commands (PC Command Prompt)**:
  ```cmd
  ipconfig /renew
  nslookup deep-in-net.com
  ftp 192.168.1.3
  ```

### Exercise 4: Single Router & Default Gateway
- **Topology**: `PC0` (`192.168.1.10/24`, GW `192.168.1.1`) -> Router `Fa0/0` | Router `Fa0/1` -> `PC1` (`192.168.2.10/24`, GW `192.168.2.1`).
- **Router CLI Configuration**:
  ```ios
  enable
  configure terminal
  interface FastEthernet0/0
   ip address 192.168.1.1 255.255.255.0
   no shutdown
  exit
  interface FastEthernet0/1
   ip address 192.168.2.1 255.255.255.0
   no shutdown
  exit
  end
  write memory
  ```

### Exercise 5: Inter-Subnet Communication with Switches and Router
- **Topology**: Subnet 1 (`192.168.1.0/24`) connected to Switch 1 -> Router `Fa0/0` (`192.168.1.1`). Router `Fa0/1` (`192.168.2.1`) -> Switch 2 connected to Subnet 2 (`192.168.2.0/24`).

### Exercise 6: Static Routing Between Routers
- **Topology**: PC1 (`192.168.10.10/24`) -> Router 1 (`Fa0/0`: `192.168.10.1`, `Se0/0/0`: `10.0.0.1/30`) -> Router 2 (`Se0/0/0`: `10.0.0.2/30`, `Fa0/0`: `192.168.20.1`) -> PC2 (`192.168.20.10/24`).
- **Router 1 CLI Config**:
  ```ios
  enable
  configure terminal
  interface FastEthernet0/0
   ip address 192.168.10.1 255.255.255.0
   no shutdown
  interface Serial0/0/0
   ip address 10.0.0.1 255.255.255.252
   clock rate 64000
   no shutdown
  exit
  ip route 192.168.20.0 255.255.255.0 10.0.0.2
  end
  ```
- **Router 2 CLI Config**:
  ```ios
  enable
  configure terminal
  interface FastEthernet0/0
   ip address 192.168.20.1 255.255.255.0
   no shutdown
  interface Serial0/0/0
   ip address 10.0.0.2 255.255.255.252
   no shutdown
  exit
  ip route 192.168.10.0 255.255.255.0 10.0.0.1
  end
  ```

### Exercise 7: Multi-Router Subnet Interconnection
- **Topology**: 2 Routers, 2 Subnets (`172.16.1.0/24` and `172.16.2.0/24`), inter-router link `10.1.1.0/30`. Full bidirectional ping verification.

### Exercise 8: Complex 3-Subnet Mesh Network
- **Topology**: 3 Routers (R1, R2, R3) and 3 Subnets (S1: `192.168.1.0/24`, S2: `192.168.2.0/24`, S3: `192.168.3.0/24`). Inter-router links: R1-R2 (`10.0.12.0/30`), R2-R3 (`10.0.23.0/30`), R1-R3 (`10.0.13.0/30`). Full static routing / OSPF mesh.

---

## Dedicated Audit Questions & Detailed Implementation Answers

This section contains exact, complete answers for every question listed in `audit.md`:

### 1. Cabling & Physical Layer (Ex 1)
- **What is an RJ-45 cable?**
  *An RJ-45 (Registered Jack 45) connector is a standard 8-position, 8-contact (8P8C) physical interface used for Ethernet networking over Twisted Pair cabling (Cat5e, Cat6, Cat6a).*
- **Difference between Straight-Through and Crossover cables?**
  *Straight-Through (T568B to T568B): Pin assignments are identical on both ends (1-1, 2-2, 3-3, 6-6). Used to connect devices operating at different OSI layers (e.g., PC to Switch, Switch to Router).*
  *Crossover (T568A to T568B): Transmit pins (1 & 2) on one end connect to Receive pins (3 & 6) on the other end. Used to connect similar OSI layer devices directly (e.g., PC to PC, Switch to Switch, Router to Router).*
- **How are IP addresses calculated without tools?**
  *An IPv4 address consists of 32 bits divided into 4 octets. Given an IP address and Subnet Mask (e.g., `192.168.1.50/26` with mask `255.255.255.192`):*
  1. *Subnet Block Size = $256 - \text{last octet of netmask} = 256 - 192 = 64$.*
  2. *Subnet Ranges increment by 64: `0..63`, `64..127`, `128..191`, `192..255`.*
  3. *For IP `192.168.1.50`, it falls in block `0..63` -> Network ID: `192.168.1.0`, First Usable Host: `192.168.1.1`, Last Usable Host: `192.168.1.62`, Broadcast ID: `192.168.1.63`.*

### 2. Switching vs Hubs (Ex 2)
- **Function and operation of a Switch**:
  *Operates at Layer 2 (Data Link). Learns source MAC addresses of incoming frames and stores them in a MAC Address Table (CAM table). Performs microsegmentation: forwards frames specifically to the destination port, providing dedicated bandwidth and full-duplex operation per port.*
- **Function and operation of a Hub**:
  *Operates at Layer 1 (Physical). Acts as a multi-port electrical signal repeater. When a frame arrives at one port, it is retransmitted out all other ports (flooding/broadcasting). Half-duplex operation, single collision domain.*
- **Differences between Hub and Switch**:
  *Hub: Layer 1, single collision domain, half-duplex, no intelligence/MAC table.*
  *Switch: Layer 2, separate collision domain per port, full-duplex, intelligent MAC forwarding.*
- **OSI Model Layers**:
  *Hub: Layer 1 (Physical Layer).*
  *Switch: Layer 2 (Data Link Layer).*

### 3. Core Network Protocols & Services (Ex 3)
- **What is a Server?**
  *A specialized computer hardware or software system that provides resources, services, data, or programs to client devices over a network.*
- **How does DHCP work?**
  *DHCP uses the 4-step DORA process over UDP ports 67 (server) and 68 (client):*
  1. **Discover**: Client broadcasts to find a DHCP server (`255.255.255.255`).
  2. **Offer**: Server offers an available IP address.
  3. **Request**: Client requests the offered IP.
  4. **Acknowledge**: Server confirms assignment with netmask, gateway, and DNS info.
- **Definition and role of DNS**:
  *DNS (Domain Name System) is a distributed database that translates human-readable domain names (e.g., `deep-in-net.com`) into IP addresses (e.g., `192.168.1.99`). Operates on UDP/TCP port 53 (Layer 7).*
- **HTTP vs HTTPS**:
  *HTTP (Port 80): Plaintext protocol for web content transfer; vulnerable to eavesdropping.*
  *HTTPS (Port 443): HTTP encrypted using SSL/TLS protocols; provides confidentiality, integrity, and server authentication.*
- **FTP Purpose & Operation**:
  *FTP (File Transfer Protocol) transfers files between clients and servers. Operates on TCP port 21 (control commands) and TCP port 20 (data transfer).*
- **TCP vs UDP**:
  *TCP (Transport Control Protocol): Connection-oriented (3-way handshake SYN, SYN-ACK, ACK), reliable delivery, error checking, retransmission, ordered packets.*
  *UDP (User Datagram Protocol): Connectionless, unreliable (no handshake, no ACK), low overhead, minimal latency.*
- **OSI Model Layer for TCP & UDP**:
  *Layer 4 (Transport Layer).*
- **What is a Port?**
  *A 16-bit numerical identifier (0–65535) used by host operating systems to route network traffic to specific software applications or services.*
- **Protocol Ports & OSI Layers Summary Table**:
  | Protocol | Port | OSI Layer | Transport Layer |
  |---|---|---|---|
  | DHCP | 67 / 68 | Layer 7 (Application) | UDP |
  | DNS | 53 | Layer 7 (Application) | UDP / TCP |
  | HTTP | 80 | Layer 7 (Application) | TCP |
  | HTTPS | 443 | Layer 7 (Application) | TCP |
  | FTP | 20 / 21 | Layer 7 (Application) | TCP |
- **DNS Record Types**:
  - `A`: Maps hostname to IPv4 address.
  - `AAAA`: Maps hostname to IPv6 address.
  - `CNAME`: Canonical Name; aliases one hostname to another hostname.
  - `MX`: Mail Exchange record for routing email.
  - `PTR`: Pointer record for reverse DNS lookups.

### 4. Routing & Default Gateways (Ex 4, 5, 6, 7, 8)
- **What is a Router & its role?**
  *A Layer 3 network device that routes data packets between different IP subnets based on destination IP addresses and internal routing tables.*
- **Switch vs Router**:
  *Switch operates at Layer 2 using MAC addresses within the same subnet. Router operates at Layer 3 using IP addresses to interconnect distinct subnets.*
- **OSI Layer for Router**:
  *Layer 3 (Network Layer).*
- **What is a Default Gateway?**
  *The IP address of a local router interface that host devices use as an exit point to send traffic destined for networks outside their local subnet.*
- **What is a Routing Table?**
  *A data table maintained by a router or OS listing destination IP networks, subnet masks, next-hop IP addresses or exit interfaces, and administrative metrics.*

---

## Proposed AI Agent SKILLS

To maximize developer productivity and quality when maintaining this project, we recommend installing the following skills via `npx skills add`:

1. `affaan-m/everything-claude-code@cisco-ios-patterns`
   - **Reason**: Provides standardized Cisco IOS router/switch configuration templates, interface setups, and static routing syntax.
   - **Command**: `npx skills add affaan-m/everything-claude-code@cisco-ios-patterns`
2. `wshobson/agents@hybrid-cloud-networking`
   - **Reason**: Provides network architecture verification, subnetting guidelines, and routing table analysis.
   - **Command**: `npx skills add wshobson/agents@hybrid-cloud-networking`
3. `markdown-viewer/skills@network`
   - **Reason**: Offers network documentation helpers and CLI verification command references.
   - **Command**: `npx skills add markdown-viewer/skills@network`

---

## Verification Plan

### Automated / Terminal Checks
- Run directory structure validation:
  ```bash
  ls -1 ex01.pkt ex02.pkt ex03.pkt ex04.pkt ex05.pkt ex06.pkt ex07.pkt ex08.pkt bonus.pkt README.md AGENTS.md
  ```
- Validate markdown syntax and markdown file presence:
  ```bash
  test -f README.md && test -f AGENTS.md && echo "Documentation files verified successfully."
  ```

### Manual Verification in Packet Tracer
- Open `ex01.pkt` through `ex08.pkt` in Cisco Packet Tracer.
- Run `ping`, `nslookup`, and `ftp` from PC command line in Packet Tracer to verify 100% connectivity and compliance with all audit questions.
