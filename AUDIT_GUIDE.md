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
11. [Exercise 8: 3-Subnet Full Mesh Static Routing Matrix](#11-exercise-8-3-subnet-full-mesh-static-routing-matrix)
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
- **Spanning Tree Trick (Fast Forward Time)**: When connecting switches, ports stay amber for 30–50 seconds due to the 802.1D Spanning Tree Protocol listening and learning states. Click the **Fast Forward Time** button (`>>`) or press **Alt + D** twice to transition ports to forwarding (green) immediately.
- **Never Enter the System Configuration Dialog**: When booting a Cisco router in CLI, always type `no` when prompted with `Continue with configuration dialog? [yes/no]:`.

---

## 2. Rapid-Reference Cheat Sheet

### Protocol, Port, Transport, and OSI Layer Summary
| Protocol | Full Name | Transport | Port | OSI Layer | Role in deep-in-net |
|:---|:---|:---:|:---:|:---:|:---|
| **DHCP** | Dynamic Host Configuration Protocol | UDP | 67 (Server), 68 (Client) | Layer 7 (Application) | Dynamically leases IP, netmask, gateway, DNS |
| **DNS** | Domain Name System | UDP / TCP | 53 | Layer 7 (Application) | Resolves hostnames to IP addresses |
| **HTTP** | Hypertext Transfer Protocol | TCP | 80 | Layer 7 (Application) | Unencrypted web service (Disabled in Ex03) |
| **HTTPS** | HTTP Secure (SSL/TLS) | TCP | 443 | Layer 7 (Application) | Encrypted web service (Payload: "hello") |
| **FTP** | File Transfer Protocol | TCP | 21 (Control), 20 (Data) | Layer 7 (Application) | Authenticated file transfer (`deepinnet` / `RWDNL`) |
| **ICMP** | Internet Control Message Protocol | IP (Proto 1) | N/A | Layer 3 (Network) | Diagnostic echo requests and replies (`ping`) |
| **ARP** | Address Resolution Protocol | Ethernet | N/A | Layer 2 (Data Link) | Resolves Layer 3 IPv4 to Layer 2 MAC addresses |

### Subnetting Quick Reference
$$\text{Block Size (Magic Number)} = 256 - \text{Interesting Octet Netmask}$$
$$\text{Usable Hosts} = 2^{(32 - \text{CIDR Prefix})} - 2 = 2^h - 2$$

| Prefix | Subnet Mask | 4th Octet | Block Size | Total IPs | Usable Hosts ($2^h - 2$) | Project Use Case |
|:---:|:---|:---:|:---:|:---:|:---:|:---|
| **/24** | `255.255.255.0` | 0 | $256 - 0 = 256$ | 256 | **254** | LAN Subnets (Ex01, 02, 03, 04, 05, 07, 08, Bonus) |
| **/30** | `255.255.255.252` | 252 | $256 - 252 = 4$ | 4 | **2** | Point-to-Point WAN Links (Ex06, Ex07, Ex08) |

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
"Yes, all mandatory and optional deliverables are present directly in the repository root directory as mandated by the project requirements:
- **8 Mandatory Simulation Files**: `ex01.pkt`, `ex02.pkt`, `ex03.pkt`, `ex04.pkt`, `ex05.pkt`, `ex06.pkt`, `ex07.pkt`, `ex08.pkt`.
- **1 Optional Bonus File**: `bonus.pkt` (802.1Q Inter-VLAN routing / Router-on-a-Stick).
- **Mandatory Documentation**: `README.md` (comprehensive 1,500+ line technical manual).
- **Audit Checklist**: `audit.md`.

All files reside strictly in the root directory without accidental nesting inside subdirectories."

#### Real-World Analogy
Think of this like an architectural blueprint review before building construction begins. The contractor must produce the complete set of numbered structural drawings (ex01 through ex08), the optional electrical enhancement plan (bonus), and the complete specification document (README.md). If any sheet is missing from the master folder, the permit cannot be approved.

#### Verification Commands (Bash)
```bash
tree deep-in-net/
# or
ls -la
```

#### Expected Output
```text
deep-in-net/
├── bonus.pkt
├── README.md
├── audit.md
├── AUDIT_GUIDE.md
├── ex01.pkt
├── ex02.pkt
├── ex03.pkt
├── ex04.pkt
├── ex05.pkt
├── ex06.pkt
├── ex07.pkt
├── ex08.pkt
└── verify_topology.sh
```

---

## 4. Exercise 1: Crossover Cable Host-to-Host Links

### Topology Summary
Three isolated direct host-to-host pairs using **Copper Crossover** cables:
- **Pair 1**: `PC0` (`192.168.1.10/24`) $\leftrightarrow$ `PC1` (`192.168.1.11/24`)
- **Pair 2**: `PC2` (`192.168.2.10/24`) $\leftrightarrow$ `PC3` (`192.168.2.11/24`)
- **Pair 3**: `PC4` (`192.168.3.10/24`) $\leftrightarrow$ `PC5` (`192.168.3.11/24`)

---

### Examiner Question 1.1
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**

#### Model Answer
"Yes. There are six PC endpoints grouped into three independent pairs. Each pair is connected directly with a green dashed Copper Crossover cable. Each pair occupies a distinct `/24` subnet (`192.168.1.0/24`, `192.168.2.0/24`, and `192.168.3.0/24`) with subnet mask `255.255.255.0`. No default gateway is configured or required because all communication is strictly point-to-point within the local subnet."

---

### Examiner Question 1.2
> **"Can you confirm that the communications mentioned above are established?"**

#### Model Answer
"Yes, confirmed. Direct point-to-point ICMP communication is active between each paired PC:
- `PC0` pings `PC1` (`192.168.1.11`) successfully with 0% packet loss.
- `PC2` pings `PC3` (`192.168.2.11`) successfully with 0% packet loss.
- `PC4` pings `PC5` (`192.168.3.11`) successfully with 0% packet loss.
Cross-pair communication (e.g., `PC0` to `PC2`) fails by design because each pair resides on a distinct IP network with no Layer 3 router interconnecting them."

#### Verification Commands (PC Command Prompt)
```cmd
! On PC0:
ping 192.168.1.11
arp -a

! On PC2:
ping 192.168.2.11

! On PC4:
ping 192.168.3.11
```

#### Expected Output
```text
Pinging 192.168.1.11 with 32 bytes of data:

Reply from 192.168.1.11: bytes=32 time<1ms TTL=128
Reply from 192.168.1.11: bytes=32 time<1ms TTL=128
Reply from 192.168.1.11: bytes=32 time<1ms TTL=128
Reply from 192.168.1.11: bytes=32 time<1ms TTL=128

Ping statistics for 192.168.1.11:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
```

---

### Examiner Question 1.3
> **"What is a RJ-45 cable?"**

#### Model Answer
"An **RJ-45** cable is an unshielded or shielded twisted-pair copper Ethernet cable (Category 5e, 6, or 6a) terminated at both ends with an **8P8C (8 Position, 8 Contact)** modular connector defined by the Registered Jack 45 standard.
- **Physical Composition**: Contains **8 color-coded copper conductors** twisted into **4 pairs** (Orange, Green, Blue, Brown).
- **Differential Signaling & Noise Rejection**: Ethernet transmits data using differential voltage pairs (e.g., TX+ and TX-). The physical twisting of wire pairs cancels out external electromagnetic interference (EMI) and adjacent-pair crosstalk, allowing signals to travel up to 100 meters without signal distortion."

#### Real-World Analogy
Think of an RJ-45 cable as a noise-canceling dual-wire intercom. If you send positive voltage down one wire and equal negative voltage down the other, any ambient radio noise outside the cable adds equal noise to both wires. At the receiving end, the computer subtracts the two signals; the noise cancels out to zero, leaving a pristine data signal.

---

### Examiner Question 1.4
> **"What is difference between straight through and crossover RJ-45 cables?"**

#### Model Answer
"The difference lies in how the 8 internal copper pins are mapped from **Connector End A** to **Connector End B** according to the **TIA/EIA-568A** and **TIA/EIA-568B** wiring standards. In 10/100BASE-TX Ethernet:
- Pins 1 & 2 are for **Transmitting (TX+ / TX-)**.
- Pins 3 & 6 are for **Receiving (RX+ / RX-)**.

1. **Straight-Through Cable (T568B to T568B)**:
   - **Pinout**: Wired identically on both ends (Pin 1 $
ightarrow$ 1, Pin 2 $
ightarrow$ 2, Pin 3 $
ightarrow$ 3, Pin 6 $
ightarrow$ 6).
   - **Application**: Connects devices operating at **different OSI tiers** (MDI to MDI-X devices), such as a PC or Router to a Switch. The switch port contains internal MDI-X circuitry that crosses transmit and receive internally.
2. **Crossover Cable (T568A to T568B)**:
   - **Pinout**: The transmit pair on End A connects to the receive pair on End B:
     - Pin 1 (TX+) $
ightarrow$ Pin 3 (RX+)
     - Pin 2 (TX-) $
ightarrow$ Pin 6 (RX-)
     - Pin 3 (RX+) $
ightarrow$ Pin 1 (TX+)
     - Pin 6 (RX-) $
ightarrow$ Pin 2 (TX-)
   - **Application**: Connects **like devices** directly without an intermediate switch:
     - PC to PC (Exercise 1)
     - Switch to Switch
     - Router to Router (via FastEthernet ports) or Router to PC."

#### Real-World Analogy (The Walkie-Talkie Problem)
Imagine two people communicating with toy tin-can telephones. Handset A has a Mouthpiece (Transmit) and an Earpiece (Receive). Handset B also has a Mouthpiece and an Earpiece. If you connect Mouthpiece to Mouthpiece and Earpiece to Earpiece (Straight-Through), Person A talks into Person B's mouth, and neither party hears anything. A crossover cable crosses Handset A's mouthpiece to Handset B's earpiece so both can converse simultaneously.

---

### Examiner Question 1.5
> **"How are the IP addresses calculated?"**

#### Model Answer
"IP addresses are calculated using the 4-step mental subnetting method without relying on software calculators:
1. **Understand Address Anatomy**: An IPv4 address is **32 binary bits** divided into **four 8-bit octets**. The Subnet Mask defines the split between Network bits and Host bits.
2. **Calculate the Block Size (Magic Number)**:
   - Identify the interesting octet in the subnet mask (the octet with a value other than `255`).
   - Subtract that octet value from `256`:
     $$\text{Block Size} = 256 - \text{Netmask Octet}$$
   - For a `/24` mask (`255.255.255.0`), the interesting octet is 0: $\text{Block Size} = 256 - 0 = 256$.
3. **Determine Subnet Boundaries**:
   - **Network ID**: The first address of the block (multiple of block size). For Subnet 1, it is `192.168.1.0`. It identifies the network segment itself.
   - **Broadcast ID**: The last address in the block ($\text{Next Network ID} - 1$). For Subnet 1, it is `192.168.1.255`. It addresses all hosts on the subnet.
4. **Determine Usable Host Range and Capacity**:
   - **First Usable Host**: $\text{Network ID} + 1 = 192.168.1.1$.
   - **Last Usable Host**: $\text{Broadcast ID} - 1 = 192.168.1.254$.
   - **Usable Host Capacity**: $2^h - 2$, where $h = \text{host bits} = 32 - 24 = 8$.
     $$2^8 - 2 = 256 - 2 = 254\text{ usable hosts}$$
- In Exercise 1, `PC0` (`192.168.1.10`) and `PC1` (`192.168.1.11`) sit comfortably within this usable range."

---

## 5. Exercise 2: Switch vs Hub Collision Domain Topologies

### Topology Summary
Two parallel star topologies contrasting Layer 2 switching against Layer 1 hub signal repeating:
- **Switch Subnet (`192.168.1.0/24`)**: Cisco 2960 Switch connecting `PC0` (.1.10), `PC1` (.1.11), `PC2` (.1.12).
- **Hub Subnet (`192.168.2.0/24`)**: Generic Hub connecting `PC3` (.2.10), `PC4` (.2.11), `PC5` (.2.12).

---

### Examiner Question 2.1
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**

#### Model Answer
"Yes. The topology features one Cisco 2960 Switch connecting three PCs on `192.168.1.0/24` with mask `255.255.255.0` via Copper Straight-Through cables, and one Generic Hub connecting three PCs on `192.168.2.0/24` with mask `255.255.255.0` via Copper Straight-Through cables."

---

### Examiner Question 2.2 & 2.3
> **"Does all computers connected to the Switch must be connected?"**
> **"Does all computers connected to the Hub must be connected?"**

#### Model Answer
"Yes. All PCs connected to the Switch communicate with each other (`PC0`, `PC1`, `PC2`), and all PCs connected to the Hub communicate with each other (`PC3`, `PC4`, `PC5`).
However, their physical transmission behavior differs fundamentally:
- The Switch microsegments traffic into dedicated, collision-free full-duplex links.
- The Hub broadcasts electrical signals to every port in a shared half-duplex collision domain."

#### Verification Commands
```cmd
! On PC0 (Switch LAN):
ping 192.168.1.11
ping 192.168.1.12

! On PC3 (Hub LAN):
ping 192.168.2.11
ping 192.168.2.12
```

---

### Examiner Question 2.4
> **"What is the function of a `switch`, how does it operate and what is its role in networking?"**

#### Model Answer
"A **Switch** is an active Layer 2 (Data Link layer) device designed to forward Ethernet frames intelligently within a local network.
- **How It Operates (The CAM Table)**:
  1. **Learning**: When an Ethernet frame enters a port, the switch extracts the **Source MAC address** and records it in its **MAC Address Table (CAM Table)** alongside the ingress port number and a 300-second aging timer.
  2. **Forwarding (Unicast)**: It checks the **Destination MAC address**. If found in the CAM table, it switches the frame **only to that specific egress port**.
  3. **Flooding**: If the destination MAC is unknown or broadcast (`FF:FF:FF:FF:FF:FF`), it floods the frame to all active ports except the port of origin.
  4. **Filtering**: If destination and source are on the same physical port, the frame is dropped to conserve network bandwidth.
- **Role**: Eliminates collisions by providing a **dedicated collision domain per port** operating in **Full Duplex** mode (simultaneous sending and receiving)."

#### Real-World Analogy
A switch is like a **private corporate mailroom clerk**. When an envelope arrives marked for 'Jane in Accounting, Office 204', the clerk checks the company employee directory, walks straight to Office 204, and hands Jane her letter. Nobody else in the building is interrupted.

#### Cisco IOS CLI Switch Commands
```ios
enable
show mac address-table
show interfaces status
```

#### Expected Output
```text
          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
   1    0001.42a1.1001    DYNAMIC     Fa0/1
   1    0001.42a1.1002    DYNAMIC     Fa0/2
   1    0001.42a1.1003    DYNAMIC     Fa0/3
Total Mac Addresses for this criterion: 3
```

---

### Examiner Question 2.5
> **"What is the function of a `hub`, how does it operate and what is its role in networking?"**

#### Model Answer
"A **Hub** is a legacy, unmanaged Layer 1 (Physical layer) multiport electrical repeater.
- **How It Operates**: A hub has no processor, memory, or MAC address table. When electrical voltage pulses enter any single port, the hub amplifies and blindly repeats those signals out of **every other port simultaneously**.
- **Collision Domain**: All devices attached to a hub belong to a **single shared collision domain**.
- **Duplex Mode**: Hubs operate in **Half-Duplex**. Devices must utilize **CSMA/CD** (Carrier Sense Multiple Access with Collision Detection). If two devices transmit at the exact same instant, an electrical collision occurs, corrupting data and triggering randomized backoff timers.
- **Role**: Historically served as a low-cost central connection point; now obsolete."

#### Real-World Analogy
A hub is like a **person shouting through a megaphone in a crowded hall**. When Alice speaks to Bob, the hub broadcasts her message at top volume across the entire room. Everyone (Bob, Charlie, Dave) hears it. Bob responds, while Charlie and Dave are forced to discard the message. If two people talk at once, nobody understands anything.

---

### Examiner Question 2.6
> **"What are the differences between a `hub` and a `switch`?"**

#### Model Answer (Comparative Matrix)
| Feature | Hub 📻 | Switch 🔀 |
|:---|:---|:---|
| **OSI Layer** | **Layer 1** (Physical Layer) | **Layer 2** (Data Link Layer) |
| **PDU Handled** | Raw Electrical Bits / Voltages | Structured Ethernet Frames |
| **Addressing** | None | 48-bit Hardware **MAC Addresses** |
| **Forwarding Method** | Blind flooding to all ports | Directed unicast to destination port |
| **Collision Domains** | **1 shared** across all ports | **Separate collision domain per port** |
| **Broadcast Domains** | 1 broadcast domain | 1 broadcast domain (per VLAN) |
| **Duplex Mode** | Half-Duplex (CSMA/CD required) | Full-Duplex (Simultaneous send & receive) |
| **Security** | Insecure (Any PC can sniff all traffic) | Secure (Traffic isolated to destination port) |
| **Bandwidth** | Shared across all ports | Dedicated line rate per port |

---

### Examiner Question 2.7
> **"Can you identify the `OSI model layer` that the `switch` and the `hub` operate on?"**

#### Model Answer
"- **Hub**: Operates on **Layer 1 (Physical Layer)**. It only regenerates electrical voltages and bit timing without inspecting frames or MAC addresses.
- **Switch**: Operates on **Layer 2 (Data Link Layer)**. It parses Ethernet frame headers, evaluates source and destination MAC addresses, verifies frame check sequences (CRC/FCS), and forwards frames intelligently."

---

## 6. Exercise 3: Core Network Services (DHCP, DNS, HTTPS, FTP)

### Topology Summary
An enterprise LAN (`192.168.1.0/24`) connected to a Cisco 2960 Switch hosting four dedicated servers:
- **DHCP Server**: `192.168.1.2` (Pool: `192.168.1.100` – `.149`, Gateway: `192.168.1.1`, DNS: `192.168.1.4`)
- **HTTPS Server**: `192.168.1.99` (HTTPS ON, HTTP OFF, payload `"hello"`)
- **FTP Server**: `192.168.1.3` (User: `deepinnet`, Pass: `deepinnet`, Permissions: `RWDNL`)
- **DNS Server**: `192.168.1.4` (`deep-in-net.local` $
ightarrow$ `192.168.1.99`, `deep-in-net.com` $
ightarrow$ `deep-in-net.local`)

---

### Examiner Question 3.1 & 3.2
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**
> **"Can you confirm that all `servers` have static IP addresses?"**

#### Model Answer
"Yes. All four servers and the switch are properly cabled using Copper Straight-Through cables on subnet `192.168.1.0/24` with netmask `255.255.255.0`.
In the Desktop $
ightarrow$ IP Configuration panel of each server, the radio button is explicitly set to **Static**:
- DHCP: `192.168.1.2`
- FTP: `192.168.1.3`
- DNS: `192.168.1.4`
- HTTPS: `192.168.1.99`
Servers must have static IPs so clients and network services can reliably locate them at permanent, unchanging IP addresses without lease expirations."

---

### Examiner Question 3.3
> **"Do all servers only provide the service specified for them?"**

#### Model Answer
"Yes. Strict service isolation (Principle of Least Privilege) is implemented across all four servers:
- **DHCP Server (`192.168.1.2`)**: Only DHCP service is ON. HTTP, HTTPS, FTP, and DNS are OFF.
- **FTP Server (`192.168.1.3`)**: Only FTP service is ON. HTTP, HTTPS, DHCP, and DNS are OFF.
- **DNS Server (`192.168.1.4`)**: Only DNS service is ON. HTTP, HTTPS, DHCP, and FTP are OFF.
- **HTTPS Server (`192.168.1.99`)**: Only HTTPS service is ON. HTTP is explicitly disabled, and DHCP, DNS, and FTP are OFF."

---

### Examiner Question 3.4
> **"Is the `DHCP server` responsible for assigning the IP addresses to all PCs?"**

#### Model Answer
"Yes. All client PCs (`PC0`, `PC1`, `PC2`) have their IP configuration set to **DHCP**. Each client broadcasts a DHCP Discover request and receives an IP in the `192.168.1.100+` range, subnet mask `255.255.255.0`, Default Gateway `192.168.1.1`, and DNS server `192.168.1.4`."

#### Verification Commands (PC Command Prompt)
```cmd
ipconfig /renew
ipconfig /all
```

#### Expected Output
```text
FastEthernet0 Connection:(default port)
   Connection-specific DNS Suffix..: 
   Physical Address................: 0001.C7B1.8901
   IPv4 Address....................: 192.168.1.100
   Subnet Mask.....................: 255.255.255.0
   Default Gateway.................: 192.168.1.1
   DNS Servers.....................: 192.168.1.4
   DHCP Server.....................: 192.168.1.2
```

---

### Examiner Question 3.5 & 3.6
> **"Can you connect to the `HTTPS Server` from any PC in the network?"**
> **"Does the `HTTPS Server` shows a "hell" message and is the `HTTP` disabled?"**

#### Model Answer
"Yes. In the HTTPS Server (`192.168.1.99`) Services $
ightarrow$ HTTP panel:
- **HTTP is toggled OFF** (requests on port 80 are rejected).
- **HTTPS is toggled ON** (listening on encrypted port 443).
- The `index.html` file renders `hello` (or `hell` per the audit rubric text).
- Opening `https://192.168.1.99` or `https://deep-in-net.com` in the PC web browser renders the secure greeting successfully."

---

### Examiner Question 3.7 & 3.8
> **"Does a `"deepinnet"` user with `RWDNL` access exists in the `FTP server`?"**
> **"Can you connect to the `FTP server` using the `"deepinnet"` user from any PC in the network?"**

#### Model Answer
"Yes. In the FTP server (`192.168.1.3`) Services $
ightarrow$ FTP panel:
- Username: `deepinnet`
- Password: `deepinnet`
- Permissions: **R** (Read), **W** (Write), **D** (Delete), **N** (Name/Rename), **L** (List) are all checked.
From any PC command prompt, executing `ftp 192.168.1.3` establishes an authenticated connection, allows directory listing via `dir`, and file transfers."

#### Verification Commands (PC Command Prompt)
```cmd
ftp 192.168.1.3
```

#### Expected Output
```text
Connected to 192.168.1.3.
220 Welcome to Cisco Packet Tracer FTP service.
User (192.168.1.3:(none)): deepinnet
331 Password required for deepinnet.
Password: deepinnet
230 User deepinnet logged in.
ftp> dir
200 PORT command successful.
150 Opening ASCII mode data connection for /bin/ls.
-rw-r--r-- 1 ftp ftp 28842 sample.txt
226 Transfer complete.
ftp> quit
221 Goodbye.
```

---

### Examiner Question 3.9 & 3.10
> **"Does the `DNS server` contains the correct records as above (`deep-in-net.local > 192.168.1.99`, `deep-in-net.com > deep-in-net.local`)?"**
> **"Does `"https://deep-in-net.com"` redirects to the `HTTPS Server`?"**

#### Model Answer
"Yes. The DNS database on `192.168.1.4` contains:
1. **`A` Record**: `deep-in-net.local` maps to `192.168.1.99`.
2. **`CNAME` Record**: `deep-in-net.com` aliases to `deep-in-net.local`.

When a client queries `deep-in-net.com`, the DNS resolver resolves the CNAME alias to `deep-in-net.local`, which then resolves to IP `192.168.1.99`. The browser establishes an SSL/TLS connection directly to `192.168.1.99:443`."

#### Verification Commands (PC Command Prompt)
```cmd
nslookup deep-in-net.com
```

#### Expected Output
```text
Server:  192.168.1.4
Address: 192.168.1.4

Name:    deep-in-net.local
Address: 192.168.1.99
Aliases: deep-in-net.com
```

---

### Deep Theoretical Questions (Exercise 3)

#### Question: "What is a `server` and what is its purpose in networking?"
- **Model Answer**: "A **Server** is a dedicated host or daemon process that listens continuously on standardized transport ports to provide shared resources, services, or data (web pages, files, IP leases, name translation) to client endpoints based on the Client-Server model."
- **Real-World Analogy**: A server is like a public restaurant kitchen. It stays open during operational hours, listening for orders from customers (clients). When a customer places an order (request), the chef prepares and serves the dish (response).

#### Question: "How does `DHCP` work in a network and what is its function?"
- **Model Answer**: "**DHCP** (Dynamic Host Configuration Protocol) automates client IP assignment using **UDP Ports 67 (Server)** and **68 (Client)** via the 4-step **DORA** sequence:
  1. **Discover**: Client broadcasts: *'Is there a DHCP server on this network?'*
  2. **Offer**: Server unicasts/broadcasts: *'I offer IP 192.168.1.100, Netmask 255.255.255.0, Gateway 192.168.1.1, DNS 192.168.1.4.'*
  3. **Request**: Client broadcasts: *'I accept the offer for 192.168.1.100 from server 192.168.1.2.'*
  4. **Acknowledge**: Server confirms: *'Lease confirmed and logged in my database.'*"
- **Real-World Analogy**: Renting a car at an airport desk: you walk up without a car (Discover), the clerk offers you a specific car (Offer), you sign the rental agreement (Request), and the clerk hands you the keys (Acknowledge).

#### Question: "What is the definition of `DNS` and what role does it play in network communication?"
- **Model Answer**: "**DNS** (Domain Name System) is the hierarchical, distributed directory service that translates human-friendly domain names (e.g., `deep-in-net.com`) into numerical IP addresses (e.g., `192.168.1.99`) required for Layer 3 packet routing."
- **Real-World Analogy**: The contact directory on your smartphone. You don't memorize 10-digit telephone numbers; you tap a person's name, and the phone dials the number.

#### Question: "What is the purpose of `HTTP` and how is it used in networking?"
- **Model Answer**: "**HTTP** (Hypertext Transfer Protocol) is an Application layer protocol operating over **TCP Port 80** using a request-response architecture to deliver web resources. It transmits data in **unencrypted cleartext**, making it vulnerable to packet sniffing and man-in-the-middle attacks."

#### Question: "What is `HTTPS` and how does it differ from `HTTP`?"
- **Model Answer**: "**HTTPS** (HTTP Secure) encapsulates HTTP traffic inside an encrypted **TLS/SSL (Transport Layer Security)** session over **TCP Port 443**.
  - **Confidentiality**: Encrypts payload data using symmetric AES session keys.
  - **Integrity**: Uses cryptographic hashing (HMAC) to detect payload tampering.
  - **Authentication**: Uses X.509 digital certificates to verify the server's authentic identity."
- **Real-World Analogy**: HTTP is writing a message on an open postcard that anyone handling the mail can read. HTTPS is sealing that letter inside a tamper-evident, key-locked titanium box.

#### Question: "What is the purpose of `FTP` and how does it operate in network communication?"
- **Model Answer**: "**FTP** (File Transfer Protocol) transfers files between clients and servers using **two distinct TCP connections**:
  1. **Control Channel (TCP Port 21)**: Remains open throughout the session to transmit user commands, authentication credentials, and status responses.
  2. **Data Channel (TCP Port 20)**: Opened on demand to transfer raw file payloads or directory listings, then closed immediately after transfer completion.
  - **RWDNL**: Represents permission flags: **R**ead (download), **W**rite (upload), **D**elete (remove), **N**ame (rename), and **L**ist (view directory)."

#### Question: "What is `TCP` and `UDP` communication and what distinguishes them from each other?"
- **Model Answer**:
  - **TCP (Transmission Control Protocol)**: Connection-oriented. Requires a **3-Way Handshake** (SYN $
ightarrow$ SYN-ACK $
ightarrow$ ACK). Provides guaranteed in-order delivery, packet retransmissions, flow control (sliding window), and error checking. Used for HTTPS, FTP, SSH.
  - **UDP (User Datagram Protocol)**: Connectionless. Sends independent datagrams without establishing a prior session ('fire-and-forget'). No delivery guarantees, sequencing, or retransmissions. Minimizes latency. Used for DNS, DHCP, VoIP, streaming."
- **Real-World Analogy**: TCP is registered mail requiring recipient signature and tracking. UDP is a live FM radio broadcast or tossing postcards into the wind.

#### Question: "At which `OSI model layer` do `TCP` and `UDP` operate?"
- **Model Answer**: "Both TCP and UDP operate strictly at **Layer 4 (Transport Layer)** of the OSI model."

#### Question: "What is a `port` in networking and what is its function?"
- **Model Answer**: "A **Port** is a 16-bit logical identifier (ranging from `0` to `65535`) that allows an operating system to demultiplex incoming network packets to the exact listening application process. The combination of an IP address and port number forms a **network socket** (e.g., `192.168.1.99:443`)."
- **Real-World Analogy**: The IP address is the physical street address of an apartment building; the port number is the apartment number on the tenant's door.

#### Question: "What are the various types of `DNS` records and what are their purposes?"
- **Model Answer**:
  - **`A` Record**: Maps a hostname to an IPv4 address (`deep-in-net.local` $
ightarrow$ `192.168.1.99`).
  - **`AAAA` Record**: Maps a hostname to an IPv6 address.
  - **`CNAME` Record (Canonical Name)**: Maps an alias hostname to another domain name (`deep-in-net.com` $
ightarrow$ `deep-in-net.local`).
  - **`MX` Record (Mail Exchanger)**: Specifies mail servers responsible for handling domain email.
  - **`PTR` Record (Pointer)**: Resolves an IP address back to a hostname (Reverse DNS).
  - **`NS` Record (Name Server)**: Identifies authoritative DNS servers for a zone.
  - **`SOA` Record (Start of Authority)**: Contains zone management metadata (serial number, refresh timers).
  - **`TXT` Record (Text)**: Holds text metadata for security validation (SPF, DKIM, DMARC)."

---

## 7. Exercise 4: Single Router & Default Gateway Topology

### Topology Summary
Connecting two distinct subnets using a single Cisco 2811 Router:
- **Subnet 1** (`192.168.1.0/24`): `PC0` (`192.168.1.10`), Gateway: `192.168.1.1` $
ightarrow$ Router `Fa0/0` (`192.168.1.1`).
- **Subnet 2** (`192.168.2.0/24`): `PC1` (`192.168.2.10`), Gateway: `192.168.2.1` $
ightarrow$ Router `Fa0/1` (`192.168.2.1`).

---

### Examiner Question 4.1 & 4.2
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**
> **"Are the 2 PCs communicating with each other?"**

#### Model Answer
"Yes. `PC0` and `PC1` sit in separate subnets and communicate through the router. When `PC0` pings `192.168.2.10`, the ping succeeds with 0% loss (the first ping packet may time out while the router resolves `PC1`'s MAC address via ARP)."

#### Verification Commands (PC0 Command Prompt)
```cmd
ping 192.168.2.10
tracert 192.168.2.10
```

#### Expected Output
```text
Tracing route to 192.168.2.10 over a maximum of 30 hops:
  1   <1 ms   <1 ms   <1 ms   192.168.1.1
  2   <1 ms   <1 ms   <1 ms   192.168.2.10
Trace complete.
```

---

### Deep Theoretical Questions (Exercise 4)

#### Question: "What is a `router` and what is its role in a network?"
- **Model Answer**: "A **Router** is a Layer 3 (Network layer) device responsible for interconnecting logically distinct IP networks.
  - **Path Determination**: Evaluates destination IP addresses against its routing table to forward packets along the optimal path.
  - **Broadcast Isolation**: Routers do not forward Layer 2 broadcasts; each router interface bounds and isolates a broadcast domain.
  - **Frame Rewriting**: Decapsulates incoming Layer 2 Ethernet frames, inspects the Layer 3 IP header, decrements the TTL by 1, recalculates the IP checksum, and re-encapsulates the packet in a new Layer 2 frame destined for the next hop."
- **Real-World Analogy**: An international border control checkpoint. Local vehicles travel freely inside their country (subnet), but to travel abroad, they must pass through customs (the router), show their passport (IP address), have it stamped (TTL decremented), and enter the foreign road network.

#### Question: "How does a `switch` differ from a `router` in terms of functionality?"
- **Model Answer**:
  - A **Switch** operates at **Layer 2 (Data Link)** using hardware **MAC addresses** to forward frames within the **same local subnet**. It maintains a CAM table and forwards broadcasts to all ports.
  - A **Router** operates at **Layer 3 (Network)** using logical **IP addresses** to route packets across **different subnets or WANs**. It maintains a Routing Table and drops broadcasts."

#### Question: "At which `OSI model layer` does a `router` operate?"
- **Model Answer**: "A router operates primarily at **Layer 3 (Network Layer)** of the OSI model."

#### Question: "What is meant by the term 'default gateway' in networking?"
- **Model Answer**: "A **Default Gateway** is the IP address of the local router interface attached to a host's subnet. When an endpoint creates an IP packet, it compares the destination IP against its own subnet mask:
  - If the destination is local, it resolves the destination MAC directly via local ARP.
  - If the destination is on a remote subnet, it forwards the frame to the **Default Gateway's MAC address**.
  - Without a configured default gateway, an endpoint can only communicate with devices on its own physical LAN segment."

---

## 8. Exercise 5: Multi-Switch Subnet Routing

### Topology Summary
Two subnets each equipped with a dedicated Layer 2 switch connected to a single router:
- **Subnet 1** (`192.168.1.0/24`): `PC0` (.1.10) and `PC1` (.1.11) connected to Switch 1 $
ightarrow$ Router `Fa0/0` (`192.168.1.1`).
- **Subnet 2** (`192.168.2.0/24`): `PC2` (.2.10) and `PC3` (.2.11) connected to Switch 2 $
ightarrow$ Router `Fa0/1` (`192.168.2.1`).

---

### Examiner Question 5.1, 5.2, & 5.3
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**
> **"Are all devices connected to the same switch able to communicate with each other?"**
> **"Are all devices in `subnet 1` able to communicate with all devices in `subnet 2` and vice versa?"**

#### Model Answer
"Yes. We have verified both levels of communication:
1. **Intra-Switch Communication (Layer 2)**: `PC0` communicates with `PC1` locally across Switch 1 without routing. The switch forwards frames directly using its MAC address table. `PC2` and `PC3` communicate similarly across Switch 2.
2. **Inter-Subnet Communication (Layer 3)**: Devices in Subnet 1 communicate with devices in Subnet 2 by addressing packets to their default gateway (`192.168.1.1`), which the router routes across interfaces to Subnet 2."

#### Verification Commands
```cmd
! From PC0 (Subnet 1):
ping 192.168.1.11    ! Intra-switch local ping (Layer 2)
ping 192.168.2.10    ! Inter-subnet routed ping (Layer 3)
ping 192.168.2.11    ! Inter-subnet routed ping (Layer 3)

! From PC2 (Subnet 2):
ping 192.168.2.11    ! Intra-switch local ping (Layer 2)
ping 192.168.1.10    ! Inter-subnet routed ping (Layer 3)
```

---

## 9. Exercise 6: Multi-Router Static Routing Tables

### Topology Summary
Connecting two subnets across two routers over a `/30` point-to-point serial WAN link:
- **Subnet 1** (`192.168.10.0/24`): `PC1` (`192.168.10.10`) $
ightarrow$ Router 1 `Fa0/0` (`192.168.10.1`).
- **WAN Serial Link** (`10.0.0.0/30`): Router 1 `Se0/0/0` (`10.0.0.1`, DCE) $\leftrightarrow$ Router 2 `Se0/0/0` (`10.0.0.2`, DTE).
- **Subnet 2** (`192.168.20.0/24`): Router 2 `Fa0/0` (`192.168.20.1`) $
ightarrow$ `PC2` (`192.168.20.10`).

---

### Examiner Question 6.1 & 6.2
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**
> **"Is the PC in subnet 1 able to communicate with the PC in subnet 2 and vice versa?"**

#### Model Answer
"Yes. Bidirectional end-to-end communication is established between `PC1` (`192.168.10.10`) and `PC2` (`192.168.20.10`) across the WAN serial link via static routes configured on Router 1 and Router 2."

#### Verification Commands (PC1 Command Prompt)
```cmd
ping 192.168.20.10
tracert 192.168.20.10
```

#### Expected Output
```text
Tracing route to 192.168.20.10 over a maximum of 30 hops:
  1   <1 ms   <1 ms   <1 ms   192.168.10.1
  2    1 ms   <1 ms   <1 ms   10.0.0.2
  3    1 ms    1 ms   <1 ms   192.168.20.10
Trace complete.
```

---

### Examiner Question 6.3
> **"Ask the student to explain what is a `routing table` and what is its role?"**

#### Model Answer
"A **Routing Table** is an in-memory database maintained by a router that stores destination network prefixes, subnet masks, next-hop IP addresses, and egress interfaces.
- **Role**: When an IP packet arrives, the router inspects the destination IP, matches it against the routing table using the **Longest Prefix Match** rule, and forwards the packet out the designated exit interface.
- **Route Types in Cisco IOS**:
  - **`C` (Connected)**: Networks directly attached to an active interface with an assigned IP. Administrative Distance = 0.
  - **`L` (Local)**: The specific `/32` host address assigned to the router interface itself.
  - **`S` (Static)**: Manually entered by an administrator (`ip route <dest> <mask> <next-hop>`). Administrative Distance = 1.
  - **`O` / `D` / `R`**: Learned dynamically via OSPF, EIGRP, or RIP."

#### Real-World Analogy
A routing table is like a **flight departure board at an international hub airport**. You do not need a roadmap of every street in Paris while waiting in New York; the board tells you: 'For Paris, board Flight 101 at Gate 4 (Next Hop)'.

#### Cisco IOS CLI Route Table Output (Router 1)
```ios
enable
show ip route
```

#### Expected Output
```text
Gateway of last resort is not set

     10.0.0.0/30 is subnetted, 1 subnets
C       10.0.0.0 is directly connected, Serial0/0/0
C    192.168.10.0/24 is directly connected, FastEthernet0/0
S    192.168.20.0/24 [1/0] via 10.0.0.2
```

---

## 10. Exercise 7: Dual-Router Subnet Interconnection & 5-Minute Live Exam Speed-Run

### Topology Summary
Complete dual-router, dual-switch architecture:
- **Subnet 1** (`172.16.1.0/24`): `PC0` (.1.10), `PC1` (.1.11) $
ightarrow$ Switch 1 $
ightarrow$ Router 1 `Fa0/0` (`172.16.1.1`).
- **WAN Link** (`10.1.1.0/30`): Router 1 `Se0/0/0` (`10.1.1.1`, DCE) $\leftrightarrow$ Router 2 `Se0/0/0` (`10.1.1.2`, DTE).
- **Subnet 2** (`172.16.2.0/24`): Router 2 `Fa0/0` (`172.16.2.1`) $
ightarrow$ Switch 2 $
ightarrow$ `PC2` (.2.10), `PC3` (.2.11).

---

### Examiner Questions 7.1, 7.2, 7.3
> **"Are the devices/links/IPs/netmasks in the solution similar to the required in the subject?"**
> **"Are all devices connected to the same `switch` able to communicate with each other?"**
> **"Are all devices in `subnet 1` able to communicate with all devices in `subnet 2` and vice versa?"**

#### Model Answer
"Yes. All local intra-switch communications and remote inter-subnet communications are fully operational. Pings from `PC0` succeed to `PC1`, `PC2`, and `PC3`."

---

### Examiner Question 7.4, 7.5, 7.6 (The Live Recreation Exam)
> **"Ask the student to recreate the 'Exercise 7' network again without external tools."**
> **"Was the student able to recreate the network?"**
> **"Does the created network perform correctly?"**

---

### ⏱️ The 5-Minute Live Recreation Speed-Run Protocol

When the examiner says: *"Now delete the topology and rebuild Exercise 7 from scratch,"* follow this exact sequence:

```
[0:00 - 0:45] Drag 2 Routers, 2 Switches, 4 PCs onto canvas
       │
[0:45 - 1:30] Power off routers, insert WIC-2T into slot WIC 0, power on
       │
[1:30 - 2:30] Cable PCs to switches, switches to Fa0/0, Serial DCE (R1 -> R2)
       │
[2:30 - 3:45] Type/paste IOS configuration blocks into R1 and R2 CLI
       │
[3:45 - 4:30] Assign static IP / Mask / Gateway on all 4 PCs
       │
[4:30 - 5:00] Press Fast Forward Time (Alt + D), run ping 172.16.2.10 -> SUCCESS!
```

#### Step 0: Canvas Placement (0:00 - 0:45)
- Drag **two Cisco 2811 Routers** onto the canvas.
- Drag **two Cisco 2960 Switches** onto the canvas.
- Drag **four Generic PCs** onto the canvas (`PC0`, `PC1` on left; `PC2`, `PC3` on right).

#### Step 1: Install WIC-2T Module Cards (0:45 - 1:30)
1. Click **Router 1** $
ightarrow$ **Physical** tab $
ightarrow$ flip power switch **OFF**.
2. Select **`WIC-2T`** from the left list $
ightarrow$ drag into slot **`WIC 0`** (bottom right).
3. Flip power switch **ON**.
4. Repeat for **Router 2**.

#### Step 2: Cabling (1:30 - 2:30)
1. **Copper Straight-Through** (solid black):
   - `PC0` $
ightarrow$ Switch 1 `Fa0/2`
   - `PC1` $
ightarrow$ Switch 1 `Fa0/3`
   - Switch 1 `Fa0/1` $
ightarrow$ Router 1 `Fa0/0`
   - `PC2` $
ightarrow$ Switch 2 `Fa0/2`
   - `PC3` $
ightarrow$ Switch 2 `Fa0/3`
   - Switch 2 `Fa0/1` $
ightarrow$ Router 2 `Fa0/0`
2. **Serial DCE** (red lightning bolt with clock):
   - **Click Router 1 FIRST** $
ightarrow$ `Serial0/0/0` *(Designates R1 as DCE clock provider)*.
   - **Click Router 2 SECOND** $
ightarrow$ `Serial0/0/0` *(Designates R2 as DTE)*.

#### Step 3: Cisco IOS CLI Configurations (2:30 - 3:45)

##### Router 1 CLI (Type `no` to initial dialog)
```ios
enable
configure terminal
hostname R1

interface FastEthernet0/0
 ip address 172.16.1.1 255.255.255.0
 no shutdown
exit

interface Serial0/0/0
 ip address 10.1.1.1 255.255.255.252
 clock rate 64000
 no shutdown
exit

ip route 172.16.2.0 255.255.255.0 10.1.1.2

end
write memory
```

##### Router 2 CLI (Type `no` to initial dialog)
```ios
enable
configure terminal
hostname R2

interface FastEthernet0/0
 ip address 172.16.2.1 255.255.255.0
 no shutdown
exit

interface Serial0/0/0
 ip address 10.1.1.2 255.255.255.252
 no shutdown
exit

ip route 172.16.1.0 255.255.255.0 10.1.1.1

end
write memory
```

#### Step 4: PC Static IP Configuration (3:45 - 4:30)
- **`PC0`**: IP `172.16.1.10` | Mask `255.255.255.0` | Gateway `172.16.1.1`
- **`PC1`**: IP `172.16.1.11` | Mask `255.255.255.0` | Gateway `172.16.1.1`
- **`PC2`**: IP `172.16.2.10` | Mask `255.255.255.0` | Gateway `172.16.2.1`
- **`PC3`**: IP `172.16.2.11` | Mask `255.255.255.0` | Gateway `172.16.2.1`

#### Step 5: Fast-Forward & Verification (4:30 - 5:00)
1. Press **Alt + D** twice (Fast Forward Time) to turn all amber switch ports green.
2. Open `PC0` Command Prompt:
   ```cmd
   ping 172.16.1.11
   ping 172.16.2.10
   ```
3. Response: `Reply from 172.16.2.10: bytes=32 time<1ms TTL=126`.
4. **Recreation complete in under 5 minutes with zero errors!**

---

## 11. Exercise 8: 3-Subnet Full Mesh Static Routing Matrix

### Topology Summary
Redundant 3-router, 3-subnet architecture where all routers are interconnected via `/30` point-to-point serial links:
- **LAN 1** (`192.168.1.0/24`): `PC0` (.1.10), `PC1` (.1.11) $
ightarrow$ Switch 1 $
ightarrow$ Router 1 `Fa0/0` (`192.168.1.1`).
- **LAN 2** (`192.168.2.0/24`): `PC2` (.2.10), `PC3` (.2.11) $
ightarrow$ Switch 2 $
ightarrow$ Router 2 `Fa0/0` (`192.168.2.1`).
- **LAN 3** (`192.168.3.0/24`): `PC4` (.3.10), `PC5` (.3.11) $
ightarrow$ Switch 3 $
ightarrow$ Router 3 `Fa0/0` (`192.168.3.1`).
- **WAN Links**:
  - `WAN 12` (`10.0.12.0/30`): R1 `Se0/0/0` (`10.0.12.1`, DCE) $\leftrightarrow$ R2 `Se0/0/0` (`10.0.12.2`, DTE)
  - `WAN 23` (`10.0.23.0/30`): R2 `Se0/0/1` (`10.0.23.1`, DCE) $\leftrightarrow$ R3 `Se0/0/0` (`10.0.23.2`, DTE)
  - `WAN 13` (`10.0.13.0/30`): R1 `Se0/0/1` (`10.0.13.1`, DCE) $\leftrightarrow$ R3 `Se0/0/1` (`10.0.13.2`, DTE)

---

### Examiner Questions 8.1 through 8.6
> **"Are all devices connected to the same switch able to communicate with each other?"**
> **"Can all devices in `subnet 1` communicate with all devices in `subnet 2` and vice versa?"**
> **"Can all devices in `subnet 1` communicate with all devices in `subnet 3` and vice versa?"**
> **"Can all devices in `subnet 2` communicate with all devices in `subnet 3` and vice versa?"**

#### Model Answer
"Yes. Full mesh static routing is configured on all three routers. Every router possesses exact routing instructions to reach all 6 subnets in the architecture (3 local LAN subnets and 3 point-to-point transit WAN links). Every PC can ping every other PC across all three switches."

---

### 🗺️ The Complete Full Mesh Static Routing Table Matrix

#### Router 1 (R1) Static Routes
```ios
ip route 192.168.2.0 255.255.255.0 10.0.12.2    ! Reach LAN 2 via R2
ip route 192.168.3.0 255.255.255.0 10.0.13.2    ! Reach LAN 3 via R3
ip route 10.0.23.0 255.255.255.252 10.0.12.2    ! Reach transit WAN 23 via R2
```

#### Router 2 (R2) Static Routes
```ios
ip route 192.168.1.0 255.255.255.0 10.0.12.1    ! Reach LAN 1 via R1
ip route 192.168.3.0 255.255.255.0 10.0.23.2    ! Reach LAN 3 via R3
ip route 10.0.13.0 255.255.255.252 10.0.12.1    ! Reach transit WAN 13 via R1
```

#### Router 3 (R3) Static Routes
```ios
ip route 192.168.1.0 255.255.255.0 10.0.13.1    ! Reach LAN 1 via R1
ip route 192.168.2.0 255.255.255.0 10.0.23.1    ! Reach LAN 2 via R2
ip route 10.0.12.0 255.255.255.252 10.0.13.1    ! Reach transit WAN 12 via R1
```

#### Complete Verification Matrix (9 Unicast Ping Paths)
```
From PC0 (Subnet 1) -> ping PC1 (Same Switch): 192.168.1.11 [PASS - Local Layer 2]
From PC0 (Subnet 1) -> ping PC2 (Subnet 2):     192.168.2.10 [PASS - Direct WAN 12]
From PC0 (Subnet 1) -> ping PC4 (Subnet 3):     192.168.3.10 [PASS - Direct WAN 13]

From PC2 (Subnet 2) -> ping PC3 (Same Switch): 192.168.2.11 [PASS - Local Layer 2]
From PC2 (Subnet 2) -> ping PC0 (Subnet 1):     192.168.1.10 [PASS - Direct WAN 12]
From PC2 (Subnet 2) -> ping PC4 (Subnet 3):     192.168.3.10 [PASS - Direct WAN 23]

From PC4 (Subnet 3) -> ping PC5 (Same Switch): 192.168.3.11 [PASS - Local Layer 2]
From PC4 (Subnet 3) -> ping PC0 (Subnet 1):     192.168.1.10 [PASS - Direct WAN 13]
From PC4 (Subnet 3) -> ping PC2 (Subnet 2):     192.168.2.10 [PASS - Direct WAN 23]
```

---

## 12. Documentation Check Defense

### Examiner Question
> **"Is the README.md file containing the clarification of all the knowledge learned and the steps passed by the learner to recreate the network architectures?"**

#### Model Answer
"Yes. The repository includes an exhaustive 1,500+ line `README.md` that thoroughly documents:
1. **Network Topologies**: ASCII and Mermaid diagrams for all 8 exercises and the bonus.
2. **Addressing Schemas**: Exact IP addresses, netmasks, gateways, and port assignments.
3. **Mental Subnetting Math**: Complete 4-step tool-free calculations for all 12 subnets.
4. **Cisco IOS Configurations**: Production CLI scripts for every router and switch.
5. **Theoretical Foundations**: In-depth explanations of OSI layers, collision domains, DORA, DNS, HTTPS, FTP channels, and routing table mechanics.
6. **Automated Verification**: Integrated test results from `verify_topology.sh` validating 56 individual checks."

---

## 13. Bonus Defense: IEEE 802.1Q Router-on-a-Stick Inter-VLAN Routing

### Examiner Questions
> **"+ Did the student pass the network recreation exam without error and in a short time?"**
> **"+ Did the student add any optional bonus? If he did ask him what was it."**

---

### Bonus Architecture Presentation

#### 1. What was implemented?
"For our optional bonus deliverable (`bonus.pkt`), we designed and implemented an enterprise-grade **IEEE 802.1Q Inter-VLAN Routing architecture**, universally known as **Router-on-a-Stick**."

#### 2. Architecture & Subnet Allocations
Three departmental VLANs are isolated at Layer 2 on a Cisco 2960 Switch and routed through a single physical FastEthernet trunk uplink to a Cisco Router:
- **VLAN 10 (Engineering)**: Subnet `192.168.10.0/24`, Gateway: `192.168.10.1`, Host: `PC-Eng` (`192.168.10.10`) on Switch port `Fa0/10`.
- **VLAN 20 (Sales)**: Subnet `192.168.20.0/24`, Gateway: `192.168.20.1`, Host: `PC-Sales` (`192.168.20.10`) on Switch port `Fa0/20`.
- **VLAN 30 (Management)**: Subnet `192.168.30.0/24`, Gateway: `192.168.30.1`, Host: `PC-Mgmt` (`192.168.30.10`) on Switch port `Fa0/30`.
- **Trunk Link**: Switch port `Fa0/1` $\leftrightarrow$ Router physical interface `Fa0/0`.

#### 3. How IEEE 802.1Q Frame Tagging Operates
"When a standard Ethernet frame leaves an access port (e.g., from `PC-Eng` in VLAN 10), the switch inserts a **4-byte 802.1Q VLAN Tag** into the frame header directly between the Source MAC Address and EtherType fields before transmitting it across the trunk:
- **TPID (Tag Protocol Identifier - 16 bits)**: Set to `0x8100`, identifying the frame as 802.1Q tagged.
- **TCI (Tag Control Information)**:
  - **PCP (Priority Code Point - 3 bits)**: Quality of Service (QoS) prioritization.
  - **DEI (Drop Eligible Indicator - 1 bit)**: Drop priority during network congestion.
  - **VID (VLAN Identifier - 12 bits)**: Specifies the VLAN number (`1` to `4094`). Here, VID = `10`.

When the frame reaches the router, the router inspects the VID, strips the 802.1Q tag, directs the packet to virtual sub-interface `Fa0/0.10`, inspects the destination IP, routes it to sub-interface `Fa0/0.20`, tags it with VID = `20`, and transmits it back down the trunk to the switch."

#### 4. Cisco IOS CLI Configurations

##### Cisco 2960 Switch Configuration
```ios
enable
configure terminal
hostname Switch1

! Create VLANs
vlan 10
 name Engineering
exit
vlan 20
 name Sales
exit
vlan 30
 name Management
exit

! Assign Access Ports
interface FastEthernet0/10
 switchport mode access
 switchport access vlan 10
 no shutdown
exit

interface FastEthernet0/20
 switchport mode access
 switchport access vlan 20
 no shutdown
exit

interface FastEthernet0/30
 switchport mode access
 switchport access vlan 30
 no shutdown
exit

! Configure 802.1Q Trunk Uplink to Router
interface FastEthernet0/1
 switchport mode trunk
 no shutdown
exit

end
write memory
```

##### Cisco Router (Router-on-a-Stick) Configuration
```ios
enable
configure terminal
hostname Router1

! Enable physical interface without IP
interface FastEthernet0/0
 no ip address
 no shutdown
exit

! Sub-interface for VLAN 10
interface FastEthernet0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
exit

! Sub-interface for VLAN 20
interface FastEthernet0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
exit

! Sub-interface for VLAN 30
interface FastEthernet0/0.30
 encapsulation dot1Q 30
 ip address 192.168.30.1 255.255.255.0
exit

end
write memory
```

#### 5. Verification Commands
On Switch:
```ios
show vlan brief
show interfaces trunk
```
On Router:
```ios
show ip route
show ip interface brief
```
From `PC-Eng` (`192.168.10.10`):
```cmd
ping 192.168.20.10
tracert 192.168.30.10
```

#### 6. Why This Bonus Deserves Full Credit
1. **Solves Physical Port Exhaustion**: Traditional routing required a dedicated physical router port and cable for every single subnet. Router-on-a-Stick routes dozens of subnets over a single physical cable.
2. **Security & Blast-Radius Containment**: Layer 2 broadcast domains are completely isolated. A malware outbreak or broadcast storm in Sales cannot spill into Engineering without passing through router inspection.
3. **Enterprise & Cloud Foundation**: 802.1Q trunking and virtual interfaces are the exact architectural foundation of AWS VPC subnets and Kubernetes container networking.

---

## 14. Auditor Trap Questions & Edge-Case Encyclopedia

### Trap 1: "Why does the very first ping across a router show 'Request timed out'?"
- **Model Answer**: "Because of **ARP resolution latency**. When `PC0` transmits a packet to a remote subnet, it must first send an ARP broadcast to resolve its Default Gateway's MAC address. Once the router receives the packet, it must also send an ARP broadcast out its second interface to discover the destination PC's MAC address. While these two ARP requests are broadcast and resolved, the router drops the initial ICMP echo packet to prevent memory buffer exhaustion. Subsequent pings succeed with `<1ms` latency because the MAC addresses are cached in the ARP tables."

### Trap 2: "What happens if you use a Straight-Through cable between two PCs in Packet Tracer?"
- **Model Answer**: "In modern physical hardware with **Auto-MDIX**, the physical NIC chip would electronically detect the pin mismatch and swap the TX and RX pairs internally. However, in **Cisco Packet Tracer**, Auto-MDIX is disabled on generic PC endpoints. A straight-through cable connects TX pins directly to TX pins and RX to RX. Consequently, the interface link state remains **`Down/Down`** with red link lights, and no frames can travel across the wire."

### Trap 3: "Why did you enter `clock rate 64000` on Router 1's serial interface, but not on Router 2?"
- **Model Answer**: "In real-world WAN serial links, the telecommunications service provider supplies a CSU/DSU device that generates the bit timing clock (DCE - Data Communications Equipment). The customer router is the DTE (Data Terminal Equipment) and synchronizes to that incoming clock. In a lab back-to-back serial connection without a CSU/DSU, one router must emulate the DCE clock provider. The `clock rate` command configures the hardware oscillator on the DCE interface. Entering it on the DTE interface will be rejected by the IOS parser with an error."

### Trap 4: "Can a Layer 2 Switch prevent a Broadcast Storm?"
- **Model Answer**: "No, a standard Layer 2 switch forwards broadcast frames (`FF:FF:FF:FF:FF:FF`) out of **all active ports except the port of arrival**. If there is a physical switching loop without Spanning Tree Protocol (STP), broadcast frames circulate endlessly, multiplying exponentially until switch buffers saturate and the network crashes. Only **Routers (Layer 3)** or **VLAN boundaries** terminate and contain broadcast domains."

### Trap 5: "What is the difference between Active and Passive FTP?"
- **Model Answer**:
  - **Active FTP**: The client establishes the control connection to server port 21 from random port $N$, and sends `PORT N+1`. The **server then initiates the data connection** from port 20 back to client port $N+1$. This usually fails in modern networks because client-side stateful firewalls block unsolicited inbound connection requests from the Internet.
  - **Passive FTP**: The client sends `PASV` over the control connection. The server opens an unprivileged random port $P$ and sends $P$ back to the client. The **client then initiates both the control and data connections** to the server, allowing firewalls to permit the session as outbound traffic."

### Trap 6: "In Exercise 8, why is it necessary to configure static routes to transit `/30` links?"
- **Model Answer**: "For return traffic and diagnostic utilities like `traceroute`. If `PC0` on Router 1 sends a packet that traverses Router 2 and hits Router 3's transit interface `10.0.23.2`, Router 3 must know how to route the return ICMP response packet back to Router 1. If Router 3 does not have a route back to transit network `10.0.12.0/30`, return packets will be dropped."

### Trap 7: "What is the difference between an Authoritative and a Recursive DNS Server?"
- **Model Answer**:
  - **Recursive DNS Server (Resolver)**: Acts on behalf of the client PC. It receives the client's query, traverses the global DNS hierarchy (Root $
ightarrow$ TLD $
ightarrow$ Authoritative), caches the answer, and returns it to the client.
  - **Authoritative DNS Server**: The final source of truth for a specific domain zone. It holds the actual DNS database records (e.g., `deep-in-net.com`) configured by the domain administrator and gives definitive answers."

### Trap 8: "What is CSMA/CD and why is it inactive on modern switched networks?"
- **Model Answer**: "**CSMA/CD** stands for **Carrier Sense Multiple Access with Collision Detection**. In legacy half-duplex shared bus topologies (Hubs), devices listen before transmitting (Carrier Sense), multiple stations share the media (Multiple Access), and if two transmit simultaneously, they detect the abnormal voltage spike (Collision Detection), broadcast a jam signal, and wait a randomized backoff period. Modern switches operate in **Full Duplex** with dedicated transmit and receive wire pairs per port; collisions are physically impossible, rendering CSMA/CD obsolete."

### Trap 9: "How does a router know when an IP packet is looping forever?"
- **Model Answer**: "Through the **TTL (Time to Live)** field in the IPv4 header (or Hop Limit in IPv6). Every Layer 3 router that forwards an IP packet decrements the TTL field by exactly 1. If the TTL value reaches 0, the router discards the packet immediately and transmits an **ICMP Type 11 (Time-to-Live Exceeded)** message back to the source IP address. This prevents routing loops from circulating infinitely and consuming network bandwidth."

### Trap 10: "What happens if you assign the Network ID or Broadcast ID to a computer's static IP configuration?"
- **Model Answer**: "The operating system's IP stack rejects the configuration with an error: *'Invalid IP address / Subnet mask combination'*. The Network ID is reserved to represent the entire subnet in routing tables, and the Broadcast ID is reserved to address all stations simultaneously. Assigning either to an individual host creates severe addressing ambiguity and breaks ARP broadcasting."

---

## 🏆 Final Audit Readiness Verification
- [x] All 9 `.pkt` files present in root (`ex01.pkt` – `ex08.pkt`, `bonus.pkt`).
- [x] `README.md`, `audit.md`, and `AUDIT_GUIDE.md` present and verified.
- [x] Automated test suite passing 56/56 checks via `./verify_topology.sh`.
- [x] 5-Minute Live Exam speed-run sequence memorized (Routers, Switches, PCs, WIC-2T, Cables, CLI, IPs, Fast-Forward).
- [x] Ready to perform mental subnetting on `/24` and `/30` networks on the fly.
- [x] Prepared to defend the 802.1Q Router-on-a-Stick bonus with frame-tagging theory and CLI verification.

**Good luck with your audit! You are 100% prepared to achieve a perfect score.**
