# 🛡️ deep-in-net Master Audit Defense & Examination Guide

![Cisco Packet Tracer](https://img.shields.io/badge/Cisco_Packet_Tracer-v8.x-005073?style=for-the-badge&logo=cisco&logoColor=white)
![Networking](https://img.shields.io/badge/Domain-Networking%20%26%20DevOps-008080?style=for-the-badge&logo=diagramsdotnet)
![OSI Model](https://img.shields.io/badge/Framework-OSI%207--Layer%20Model-4B0082?style=for-the-badge)
![Audit Status](https://img.shields.io/badge/Audit-100%25%20Defense%20Ready-brightgreen?style=for-the-badge)
![Live Exam](https://img.shields.io/badge/5--Minute%20Speedrun-Zero%20External%20Tools-orange?style=for-the-badge)

Welcome to the definitive **deep-in-net Master Audit Defense Guide**. This guide is prepared as an exhaustive, rigorous, and pedagogical companion for Zone01 / 42-Network peer evaluations. It mirrors the exact structure and chronological order of `audit.md`.

For every question and requirement in the audit, this document provides:
1. **The Exact Examiner Question** (quoted directly from `audit.md`).
2. **The Authoritative Model Answer** (technically complete, concise, and structured).
3. **Real-World Intuitive Analogies** (memorable pedagogical explanations).
4. **Packet Tracer & Cisco IOS CLI Commands** (exact commands to demonstrate and verify live).
5. **Expected Output** (exact output as displayed in terminal/command prompt).

---

## 📑 Table of Contents

1. [Executive Defense Strategy & Audit Rules](#1-executive-defense-strategy--audit-rules)
2. [Rapid-Reference Cheat Sheet (Ports, Layers, Mental Subnetting, CLI)](#2-rapid-reference-cheat-sheet)
3. [General Repository Deliverables Defense](#3-general-repository-deliverables-defense)
4. [Exercise 1: Crossover Cable Host-to-Host Links](#4-exercise-1-crossover-cable-host-to-host-links)
5. [Exercise 2: Switch vs Hub Collision Domain Topologies](#5-exercise-2-switch-vs-hub-collision-domain-topologies)
6. [Exercise 3: Core Network Services (DHCP, DNS, HTTPS, FTP)](#6-exercise-3-core-network-services-dhcp-dns-https-ftp)
7. [Exercise 4: Single Router & Default Gateway Topology](#7-exercise-4-single-router--default-gateway-topology)
8. [Exercise 5: Multi-Switch Subnet Routing](#8-exercise-5-multi-switch-subnet-routing)
9. [Exercise 6: Multi-Router Static Routing Tables](#9-exercise-6-multi-router-static-routing-tables)
10. [Exercise 7: Dual-Router Subnet Interconnection & 5-Minute Live Exam Speed-Run](#10-exercise-7-dual-router-subnet-interconnection--5-minute-live-exam-speed-run)
11. [Exercise 8: 3-Subnet Chain Static Routing Architecture](#11-exercise-8-3-subnet-chain-static-routing-architecture)
12. [Documentation Check Defense](#12-documentation-check-defense)
13. [Bonus Defense: IEEE 802.1Q Router-on-a-Stick Inter-VLAN Routing](#13-bonus-defense-ieee-8021q-router-on-a-stick-inter-vlan-routing)
14. [Auditor Trap Questions & Edge-Case Encyclopedia](#14-auditor-trap-questions--edge-case-encyclopedia)

---

## 1. Executive Defense Strategy & Audit Rules

### The Zone01 Peer Audit Dynamic
In the Zone01 peer audit model, you are evaluated by fellow students following `audit.md`. The evaluation tests:
- **Conceptual Depth**: Can you explain *why* something works rather than just following steps?
- **Mental Agility**: Can you calculate subnets, block sizes, and host ranges mentally on the spot without opening a calculator?
- **Speed & Precision Under Pressure**: In Exercise 7, the auditor will ask you to delete the topology and rebuild it live from scratch without external notes or tools.

### Key Rules of Engagement
- **Answer Confidently and Concisely**: State the technical definition first, follow with the underlying mechanism, and reinforce with a real-world analogy.
- **Always Verify via CLI**: Do not just show green arrows in the Packet Tracer GUI. Use `ping`, `traceroute`, `arp -a`, `ipconfig /all`, `show ip route`, and `show mac address-table` to prove connectivity at Layer 2 and Layer 3.
- **Spanning Tree Trick (Fast Forward Time)**: When connecting switches, ports stay amber for 30–50 seconds due to 802.1D Spanning Tree Protocol listening and learning states. Click the **Fast Forward Time** button (`>>`) or press **Alt + D** twice to transition ports to forwarding (green) immediately.
- **Never Enter the System Configuration Dialog**: When booting a Cisco router in CLI, always type `no` when prompted with `Continue with configuration dialog? [yes/no]:`.

---

## 2. Rapid-Reference Cheat Sheet

### Protocol, Port, Transport, and OSI Layer Summary
| Protocol | Full Name | Transport | Port | OSI Layer | Role in deep-in-net |
|:---|:---|:---:|:---:|:---:|:---|
| **DHCP** | Dynamic Host Configuration Protocol | UDP | 67 (Server), 68 (Client) | Layer 7 (Application) | Dynamically leases IP, netmask, gateway, DNS (`192.168.1.102`) |
| **DNS** | Domain Name System | UDP / TCP | 53 | Layer 7 (Application) | Resolves hostnames to IP addresses (`192.168.1.101`) |
| **HTTP** | Hypertext Transfer Protocol | TCP | 80 | Layer 7 (Application) | Unencrypted web service (Disabled in Ex03) |
| **HTTPS** | HTTP Secure (SSL/TLS) | TCP | 443 | Layer 7 (Application) | Encrypted web service (`192.168.1.99`, displays "hello") |
| **FTP** | File Transfer Protocol | TCP | 21 (Control), 20 (Data) | Layer 7 (Application) | Authenticated file transfer (`192.168.1.100`, user `deepinnet` / `RWDNL`) |
| **ICMP** | Internet Control Message Protocol | IP (Proto 1) | N/A | Layer 3 (Network) | Diagnostic echo requests and replies (`ping`) |
| **ARP** | Address Resolution Protocol | Ethernet | N/A | Layer 2 (Data Link) | Resolves Layer 3 IPv4 to Layer 2 MAC addresses |

### Subnetting Quick Reference
$$\text{Block Size (Magic Number)} = 256 - \text{Interesting Octet Netmask}$$
$$\text{Usable Hosts} = 2^{(32 - \text{CIDR Prefix})} - 2 = 2^h - 2$$

| Prefix | Subnet Mask | 4th Octet | Block Size | Total IPs | Usable Hosts ($2^h - 2$) | Project Use Case |
|:---:|:---|:---:|:---:|:---:|:---:|:---|
| **/24** | `255.255.255.0` | 0 | $256 - 0 = 256$ | 256 | **254** | Ex 01 Pair 1, Ex 03, Ex 06/07/08 LANs |
| **/26** | `255.255.255.192` | 192 | $256 - 192 = 64$ | 64 | **62** | Ex 08 LAN 1 (`192.168.1.192/26`) |
| **/27** | `255.255.255.224` | 224 | $256 - 224 = 32$ | 32 | **30** | Ex 02 Hub LAN, Ex 05 LAN 2 (`192.168.1.192/27`) |
| **/28** | `255.255.255.240` | 240 | $256 - 240 = 16$ | 16 | **14** | Ex 08 LAN 3 (`192.168.3.160/28`) |
| **/29** | `255.255.255.248` | 248 | $256 - 248 = 8$ | 8 | **6** | Ex 01 Pairs 2 & 3, Ex 02 Switch LAN, Ex 05 LAN 1 |
| **/30** | `255.255.255.252` | 252 | $256 - 252 = 4$ | 4 | **2** | Ex 04 Router Links, Ex 06/07/08 WAN Serial Links |

### Cisco IOS CLI Command Quick Reference
```ios
enable                          ! Enter Privileged EXEC mode
configure terminal              ! Enter Global Configuration mode
hostname <name>                 ! Set hostname
interface <type><number>        ! Enter Interface Configuration mode
 ip address <ip> <mask>         ! Assign IP and subnet mask
 clock rate 64000               ! Set clock speed on DCE serial interfaces
 no shutdown                    ! Administratively enable interface
exit                            ! Exit interface mode
ip route <net> <mask> <next-hop>! Add static route to routing table
end                             ! Return to Privileged EXEC mode
write memory                    ! Save running-config to NVRAM (startup-config)
show ip interface brief         ! Display status and IPs of all interfaces
show ip route                   ! Display active routing table
show mac address-table          ! Display switch CAM table
show controllers <interface>    ! Verify DCE vs DTE cable status
```

---

## 3. General Repository Deliverables Defense

### Examiner Question
> **"Are all the required files present?"**

#### Model Answer
"Yes, all mandatory deliverables are present directly in the repository root directory as mandated by the project rubric:
- **8 Mandatory Simulation Files**: `ex01.pkt`, `ex02.pkt`, `ex03.pkt`, `ex04.pkt`, `ex05.pkt`, `ex06.pkt`, `ex07.pkt`, `ex08.pkt`.
- **Mandatory Documentation**: `README.md` (comprehensive technical documentation covering architectures, addressing schemas, Cisco IOS CLI configs, and audit Q&A).
- **Official Audit Checklist**: `audit.md`.

All files reside strictly in the root directory without nesting inside subdirectories. `bonus.pkt` is optional per the official audit rubric."

#### Verification Commands (Bash)
```bash
ls -1 ex*.pkt README.md audit.md
```

---

## 4. Exercise 1: Crossover Cable Host-to-Host Links

### Topology Summary
Three independent direct host-to-host PC pairs connected with **Copper Cross-Over** cables respecting the exact subject screenshot labels:
- **Pair 1 (`192.168.1.0/24`)**: `PC0` (`192.168.1.3/24`) $\leftrightarrow$ `PC1` (`192.168.1.4/24`)
- **Pair 2 (`192.168.13.80/29`)**: `PC2` (`192.168.13.81/29`) $\leftrightarrow$ `PC3` (`192.168.13.82/29`)
- **Pair 3 (`192.168.13.248/29`)**: `PC4` (`192.168.13.254/29`) $\leftrightarrow$ `PC5` (`192.168.13.249/29`)

---

### Examiner Question 1.1
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**

#### Model Answer
"Yes. There are six PC endpoints grouped into three independent pairs. Each pair is connected directly with a green dashed Copper Cross-Over cable. Each pair occupies a distinct subnet matching the subject screenshot labels:
- Pair 1 on `192.168.1.0/24` with mask `255.255.255.0` (`PC0` = `.3`, `PC1` = `.4`).
- Pair 2 on `192.168.13.80/29` with mask `255.255.255.248` (`PC2` = `.81`, `PC3` = `.82`).
- Pair 3 on `192.168.13.248/29` with mask `255.255.255.248` (`PC4` = `.254`, `PC5` = `.249`).
No default gateway is configured or needed because all communication is strictly point-to-point within each local subnet."

---

### Examiner Question 1.2
> **"Can you confirm that the communications mentioned above are established?"**

#### Model Answer
"Yes, confirmed. Direct point-to-point ICMP communication is active between each paired PC:
- `PC0` pings `PC1` (`192.168.1.4`) successfully with 0% packet loss.
- `PC2` pings `PC3` (`192.168.13.82`) successfully with 0% packet loss.
- `PC4` pings `PC5` (`192.168.13.249`) successfully with 0% packet loss.
Cross-pair communication (e.g. `PC0` to `PC2`) fails by design because each pair resides on an isolated IP subnet with no router interconnecting them."

#### Verification Commands (PC Command Prompt)
```cmd
! On PC0:
ping 192.168.1.4

! On PC2:
ping 192.168.13.82

! On PC4:
ping 192.168.13.249
```

---

### Examiner Question 1.3
> **"What is a RJ-45 cable?"**

#### Model Answer
"An **RJ-45** cable is an unshielded or shielded twisted-pair copper Ethernet cable (Category 5e, 6, or 6a) terminated at both ends with an **8P8C (8 Position, 8 Contact)** modular connector defined by the Registered Jack 45 standard.
- **Physical Composition**: Contains **8 color-coded copper conductors** twisted into **4 pairs** (Orange, Green, Blue, Brown).
- **Differential Signaling & Noise Rejection**: Ethernet transmits data using differential voltage pairs (TX+ and TX-). The physical twisting of wire pairs cancels out external electromagnetic interference (EMI) and adjacent-pair crosstalk, allowing clean transmission up to 100 meters."

#### Real-World Analogy
Think of an RJ-45 cable as a noise-canceling dual-wire intercom. If you send positive voltage down one wire and equal negative voltage down the other, any ambient radio noise outside the cable adds equal noise to both wires. At the receiving end, the computer subtracts the two signals; the noise cancels out to zero, leaving a pristine data signal.

---

### Examiner Question 1.4
> **"What is difference between straight through and crossover RJ-45 cables?"**

#### Model Answer
"The difference lies in how the 8 internal copper pins are mapped from **Connector End A** to **Connector End B** according to the **TIA/EIA-568A** and **TIA/EIA-568B** wiring standards:
1. **Straight-Through Cable (T568B to T568B)**:
   - Wired identically on both ends (Pin 1 to 1, Pin 2 to 2, Pin 3 to 3, Pin 6 to 6).
   - Used to connect devices operating at **different OSI tiers** (MDI to MDI-X devices), such as a PC or Router to a Switch.
2. **Crossover Cable (T568A to T568B)**:
   - The transmit pair on End A connects to the receive pair on End B:
     - Pin 1 (TX+) $\rightarrow$ Pin 3 (RX+)
     - Pin 2 (TX-) $\rightarrow$ Pin 6 (RX-)
     - Pin 3 (RX+) $\rightarrow$ Pin 1 (TX+)
     - Pin 6 (RX-) $\rightarrow$ Pin 2 (TX-)
   - Connects **like devices** directly without an intermediate switch: PC to PC (Exercise 1), Switch to Switch, Router to Router (FastEthernet), or Router to PC."

#### Real-World Analogy
Two tin-can telephones. Handset A has a Mouthpiece (Transmit) and Earpiece (Receive). Handset B also has a Mouthpiece and Earpiece. If you connect Mouthpiece to Mouthpiece (Straight-Through), neither party hears anything. A crossover cable crosses Handset A's mouthpiece to Handset B's earpiece so both can converse simultaneously.

---

### Examiner Question 1.5
> **"How are the IP addresses calculated?"**

#### Model Answer
"IP addresses are calculated using the 4-step mental subnetting method without software tools:
1. **Understand Address Anatomy**: An IPv4 address is 32 bits divided into four 8-bit octets.
2. **Calculate Block Size (Magic Number)**:
   $$\text{Block Size} = 256 - \text{Netmask Octet}$$
   - For `/24` (`255.255.255.0`): $256 - 0 = 256$. Range: `192.168.1.1` to `.254`.
   - For `/29` (`255.255.255.248`): $256 - 248 = 8$.
3. **Determine Subnet Boundaries for `/29`**:
   - For Pair 2 (`192.168.13.80/29`): Multiples of 8 contain $80$. Network ID is `192.168.13.80`. Next network is $88$, so Broadcast ID is `192.168.13.87`.
   - Usable host range is `192.168.13.81` to `192.168.13.86` ($2^3 - 2 = 6$ hosts). `PC2` (`.81`) and `PC3` (`.82`) sit inside this valid range.
   - For Pair 3 (`192.168.13.248/29`): Network ID is `192.168.13.248`, Broadcast ID is `192.168.13.255`. Usable range is `192.168.13.249` to `192.168.13.254`. `PC4` (`.254`) and `PC5` (`.249`) sit inside this range."

---

## 5. Exercise 2: Switch vs Hub Collision Domain Topologies

### Topology Summary
Two separate star topologies contrasting Layer 2 switching against Layer 1 hub signal repeating:
- **Switch Subnet (`192.168.1.0/29`)**: Cisco 2960-24TT Switch connecting 5 PCs (`S-PC1` to `S-PC5`). `S-PC5` is `192.168.1.5/29`.
- **Hub Subnet (`192.168.1.192/27`)**: Generic Hub-PT connecting 5 PCs (`H-PC1` to `H-PC5`). `H-PC1` is `192.168.1.193/27`.

---

### Examiner Question 2.1
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**

#### Model Answer
"Yes. The topology features one Cisco 2960 Switch connecting 5 PCs on `192.168.1.0/29` (mask `255.255.255.248`) via Copper Straight-Through cables, and one Generic Hub connecting 5 PCs on `192.168.1.192/27` (mask `255.255.255.224`) via Copper Straight-Through cables. The two topologies are not cabled together."

---

### Examiner Question 2.2 & 2.3
> **"Does all computers connected to the Switch must be connected?"**
> **"Does all computers connected to the Hub must be connected?"**

#### Model Answer
"Yes. All PCs connected to the Switch communicate with each other (`S-PC1` through `S-PC5`), and all PCs connected to the Hub communicate with each other (`H-PC1` through `H-PC5`).
Their physical transmission behavior differs fundamentally:
- The Switch microsegments traffic into dedicated, collision-free full-duplex links.
- The Hub broadcasts electrical signals to every port in a shared half-duplex collision domain."

#### Verification Commands
```cmd
! On S-PC2 (Switch LAN):
ping 192.168.1.4
ping 192.168.1.5

! On H-PC1 (Hub LAN):
ping 192.168.1.194
ping 192.168.1.197
```

---

### Examiner Question 2.4
> **"What is the function of a `switch`, how does it operate and what is its role in networking?"**

#### Model Answer
"A **Switch** is an active Layer 2 (Data Link layer) device designed to forward Ethernet frames intelligently within a local network.
- **How It Operates (The CAM Table)**:
  1. **Learning**: Extracts the **Source MAC address** from incoming frames and records it in its **MAC Address Table (CAM Table)** with the ingress port.
  2. **Forwarding (Unicast)**: Checks the **Destination MAC address**. If found in the table, it switches the frame **only to that specific egress port**.
  3. **Flooding**: If destination MAC is unknown or broadcast (`FF:FF:FF:FF:FF:FF`), it floods the frame to all active ports except the ingress port.
  4. **Filtering**: If destination and source reside on the same port, the frame is dropped.
- **Role**: Eliminates collisions by providing a **dedicated collision domain per port** operating in **Full Duplex** mode."

#### Real-World Analogy
A switch is like a **private corporate mailroom clerk**. When an envelope arrives marked for 'Jane in Accounting, Office 204', the clerk checks the directory, walks straight to Office 204, and hands Jane her letter. Nobody else is interrupted.

---

### Examiner Question 2.5
> **"What is the function of a `hub`, how does it operate and what is its role in networking?"**

#### Model Answer
"A **Hub** is an unmanaged Layer 1 (Physical layer) multiport electrical repeater.
- **How It Operates**: Has no memory, processor, or MAC address table. When electrical voltage pulses enter any single port, the hub amplifies and blindly repeats those signals out of **every other port simultaneously**.
- **Collision Domain**: All attached devices belong to a **single shared collision domain**.
- **Duplex Mode**: Operates in **Half-Duplex** using **CSMA/CD** (Carrier Sense Multiple Access with Collision Detection). If two devices transmit at the exact same instant, a collision occurs, corrupting data and triggering randomized backoff timers."

#### Real-World Analogy
A hub is like a **person shouting through a megaphone in a crowded hall**. When Alice speaks to Bob, the hub broadcasts her voice at top volume across the entire room. Everyone hears it.

---

### Examiner Question 2.6 & 2.7
> **"What are the differences between a `hub` and a `switch`?"**
> **"Can you identify the `OSI model layer` that the `switch` and the `hub` operate on?"**

#### Model Answer
- **Hub**: Operates at **Layer 1 (Physical Layer)**. It repeats raw electrical bits without inspecting frames or MAC addresses.
- **Switch**: Operates at **Layer 2 (Data Link Layer)**. It evaluates 48-bit hardware MAC addresses, verifies frame check sequences (CRC/FCS), and forwards frames intelligently.

| Feature | Hub 📻 | Switch 🔀 |
|---|---|---|
| **OSI Layer** | **Layer 1** (Physical) | **Layer 2** (Data Link) |
| **Addressing** | None | 48-bit Hardware **MAC Addresses** |
| **Collision Domains** | **1 shared** across all ports | **Separate collision domain per port** |
| **Duplex Mode** | Half-Duplex (CSMA/CD required) | Full-Duplex (Simultaneous send & receive) |

---

## 6. Exercise 3: Core Network Services (DHCP, DNS, HTTPS, FTP)

### Topology Summary
An enterprise LAN (`192.168.1.0/24`) connected to a Cisco 2950-24 Switch hosting four dedicated servers and 6 PCs:
- **HTTPS Server**: `192.168.1.99` (HTTPS ON, HTTP OFF, payload `"hello"`)
- **FTP Server**: `192.168.1.100` (User: `deepinnet`, Pass: `deepinnet`, Permissions: `RWDNL`)
- **DNS Server**: `192.168.1.101` (`deep-in-net.local` $\rightarrow$ `192.168.1.99`, `deep-in-net.com` $\rightarrow$ `deep-in-net.local`)
- **DHCP Server**: `192.168.1.102` (Pool: `serverPool`, Gateway: `0.0.0.0`, DNS: `192.168.1.101`, Start: `192.168.1.10`, Max: 50)

---

### Examiner Question 3.1, 3.2, & 3.3
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**
> **"Can you confirm that all `servers` have static IP addresses?"**
> **"Do all servers only provide the service specified for them?"**

#### Model Answer
"Yes. All four servers and the switch are properly cabled using Copper Straight-Through cables on subnet `192.168.1.0/24` with mask `255.255.255.0`.
In the Desktop $\rightarrow$ IP Configuration panel of each server, the configuration is explicitly set to **Static**:
- HTTPS: `192.168.1.99`
- FTP: `192.168.1.100`
- DNS: `192.168.1.101`
- DHCP: `192.168.1.102`
Strict service isolation (least privilege) is enforced:
- HTTPS Server: Only HTTPS is ON. HTTP is explicitly OFF. DHCP, FTP, DNS are OFF.
- FTP Server: Only FTP is ON. All others OFF.
- DNS Server: Only DNS is ON. All others OFF.
- DHCP Server: Only DHCP is ON. All others OFF."

---

### Examiner Question 3.4
> **"Is the `DHCP server` responsible for assigning the IP addresses to all PCs?"**

#### Model Answer
"Yes. All client PCs (`PC0` through `PC5`) have their IP configuration set to **DHCP**. Each client broadcasts a DHCP Discover request and receives an IP in the `192.168.1.10+` range, subnet mask `255.255.255.0`, and DNS server `192.168.1.101`."

#### Verification Commands (PC Command Prompt)
```cmd
ipconfig /renew
ipconfig /all
```

---

### Examiner Question 3.5 & 3.6 (HTTPS, FTP, DNS Verification)
> **"Can you connect to the `HTTPS Server` from any PC in the network?"**
> **"Does the `HTTPS Server` shows a 'hello' message and is the `HTTP` disabled?"**
> **"Does a 'deepinnet' user with `RWDNL` access exists in the `FTP server`?"**
> **"Does 'https://deep-in-net.com' redirects to the `HTTPS Server`?"**

#### Verification Demonstration
1. **HTTPS & DNS Check**:
   - Open PC Desktop $\rightarrow$ Web Browser.
   - Enter `https://deep-in-net.com` $\rightarrow$ Resolves via DNS (`deep-in-net.com` CNAME $\rightarrow$ `deep-in-net.local` $\rightarrow$ `192.168.1.99`) and displays the hello page.
   - Enter `http://192.168.1.99` $\rightarrow$ Connection timeout / refused (HTTP disabled).
2. **FTP Authentication Check**:
   - From PC Command Prompt:
     ```cmd
     ftp 192.168.1.100
     ```
   - Enter username `deepinnet`, password `deepinnet` $\rightarrow$ Displays `230- Logged in`.

---

### Deep Theoretical Questions (Exercise 3)

#### Question: "How does `DHCP` work in a network and what is its function?"
- **Model Answer**: "DHCP (Dynamic Host Configuration Protocol) operates via the 4-step **DORA** sequence over UDP ports 67 (Server) and 68 (Client):
  1. **Discover**: Client broadcasts `255.255.255.255` looking for available DHCP servers.
  2. **Offer**: Server reserves an unassigned IP and unicasts/broadcasts an offer.
  3. **Request**: Client broadcasts acceptance of that specific server's offer.
  4. **Acknowledge**: Server confirms the lease parameters (IP, mask, gateway, DNS)."

#### Question: "What is `HTTPS` and how does it differ from `HTTP`?"
- **Model Answer**: "**HTTPS** (Port 443) encapsulates HTTP traffic inside an encrypted **TLS/SSL** tunnel.
  - **Confidentiality**: Encrypts payload data using symmetric AES session keys.
  - **Integrity**: Uses cryptographic hashing (HMAC) to detect tampering.
  - **Authentication**: Uses X.509 digital certificates to verify server identity.
  HTTP (Port 80) transmits cleartext and is vulnerable to packet sniffing."

#### Question: "What is `FTP` and what does `RWDNL` mean?"
- **Model Answer**: "FTP (File Transfer Protocol) uses two TCP connections:
  - **Control Channel (Port 21)**: Commands and authentication.
  - **Data Channel (Port 20)**: Payload file transfers.
  - **RWDNL**: **R**ead (download), **W**rite (upload), **D**elete (remove), **N**ame (rename), **L**ist (directory view)."

#### Question: "What are the port numbers and OSI layers for each protocol used?"
- DHCP: **UDP 67/68**, Layer 7 (Application).
- DNS: **UDP/TCP 53**, Layer 7 (Application).
- HTTP: **TCP 80**, Layer 7 (Application).
- HTTPS: **TCP 443**, Layer 7 (Application).
- FTP: **TCP 21 / 20**, Layer 7 (Application).
- TCP / UDP: **Layer 4** (Transport Layer).

---

## 7. Exercise 4: Single Router & Default Gateway Topology

### Topology Summary
Two PCs connected to separate interfaces of Cisco 1841 router (`Router2`) on distinct `/30` subnets:
- `PC0`: `192.168.1.2/30`, Gateway `192.168.1.1` $\rightarrow$ Router Fa0/0 (`192.168.1.1/30`)
- `PC1`: `192.168.2.2/30`, Gateway `192.168.2.1` $\rightarrow$ Router Fa0/1 (`192.168.2.1/30`)

---

### Examiner Question 4.1 & 4.2
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**
> **"Are the 2 PCs communicating with each other?"**

#### Model Answer
"Yes. `PC0` and `PC1` sit on separate `/30` networks and communicate through Router2. When `PC0` pings `192.168.2.2`, the ping succeeds with 0% loss."

#### Verification Commands (PC0 Command Prompt)
```cmd
ping 192.168.2.2
tracert 192.168.2.2
```

---

### Deep Theoretical Questions (Exercise 4)

#### Question: "What is a router and what is its role?"
- **Model Answer**: "A **Router** is a Layer 3 (Network layer) device responsible for interconnecting logically distinct IP networks. It evaluates destination IP addresses against its routing table to forward packets along the optimal path, bounds broadcast domains, and decrements TTL by 1."

#### Question: "What is meant by 'default gateway'?"
- **Model Answer**: "A **Default Gateway** is the IP address of the local router interface attached to a host's subnet. When an endpoint creates an IP packet for a remote subnet, it forwards the frame to the Default Gateway's MAC address. Without a default gateway, an endpoint can only communicate within its own local subnet."

---

## 8. Exercise 5: Multi-Switch Subnet Routing

### Topology Summary
Two switched star LANs connected to a Cisco 2911 Router (`Router0`):
- **LAN 1 (Switch0)**: 5 PCs (`PC1`–`PC5`) on `192.168.1.0/29`. Router0 `Gig0/0`: `192.168.1.6/29` (Gateway).
- **LAN 2 (Switch1)**: 5 PCs (`PC6`–`PC10`) on `192.168.1.192/27`. Router0 `Gig0/1`: `192.168.1.194/27` (Gateway).

---

### Examiner Questions 5.1, 5.2, & 5.3
> **"Are all devices connected to the same switch able to communicate with each other?"**
> **"Are all devices in subnet 1 able to communicate with all devices in subnet 2 and vice versa?"**

#### Model Answer
"Yes. Both levels of communication are verified:
1. **Intra-Switch Communication (Layer 2)**: Devices connected to Switch0 communicate directly via MAC switching without router intervention.
2. **Inter-Subnet Communication (Layer 3)**: Devices in Subnet 1 reach devices in Subnet 2 by routing through Router0."

#### Verification Commands
```cmd
! From PC1 (Subnet 1):
ping 192.168.1.4       ! Intra-switch local ping (Layer 2)
ping 192.168.1.193     ! Inter-subnet routed ping (Layer 3)
```

---

## 9. Exercise 6: Multi-Router Static Routing Tables

### Topology Summary
Connecting two subnets across two routers over a `/30` point-to-point serial WAN link:
- **Subnet 1**: `PC1` (`192.168.1.2/24`), Gateway: `192.168.1.1` (Router1 LAN)
- **WAN Serial Link**: `10.10.0.0/30`: Router1 (`10.10.0.1`, DCE) $\leftrightarrow$ Router2 (`10.10.0.2`, DTE)
- **Subnet 2**: `PC2` (`192.168.2.2/24`), Gateway: `192.168.2.1` (Router2 LAN)
- **Static Routes**:
  - Router1: `ip route 192.168.2.0 255.255.255.0 10.10.0.2`
  - Router2: `ip route 192.168.1.0 255.255.255.0 10.10.0.1`

---

### Examiner Question 6.3
> **"Ask the student to explain what is a `routing table` and what is its role?"**

#### Model Answer
"A **Routing Table** is an in-memory database maintained by a router that stores destination network prefixes, subnet masks, next-hop IP addresses, and egress interfaces.
- **Role**: When an IP packet arrives, the router inspects the destination IP, matches it using the **Longest Prefix Match** rule, and forwards the packet out the designated exit interface.
- **Route Types**:
  - **`C` (Connected)**: Networks directly attached to an active interface.
  - **`L` (Local)**: The specific `/32` IP assigned to the router's own interface.
  - **`S` (Static)**: Manually configured by an administrator (`ip route`)."

---

## 10. Exercise 7: Dual-Router Subnet Interconnection & 5-Minute Live Exam Speed-Run

### Topology Summary
Two switched LANs connected across two routers over a serial link:
- **Subnet 1 (`192.168.1.0/24`)**: `PC0`–`PC4`, Gateway `192.168.1.1` $\rightarrow$ Router0 `Fa0/0`
- **WAN Link (`10.10.0.0/30`)**: Router0 `Se0/0/0` (`10.10.0.1`, DCE) $\leftrightarrow$ Router1 `Se0/0/0` (`10.10.0.2`, DTE)
- **Subnet 2 (`192.168.2.0/24`)**: `Laptop0`, `PC5`–`PC7`, Gateway `192.168.2.1` $\rightarrow$ Router1 `Fa0/0`

---

### ⏱️ The 5-Minute Live Recreation Speed-Run Protocol

When the examiner says: *"Now delete the topology and rebuild Exercise 7 from scratch,"* execute this exact sequence:

#### Step 1: Canvas Placement & Serial Module (0:00 - 1:15)
1. Drag **2 Cisco 2811 Routers**, **2 Cisco 2960 Switches**, and **4 PCs** (`PC0`, `PC1` on left; `PC2`, `PC3` on right) onto the canvas.
2. Click **Router 1** $\rightarrow$ **Physical** tab $\rightarrow$ flip power **OFF** $\rightarrow$ drag **`WIC-2T`** into slot **`WIC 0`** $\rightarrow$ power **ON**.
3. Repeat for **Router 2**.

#### Step 2: Cabling (1:15 - 2:15)
1. **Copper Straight-Through**:
   - `PC0` $\rightarrow$ Switch 1 `Fa0/2`, `PC1` $\rightarrow$ Switch 1 `Fa0/3`, Switch 1 `Fa0/1` $\rightarrow$ Router 1 `Fa0/0`.
   - `PC2` $\rightarrow$ Switch 2 `Fa0/2`, `PC3` $\rightarrow$ Switch 2 `Fa0/3`, Switch 2 `Fa0/1` $\rightarrow$ Router 2 `Fa0/0`.
2. **Serial DCE** (red lightning bolt with clock):
   - **Click Router 1 FIRST** $\rightarrow$ `Serial0/0/0` (designates R1 as DCE).
   - **Click Router 2 SECOND** $\rightarrow$ `Serial0/0/0`.

#### Step 3: Fast CLI Configuration (2:15 - 3:30)

##### Router 1 CLI (Type `no` to dialog)
```ios
enable
configure terminal
hostname Router0
interface FastEthernet0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
exit
interface Serial0/0/0
 ip address 10.10.0.1 255.255.255.252
 clock rate 64000
 no shutdown
exit
ip route 192.168.2.0 255.255.255.0 10.10.0.2
end
write memory
```

##### Router 2 CLI (Type `no` to dialog)
```ios
enable
configure terminal
hostname Router1
interface FastEthernet0/0
 ip address 192.168.2.1 255.255.255.0
 no shutdown
exit
interface Serial0/0/0
 ip address 10.10.0.2 255.255.255.252
 no shutdown
exit
ip route 192.168.1.0 255.255.255.0 10.10.0.1
end
write memory
```

#### Step 4: PC IPs & Verification (3:30 - 4:30)
- `PC0`: IP `192.168.1.2`, Mask `255.255.255.0`, Gateway `192.168.1.1`.
- `PC2`: IP `192.168.2.2`, Mask `255.255.255.0`, Gateway `192.168.2.1`.
- Press **Alt + D** twice (Fast Forward Time) to turn all amber switch ports green.
- On `PC0`: `ping 192.168.2.2` $\rightarrow$ **Success! Rebuilt in under 5 minutes!**

---

## 11. Exercise 8: 3-Subnet Chain Static Routing Architecture

### Topology Summary
A chain of three routers linking three LANs with non-uniform netmasks:
- **LAN 1 (`192.168.1.192/26`)**: Switch1, `PC1`–`PC5` (GW: `192.168.1.193` $\rightarrow$ Router1)
- **WAN 1-2 (`10.10.0.0/30`)**: Router1 (`10.10.0.1`, DCE) $\leftrightarrow$ Router2 (`10.10.0.2`)
- **LAN 2 (`192.168.2.0/24`)**: Switch2, `Laptop`, `PC6`–`PC8` (GW: `192.168.2.1` $\rightarrow$ Router2)
- **WAN 2-3 (`10.10.1.0/30`)**: Router2 (`10.10.1.1`, DCE) $\leftrightarrow$ Router3 (`10.10.1.2`)
- **LAN 3 (`192.168.3.160/28`)**: Switch3, `PC9`–`PC11` (GW: `192.168.3.161` $\rightarrow$ Router3)

### Static Routing Matrix
- **Router1**:
  - `ip route 192.168.2.0 255.255.255.0 10.10.0.2`
  - `ip route 192.168.3.160 255.255.255.240 10.10.0.2`
- **Router2**:
  - `ip route 192.168.1.192 255.255.255.192 10.10.0.1`
  - `ip route 192.168.3.160 255.255.255.240 10.10.1.2`
- **Router3**:
  - `ip route 192.168.1.192 255.255.255.192 10.10.1.1`
  - `ip route 192.168.2.0 255.255.255.0 10.10.1.1`

---

## 12. Documentation Check Defense

### Examiner Question
> **"Is the README.md file containing the clarification of all the knowledge learned and the steps passed by the learner to recreate the network architectures?"**

#### Model Answer
"Yes. The repository includes an exhaustive, professional `README.md` providing:
- Step-by-step recreation walkthroughs for every exercise.
- Visual Mermaid architecture diagrams and ASCII connection schemas.
- Tool-free mental subnetting formulas and block size calculations.
- Complete copy-pasteable Cisco IOS CLI configurations.
- Direct model answers to all theoretical questions in `audit.md`."

---

## 13. Bonus Defense: IEEE 802.1Q Router-on-a-Stick Inter-VLAN Routing

### Examiner Question
> **"Did the student add any optional bonus? If he did ask him what was it."**

#### Model Answer
"Yes, as an advanced enhancement, I researched and documented **IEEE 802.1Q Router-on-a-Stick (ROAS)** Inter-VLAN routing:
- **VLAN Microsegmentation**: Subdivides a single physical switch into isolated Layer 2 broadcast domains (VLAN 10 Management, VLAN 20 Engineering, VLAN 30 Guest).
- **802.1Q Trunking**: Transmits traffic from multiple VLANs across a single physical link by injecting a 4-byte 802.1Q tag into Ethernet frames.
- **Router Subinterfaces**: Virtual interfaces (e.g. `Fa0/0.10`, `Fa0/0.20`) created on a router interface, each acting as the default gateway for its respective VLAN."

---

## 14. Auditor Trap Questions & Edge-Case Encyclopedia

1. **Why does the first ping packet sometimes time out?**
   - *Answer*: Address Resolution Protocol (ARP). The router must broadcast an ARP request to discover the MAC address of the destination host before encapsulating and sending the first ICMP echo request. Subsequent packets succeed immediately.
2. **Why do switch ports stay amber for 30–50 seconds when cabled?**
   - *Answer*: 802.1D Spanning Tree Protocol (STP) port states: Blocking (20s) $\rightarrow$ Listening (15s) $\rightarrow$ Learning (15s) $\rightarrow$ Forwarding. Clicking **Fast Forward Time** (`Alt + D`) skips these timers.
3. **What is the difference between a collision domain and a broadcast domain?**
   - *Collision Domain*: A network segment where frames can collide if transmitted at the same time. Bounded by switches and routers.
   - *Broadcast Domain*: A network segment where all devices receive Layer 2 broadcasts (`FF:FF:FF:FF:FF:FF`). Bounded strictly by routers and VLANs.
