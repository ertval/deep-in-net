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

## 🎯 Audit Questions & Reference Answers

Below is the definitive study guide for all questions asked during evaluation:

### 1. Cabling & Networks
- **What is an RJ-45 cable?**
  *An 8-pin/8-contact (8P8C) modular connector used for Ethernet networking over twisted-pair cables.*
- **Straight-Through vs Crossover Cable?**
  - **Straight-Through** (T568B to T568B): Connects different device tiers (PC to Switch, Switch to Router).
  - **Crossover** (T568A to T568B): Connects identical device tiers directly (PC to PC, Switch to Switch).

### 2. Switching vs Hubs
- **Switch**: Layer 2 Data Link device. Learns MAC addresses into a CAM table, providing dedicated bandwidth per port without collisions.
- **Hub**: Layer 1 Physical device. Multi-port signal repeater; broadcasts all incoming traffic to all ports (half-duplex, single collision domain).

### 3. Protocols & OSI Layers
| Protocol | Full Name | OSI Layer | Port(s) | Role |
|---|---|---|---|---|
| **DHCP** | Dynamic Host Configuration Protocol | Layer 7 (Application) | 67 / 68 (UDP) | Automatic IP allocation |
| **DNS** | Domain Name System | Layer 7 (Application) | 53 (UDP/TCP) | Domain name to IP translation |
| **HTTP** | Hypertext Transfer Protocol | Layer 7 (Application) | 80 (TCP) | Unencrypted web transfer |
| **HTTPS**| HTTP Secure | Layer 7 (Application) | 443 (TCP) | TLS/SSL encrypted web transfer |
| **FTP** | File Transfer Protocol | Layer 7 (Application) | 20 / 21 (TCP) | File upload / download |
| **TCP** | Transmission Control Protocol | Layer 4 (Transport) | N/A | Connection-oriented, reliable |
| **UDP** | User Datagram Protocol | Layer 4 (Transport) | N/A | Connectionless, low latency |

### 4. Routing & Subnetting without Tools
- **Subnetting Calculation Method**:
  1. Identify netmask bits (e.g. `/26` = `255.255.255.192`).
  2. Calculate Block Size: $256 - 192 = 64$.
  3. Determine Subnets: `0..63`, `64..127`, `128..191`, `192..255`.
  4. Network ID is the start of block; Broadcast ID is the last IP in block.

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
