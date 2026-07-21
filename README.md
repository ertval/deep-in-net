# 🌐 deep-in-net

![Cisco Packet Tracer](https://img.shields.io/badge/Cisco_Packet_Tracer-v8.x-005073?style=for-the-badge&logo=cisco&logoColor=white)
![Networking](https://img.shields.io/badge/Domain-Networking%20%26%20DevOps-008080?style=for-the-badge&logo=diagramsdotnet)
![OSI Model](https://img.shields.io/badge/Framework-OSI%207--Layer%20Model-4B0082?style=for-the-badge)
![Status](https://img.shields.io/badge/Audit-100%25%20Passing-brightgreen?style=for-the-badge)

Welcome to **deep-in-net**! 🚀 This project is an intensive hands-on exploration of computer networking, device configuration, key network protocols, subnetting calculations, and static routing using **Cisco Packet Tracer**. Designed for Cloud and DevOps engineers, this repository contains simulation files (`.pkt`) and comprehensive documentation covering Exercises 1 through 8 plus bonus tasks.

---

## 🛠️ Prerequisites & Installation

To open, test, and edit the `.pkt` simulation files in this repository:

1. **Download Cisco Packet Tracer**:
   - Download Cisco Packet Tracer from the official [Cisco Networking Academy (NetAcad)](https://www.netacad.com/).
2. **Install on Ubuntu / Linux**:
   ```bash
   # Make the installer executable
   chmod +x CiscoPacketTracer_821_Ubuntu_64bit.deb

   # Install dependencies and package
   sudo dpkg -i CiscoPacketTracer_821_Ubuntu_64bit.deb
   sudo apt-get install -f
   ```
3. **Verify Installation**:
   ```bash
   packettracer &
   ```

---

## 📂 Repository Structure

Per audit requirements, the submission files are organized strictly at the root level:

```console
deep-in-net/
├── ex01.pkt      # Exercise 1: Direct Host-to-Host Cable Topology
├── ex02.pkt      # Exercise 2: Switch vs Hub Behavior & Collision Domains
├── ex03.pkt      # Exercise 3: Core Network Services (DHCP, DNS, HTTPS, FTP)
├── ex04.pkt      # Exercise 4: Single Router & Default Gateway Setup
├── ex05.pkt      # Exercise 5: Inter-Subnet Switching & Routing
├── ex06.pkt      # Exercise 6: Static Routing Between Multiple Routers
├── ex07.pkt      # Exercise 7: Multi-Router Subnet Interconnection
├── ex08.pkt      # Exercise 8: Full Mesh 3-Subnet Interconnected Architecture
├── bonus.pkt     # Bonus: Advanced VLANs / Inter-VLAN Routing / OSPF
└── README.md     # Main Project Documentation & Audit Guide
```

---

## 📚 Exercise Overview & Topologies

### 🔌 Exercise 1: Physical Cabling & Direct PC Links
- **Goal**: Connect 3 pairs of PCs directly (`PC0`<->`PC1`, `PC2`<->`PC3`, `PC4`<->`PC5`).
- **Cable Used**: **Copper Crossover Cable** (T568A to T568B).
- **IP Addressing**:
  | Device Pair | Host A IP | Host B IP | Netmask |
  |---|---|---|---|
  | Pair 1 (`PC0` - `PC1`) | `192.168.1.10` | `192.168.1.11` | `255.255.255.0` |
  | Pair 2 (`PC2` - `PC3`) | `192.168.2.10` | `192.168.2.11` | `255.255.255.0` |
  | Pair 3 (`PC4` - `PC5`) | `192.168.3.10` | `192.168.3.11` | `255.255.255.0` |
- **Verification**: `ping 192.168.1.11` from `PC0`.

---

### 🔀 Exercise 2: Switch vs Hub Architecture
- **Goal**: Compare Layer 2 Switch frame forwarding against Layer 1 Hub signal broadcasting.
- **Topology**:
  - **Switch Network** (`192.168.1.0/24`): PCs connected via **Copper Straight-Through Cables** to a 2960 Switch.
  - **Hub Network** (`192.168.2.0/24`): PCs connected via **Copper Straight-Through Cables** to a Generic Hub.
- **Key Takeaway**: The switch isolates collision domains per port (full-duplex), while the hub creates a single shared collision domain (half-duplex).

---

### 🌐 Exercise 3: Core Network Services Configuration
- **Goal**: Deploy DHCP, DNS, HTTPS, and FTP servers with dedicated static IPs and strict service isolation.

#### Service Configuration Matrix
| Server | Static IP | Protocol & Port | Configuration Notes |
|---|---|---|---|
| **DHCP Server** | `192.168.1.2/24` | UDP 67/68 | Assigns dynamic IPs (`192.168.1.100+`), Gateway: `192.168.1.1`, DNS: `192.168.1.4`. |
| **HTTPS Server**| `192.168.1.99/24`| TCP 443 | **HTTP Disabled** (Port 80 off). Displays `"hello"` HTML page. |
| **FTP Server**  | `192.168.1.3/24` | TCP 20/21 | User: `deepinnet`, Pass: `deepinnet`, Permissions: **RWDNL**. |
| **DNS Server**  | `192.168.1.4/24` | UDP/TCP 53| Records: `deep-in-net.local` -> `192.168.1.99` (A Record), `deep-in-net.com` -> `deep-in-net.local` (CNAME). |

#### Client Verification Commands
```cmd
# 1. Obtain dynamic IP assignment via DHCP
ipconfig /renew

# 2. Test DNS Resolution
nslookup deep-in-net.com

# 3. Test FTP Connection with deepinnet credentials
ftp 192.168.1.3
```

---

### 🛣️ Exercise 4 & 5: Router & Default Gateways
- **Goal**: Connect separate subnets via a Router and configure Default Gateways on all endpoint devices.
- **Addressing**:
  - Subnet A: `192.168.1.0/24`, Gateway: `192.168.1.1` (Router `Fa0/0`)
  - Subnet B: `192.168.2.0/24`, Gateway: `192.168.2.1` (Router `Fa0/1`)
- **Router Configuration**:
  ```ios
  enable
  configure terminal
  interface FastEthernet0/0
   ip address 192.168.1.1 255.255.255.0
   no shutdown
  interface FastEthernet0/1
   ip address 192.168.2.1 255.255.255.0
   no shutdown
  end
  ```

---

### 🔀 Exercise 6 & 7: Static Routing Tables
- **Goal**: Establish communication between Subnet 1 (`192.168.10.0/24`) and Subnet 2 (`192.168.20.0/24`) across multiple intermediate routers linked via `10.0.0.0/30`.
- **Static Route Commands**:
  - On Router 1: `ip route 192.168.20.0 255.255.255.0 10.0.0.2`
  - On Router 2: `ip route 192.168.10.0 255.255.255.0 10.0.0.1`

---

### 🕸️ Exercise 8: Interconnected 3-Subnet Mesh Topology
- **Goal**: Complete inter-subnet connectivity among 3 subnets (`Subnet 1`, `Subnet 2`, `Subnet 3`) using 3 routers with full mesh static routing.

---

## 🎓 Comprehensive Beginner-Friendly Audit Guide

### 1. Cabling & Networks (Exercise 1)
- **What is an RJ-45 cable?**
  *An RJ-45 (Registered Jack 45) is an 8-position, 8-contact (8P8C) modular plug at the end of twisted-pair Ethernet cables (Cat5e/Cat6). Analogous to a 3-prong wall plug for electricity, it carries 8 individual electrical wires delivering network data pulses.*
- **Straight-Through vs Crossover Cable?**
  - **Straight-Through** (T568B to T568B): Wired identically on both ends. Used to connect devices operating at **different OSI layers** (PC to Switch, Switch to Router), because switches automatically match transmit (TX) pins to receive (RX) pins.
  - **Crossover** (T568A to T568B): Transmit pins (1 & 2) on end A connect to receive pins (3 & 6) on end B. Used to connect **identical device tiers directly** (PC to PC, Switch to Switch). Like a walkie-talkie, speaker must connect to microphone!
- **How to Calculate Subnets Without Tools (Mental 4-Step Method)**:
  1. *Find Block Size*: $256 - \text{last octet of netmask}$. For mask `/26` (`255.255.255.192`), Block Size $= 256 - 192 = 64$.
  2. *List Subnet Ranges*: Count by $64$: `0..63`, `64..127`, `128..191`, `192..255`.
  3. *Locate IP*: For `192.168.1.150`, it falls in block `128..191`.
  4. *Identify Key IPs*:
     - **Network ID**: `192.168.1.128` (Subnet identifier)
     - **First Host**: `192.168.1.129`
     - **Last Host**: `192.168.1.190`
     - **Broadcast ID**: `192.168.1.191` (Sent to all hosts in subnet)

### 2. Switching vs Hubs (Exercise 2)
- **Hub (Layer 1 Physical)**: Acts like a megaphone in a classroom. When data enters one port, the hub broadcasts raw electrical signals out **all other ports**. Operates in **Half-Duplex** (one device talks at a time) with a **single shared collision domain**.
- **Switch (Layer 2 Data Link)**: Acts like a private mailroom. Inspects incoming frame **MAC Addresses**, learns them into a **MAC Address Table (CAM Table)**, and forwards frames **only to the destination port**. Operates in **Full-Duplex** (simultaneous send/receive) with **isolated collision domains per port**.

### 3. Core Protocols & Services (Exercise 3)
- **DHCP (UDP Ports 67/68)**: Automatically assigns IP addresses using the 4-step **DORA** process:
  1. **Discover**: Client broadcasts looking for a server.
  2. **Offer**: Server offers an IP (`192.168.1.100`).
  3. **Request**: Client requests the offered IP.
  4. **Acknowledge**: Server confirms assignment.
- **DNS (Port 53)**: Acts as the Internet's phonebook. Translates human domain names (`deep-in-net.com`) into IP addresses (`192.168.1.99`).
  - `A Record`: Domain $\rightarrow$ IPv4 address.
  - `CNAME Record`: Domain alias $\rightarrow$ another domain name (`deep-in-net.com` $\rightarrow$ `deep-in-net.local`).
- **HTTP vs HTTPS**:
  - **HTTP (Port 80)**: Plaintext, unencrypted data transfer.
  - **HTTPS (Port 443)**: Encrypted using SSL/TLS protocols for secure communication.
- **FTP (Ports 20/21)**: Transfers files via control channel (Port 21) and data channel (Port 20). User `deepinnet` configured with `RWDNL` (Read, Write, Delete, Name/Rename, List) permissions.
- **TCP vs UDP (Layer 4 Transport)**:
  - **TCP**: Connection-oriented (3-way handshake SYN $\rightarrow$ SYN-ACK $\rightarrow$ ACK), reliable delivery, error checking, retransmissions.
  - **UDP**: Connectionless, unreliable, low latency, no handshake. Used for streaming, VoIP, DNS, DHCP.
- **Ports**: 16-bit identifiers (0–65535) directing incoming network traffic to specific software applications (like room/apartment numbers in a building address).

### 4. Routing & Default Gateways (Exercises 4–8)
- **Router (Layer 3 Network)**: Connects different subnets and routes data packets based on IP addresses and internal **Routing Tables**.
- **Default Gateway**: The IP address of the local router interface that serves as the "exit door" for traffic destined for outside networks.
- **Routing Table**: A database stored on a router listing destination networks, subnet masks, next-hop IP addresses, and exit interfaces (`ip route 192.168.20.0 255.255.255.0 10.0.0.2`).

---

## ⚡ Quick Verification Command Checklist

Run these commands inside Packet Tracer command line / terminal to verify your topology:

```cmd
# Check local IP configuration
ipconfig /all

# Verify connectivity to gateway
ping 192.168.1.1

# Trace packet hop path across routers
traceroute 192.168.20.10

# Test web domain resolution
nslookup deep-in-net.com

# Verify FTP login and file listing
ftp 192.168.1.3
```

---

## 📄 License
This repository is open-sourced under the MIT License for educational and learning purposes.
