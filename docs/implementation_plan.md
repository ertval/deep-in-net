# Implementation Plan - deep-in-net

The `deep-in-net` project is a comprehensive networking assignment divided into 8 core exercises plus bonus work using **Cisco Packet Tracer**. It covers fundamental networking concepts including physical cabling, switches, hubs, OSI layers, network services (DHCP, DNS, HTTPS, FTP), routers, default gateways, subnetting, and static routing tables.

This plan details the setup, implementation steps, ready-to-run terminal and Packet Tracer CLI commands, beginner-friendly long-form explanations of all audit questions with real-world analogies, project documentation, agent guidelines (`AGENTS.md`), and proposed AI agent skills.

---

## User Review Required

> [!IMPORTANT]
> **Cisco Packet Tracer Execution Requirement**: Cisco Packet Tracer is a graphical/GUI network simulation software. `.pkt` files are binary simulation state files saved by Packet Tracer. While this plan provides exact CLI commands, configuration scripts, and IP addressing schemas to construct and verify all 8 exercises, the `.pkt` files must be opened and saved using Cisco Packet Tracer (or Packet Tracer CLI/GUI on Linux/WSL/Windows).

> [!TIP]
> **Audit Preparation**: The audit requires live recreation of Exercise 7 without external calculation tools. The expanded audit section below provides beginner-friendly, step-by-step mental subnetting formulas and fast CLI configuration sequences to pass this live test.

---

## Proposed Changes & File Operations

### Root Directory (`/home/ertval/code/zone-modules/deep-in-net/`)

#### [MODIFY] [README.md](file:///home/ertval/code/zone-modules/deep-in-net/README.md)
Update `README.md` with the newly expanded, educational, beginner-friendly audit question explanations, detailed diagrams, and step-by-step subnetting guides.

#### [MODIFY] [AGENTS.md](file:///home/ertval/code/zone-modules/deep-in-net/AGENTS.md)
Maintain coding agent rules and evaluation guidelines for `deep-in-net`.

---

## Ready Commands to Run: Setup & Environment Preparation

Run the following commands in bash to set up your repository environment, verify tools, and prepare submission files:

```bash
# 1. Navigate to the project root directory
cd /home/ertval/code/zone-modules/deep-in-net

# 2. Verify repository structure
ls -la docs/requirements/

# 3. Packet Tracer .pkt files must be constructed and saved from Cisco Packet Tracer GUI
# (Placeholder/empty files are rejected by verify_topology.sh)

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
  - `PC0`: `192.168.1.3 / 255.255.255.0` | `PC1`: `192.168.1.4 / 255.255.255.0` (Subnet: `192.168.1.0/24`)
  - `PC2`: `192.168.13.81 / 255.255.255.248` | `PC3`: `192.168.13.82 / 255.255.255.248` (Subnet: `192.168.13.80/29`)
  - `PC4`: `192.168.13.254 / 255.255.255.248` | `PC5`: `192.168.13.249 / 255.255.255.248` (Subnet: `192.168.13.248/29`)
- **Packet Tracer Verification**: From `PC0` Command Prompt:
  ```cmd
  ping 192.168.1.4
  ```

### Exercise 2: Switch vs Hub Operations
- **Topology**: 
  - Switch Network: 5 PCs (`S-PC1` through `S-PC5`) connected to a 2960 Switch via Copper Straight-Through cables. Subnet: `192.168.1.0/29` (given `S-PC5`: `192.168.1.5/29`).
  - Hub Network: 5 PCs (`H-PC1` through `H-PC5`) connected to a Generic Hub via Copper Straight-Through cables. Subnet: `192.168.1.192/27` (given `H-PC1`: `192.168.1.193/27`).
- **Packet Tracer Verification**:
  ```cmd
  ping 192.168.1.4
  ping 192.168.1.194
  ```

### Exercise 3: Core Network Services (DHCP, DNS, HTTPS, FTP)
- **Topology**: Cisco 2950-24 Switch connected to 4 Servers and 6 PCs (`PC0`–`PC5`).
- **Server Configuration & Static IPs**:
  1. **HTTPS Server**: `192.168.1.99 /24`
     - HTTP Service: **OFF**
     - HTTPS Service: **ON**
     - `index.html` content: hello message and login form
     - Disable DHCP, FTP, DNS on this server.
  2. **FTP Server**: `192.168.1.100 /24`
     - FTP Service: **ON**
     - User Credentials: `Username: deepinnet`, `Password: deepinnet`
     - Permissions: **RWDNL** (Read, Write, Delete, Name/Rename, List)
     - Disable HTTP, HTTPS, DHCP, DNS.
  3. **DNS Server**: `192.168.1.101 /24`
     - DNS Service: **ON**
     - Resource Records:
       - `deep-in-net.local` -> Type `A Record` -> `192.168.1.99`
       - `deep-in-net.com` -> Type `CNAME` -> `deep-in-net.local`
  4. **DHCP Server**: `192.168.1.102 /24`
     - Pool Name: `serverPool`
     - Default Gateway: `0.0.0.0`
     - DNS Server: `192.168.1.101`
     - Start IP: `192.168.1.10`, Netmask: `255.255.255.0`, Max users: `50`
     - Disable HTTP, HTTPS, FTP, DNS on this server.
- **Verification Commands (PC Command Prompt)**:
  ```cmd
  ipconfig /renew
  nslookup deep-in-net.com
  ftp 192.168.1.100
  ```

### Exercise 4: Single Router & Default Gateway
- **Topology**: `PC0` (`192.168.1.2/30`, GW `192.168.1.1`) -> Router `Fa0/0` | Router `Fa0/1` -> `PC1` (`192.168.2.2/30`, GW `192.168.2.1`).
- **Router CLI Configuration**:
  ```ios
  enable
  configure terminal
  interface FastEthernet0/0
   ip address 192.168.1.1 255.255.255.252
   no shutdown
  exit
  interface FastEthernet0/1
   ip address 192.168.2.1 255.255.255.252
   no shutdown
  exit
  end
  write memory
  ```

### Exercise 5: Inter-Subnet Communication with Switches and Router
- **Topology**: Switch 0 (`192.168.1.0/29`, 5 PCs) connected to Router 0 `Gig0/0` (`192.168.1.6/29`). Router 0 `Gig0/1` (`192.168.1.194/27`) connected to Switch 1 (`192.168.1.192/27`, 5 PCs).

### Exercise 6: Static Routing Between Routers
- **Topology**: PC1 (`192.168.1.2/24`) -> Router 1 (`Fa0/0`: `192.168.1.1`, `Se0/0/0`: `10.10.0.1/30`) -> Router 2 (`Se0/0/0`: `10.10.0.2/30`, `Fa0/0`: `192.168.2.1`) -> PC2 (`192.168.2.2/24`).
- **Router 1 CLI Config**:
  ```ios
  enable
  configure terminal
  interface FastEthernet0/0
   ip address 192.168.1.1 255.255.255.0
   no shutdown
  interface Serial0/0/0
   ip address 10.10.0.1 255.255.255.252
   clock rate 64000
   no shutdown
  exit
  ip route 192.168.2.0 255.255.255.0 10.10.0.2
  end
  ```
- **Router 2 CLI Config**:
  ```ios
  enable
  configure terminal
  interface FastEthernet0/0
   ip address 192.168.2.1 255.255.255.0
   no shutdown
  interface Serial0/0/0
   ip address 10.10.0.2 255.255.255.252
   no shutdown
  exit
  ip route 192.168.1.0 255.255.255.0 10.10.0.1
  end
  ```

### Exercise 7: Multi-Router Subnet Interconnection (Live Audit Task)
- **Topology**: 2 Routers, 2 Switched Subnets (`192.168.1.0/24` and `192.168.2.0/24`), inter-router serial link `10.10.0.0/30`. Static routing for full bidirectional reachability.

### Exercise 8: 3-Subnet Chain Static Routing Network
- **Topology**: 3 Routers in a chain: Router 1 (`192.168.1.192/26`, Serial `10.10.0.1/30`) <-> Router 2 (`Serial 10.10.0.2/30`, `192.168.2.0/24`, Serial `10.10.1.1/30`) <-> Router 3 (`Serial 10.10.1.2/30`, `192.168.3.160/28`). Full static routing reachability across all 3 LAN subnets.

---

## 🎓 Comprehensive Beginner-Friendly Audit Guide

This section is written specifically to help someone learning networking grasp the fundamental concepts deeply, with clear explanations, real-world analogies, and step-by-step breakdowns.

---

### 📦 Section 1: Physical Layer, Cables & Subnetting (Exercise 1)

#### 1.1 What is an RJ-45 Cable?
- **Detailed Explanation**: 
  `RJ-45` stands for **Registered Jack 45**. It is the standard physical connector used at the end of Ethernet network cables (like Cat5e or Cat6 cables) to connect computers, routers, switches, and other devices into a network.
- **Physical Structure**:
  Inside an Ethernet cable, there are **8 individual insulated copper wires**, twisted into 4 pairs. The RJ-45 plug holds these 8 wires in a row using a plastic connector called an **8P8C** (8 Position, 8 Contact) connector.
- **Analogous Example**: 
  Think of an RJ-45 connector as an 8-lane electrical plug for data. Just as a 3-prong wall plug delivers power to a home appliance, an 8-pin RJ-45 plug delivers high-speed electrical or optical data pulses between computers.

---

#### 1.2 What is the Difference Between Straight-Through and Crossover Cables?
To understand the difference, we must look at how network devices send and receive data:
- **Transmit (TX) pins**: Wires used to send electrical signals out.
- **Receive (RX) pins**: Wires used to listen for incoming electrical signals.

##### 1. Straight-Through Cable (T568B to T568B)
- **Pin Arrangement**: Pin 1 on end A connects to Pin 1 on end B, Pin 2 to Pin 2, Pin 3 to Pin 3, and Pin 6 to Pin 6. Both ends are wired identically.
- **When to Use**: Used to connect **different types of devices** (devices operating at different OSI layers), such as:
  - Computer to Switch
  - Switch to Router
  - Computer to Hub
- **Why It Works**: A switch is designed so its receiving pins align with a computer's transmitting pins. Therefore, a straight wire directly connects TX on the PC to RX on the Switch!

##### 2. Crossover Cable (T568A to T568B)
- **Pin Arrangement**: The transmit pins on one end cross over to connect to the receive pins on the other end:
  - Pin 1 (TX+) on End A $\rightarrow$ Pin 3 (RX+) on End B
  - Pin 2 (TX-) on End A $\rightarrow$ Pin 6 (RX-) on End B
- **When to Use**: Used to connect **similar types of devices** directly without an intermediate switch, such as:
  - Computer directly to Computer
  - Switch directly to Switch
  - Router directly to Router (or Router directly to PC interface)
- **Why It Works (Walkie-Talkie Analogy)**: 
  Imagine two people talking on walkie-talkies. If person A talks into their microphone (TX), person B must listen with their speaker (RX). If you connected person A's microphone directly to person B's microphone (Straight-Through between identical devices), neither would hear anything! Crossing the wires ensures speaker meets microphone.

---

#### 1.3 How are IP Addresses and Subnets Calculated Without Tools?
In the audit, you will be asked to calculate subnets on a piece of paper or whiteboard without online calculators. Here is the foolproof 4-step mental method:

##### Understanding the Anatomy of an IPv4 Address
An IPv4 address consists of **32 bits**, divided into 4 sections called **octets** (8 bits each), separated by dots (e.g., `192.168.1.50`).
- **Network Portion**: Identifies which network/neighborhood the device belongs to.
- **Host Portion**: Identifies the specific device in that neighborhood.
- **Subnet Mask**: Tells us where the network portion ends and the host portion begins (e.g., `255.255.255.0` or CIDR notation `/24`).

##### Step-by-Step Practical Example
Suppose the auditor gives you: **IP Address**: `192.168.1.150` with Subnet Mask `/26` (`255.255.255.192`).

1. **Find the Block Size (Magic Number)**:
   - Look at the last non-zero octet of the netmask. For `255.255.255.192`, the last octet is `192`.
   - Subtract this number from **256**:
     $$\text{Block Size} = 256 - 192 = 64$$
2. **List the Network Ranges (Counting by Block Size)**:
   - Starting from `0`, add the Block Size (`64`) repeatedly to find the start of each subnet:
     - Subnet 0: `192.168.1.0` to `192.168.1.63`
     - Subnet 1: `192.168.1.64` to `192.168.1.127`
     - Subnet 2: `192.168.1.128` to `192.168.1.191`
     - Subnet 3: `192.168.1.192` to `192.168.1.255`
3. **Locate Your IP Address**:
   - Our IP is `192.168.1.150`. It falls between `128` and `191` (Subnet 2).
4. **Identify the Key Addresses for Subnet 2**:
   - **Network ID (First IP in range)**: `192.168.1.128` (Used by routers to identify the subnet; cannot be assigned to PCs).
   - **First Usable Host IP**: `192.168.1.129` (First IP available for a computer or router interface).
   - **Last Usable Host IP**: `192.168.1.190` (Last IP available for a computer).
   - **Broadcast ID (Last IP in range)**: `192.168.1.191` (Used to send messages to ALL devices in this subnet; cannot be assigned to a single PC).

---

### 🔀 Section 2: Switches vs Hubs (Exercise 2)

#### 2.1 What is a Hub, How Does It Operate, and What is Its Role?
- **Definition**: A **Hub** is a basic hardware device used to connect multiple computers together in a network.
- **How It Operates**: 
  A hub has no intelligence or memory. When a computer sends a electrical data signal into Port 1 of a hub, the hub simply **re-amplifies and broadcasts (floods)** that exact signal out to **EVERY OTHER PORT** (Port 2, Port 3, Port 4), regardless of who the intended recipient is!
- **Analogy (Megaphone in a Classroom)**:
  Imagine 5 students in a room. If Student A wants to whisper a private message to Student B, but hands it to a hub, the hub shouts the message through a loud megaphone to the entire classroom. Everyone hears it, but only Student B processes it, while others ignore it.
- **Limitation (Collisions & Half-Duplex)**:
  Because all devices share the exact same electrical wire inside the hub, if two computers try to send data at the exact same moment, their signals collide and become corrupted (**Collision Domain**). Hubs must operate in **Half-Duplex** (only one device can transmit at a time).

---

#### 2.2 What is a Switch, How Does It Operate, and What is Its Role?
- **Definition**: A **Switch** is a smart networking device that connects computers on a Local Area Network (LAN) and intelligently routes data directly between source and destination.
- **How It Operates**: 
  When a switch powers on, it listens to incoming data frames and inspects their source **MAC Addresses** (hardware addresses built into network cards). It builds a memory table called a **MAC Address Table** (or **CAM Table**), matching MAC addresses to specific physical ports:
  - *Port 1 $\rightarrow$ Computer A (`AA:AA:AA:AA:AA:AA`)*
  - *Port 2 $\rightarrow$ Computer B (`BB:BB:BB:BB:BB:BB`)*
  When Computer A sends data meant for Computer B, the switch checks its table and forwards the frame **ONLY to Port 2**, leaving Ports 3 and 4 completely quiet!
- **Analogy (Private Post Office Box System)**:
  Instead of shouting through a megaphone, a switch acts like an attentive postal clerk. It inspects the recipient's name on the envelope, looks up their private mail slot number, and delivers the letter directly into that specific mailbox.
- **Advantage (Full-Duplex & Dedicated Bandwidth)**:
  Each port on a switch is its own separate collision domain. Devices can send and receive data at the exact same time without collisions (**Full-Duplex**).

---

#### 2.3 Comprehensive Comparison: Hub vs Switch

| Feature / Concept | Network Hub 📻 | Network Switch 🔀 |
|---|---|---|
| **OSI Layer** | **Layer 1** (Physical Layer) | **Layer 2** (Data Link Layer) |
| **Data Unit** | Electrical Bits / Signals | Data Frames |
| **Addressing Used** | None (Raw signals) | Hardware **MAC Addresses** |
| **Intelligence** | None (Dummy repeater) | High (Learns MAC addresses via CAM table) |
| **Traffic Delivery** | Broadcasts to ALL connected ports | Unicasts directly to destination port |
| **Collision Domains** | **Single shared collision domain** for all ports | **Separate collision domain** per port |
| **Communication Mode**| **Half-Duplex** (One device talks at a time) | **Full-Duplex** (Simultaneous send & receive) |
| **Security Risk** | High (Easily eavesdropped with packet sniffers)| High Security (Traffic isolated per port) |

---

### 🌐 Section 3: Core Network Protocols & Services (Exercise 3)

#### 3.1 What is a Server?
- **Explanation**: A **Server** is a computer or software program that sits on a network to "serve" resources, data, services, or programs to other computers (called **Clients**).
- **Analogy (Restaurant Service)**: 
  In a restaurant, customers (Clients) ask for food from the waiter/kitchen (Server). The server waits for requests, processes them, and returns the requested item (web pages, files, IP assignments).

---

#### 3.2 How Does DHCP Work? (Dynamic Host Configuration Protocol)
- **Role**: Automatically assigns IP addresses, netmasks, default gateways, and DNS server addresses to computers when they join a network, eliminating manual setup.
- **How It Operates (The DORA Process)**:
  DHCP operates over **UDP Ports 67 (Server) & 68 (Client)** using 4 distinct steps:

```
    [ Client PC ]                                      [ DHCP Server ]
          |                                                   |
          |-------- 1. DISCOVER (Broadcast: Help! Who is DHCP?) ->|
          |<------- 2. OFFER (Unicast: I have IP 192.168.1.100) --|
          |                                                   |
          |-------- 3. REQUEST (Broadcast: I'll take that IP!) ->|
          |<------- 4. ACKNOWLEDGE (Unicast: Confirmed! It's yours)|
```

1. **D - Discover**: The new PC turns on and broadcasts a message: *"Hello? Is there a DHCP server? I need an IP address!"*
2. **O - Offer**: The DHCP server responds: *"Hi! I have IP address 192.168.1.100 available. Would you like it?"*
3. **R - Request**: The PC replies: *"Yes, please! I would like to lease IP 192.168.1.100."*
4. **A - Acknowledge**: The server confirms: *"Great! IP 192.168.1.100 is leased to you for 24 hours, along with Gateway 192.168.1.1 and DNS 192.168.1.4."*

---

#### 3.3 What is DNS? (Domain Name System)
- **Role**: Acts as the **phonebook of the Internet**. Computers communicate using numerical IP addresses (`192.168.1.99`), but humans remember names (`deep-in-net.com`). DNS translates human-friendly names into IP addresses.
- **Analogy (Smartphone Contacts)**:
  You don't memorize your friend's 10-digit phone number; you tap their name "Alice" in your phone. Your phone looks up "Alice" in its contact list and dials `+1-555-0199`. DNS does the exact same thing for websites!

##### Common Types of DNS Records
- **`A` Record (Address Record)**: Maps a domain name directly to an IPv4 address.
  *Example: `deep-in-net.local` $\rightarrow$ `192.168.1.99`*
- **`AAAA` Record**: Maps a domain name to an IPv6 address.
- **`CNAME` Record (Canonical Name)**: Creates an alias pointing one domain name to another domain name.
  *Example: `deep-in-net.com` $\rightarrow$ `deep-in-net.local`* (When a user types `deep-in-net.com`, DNS looks up `deep-in-net.local`, which resolves to `192.168.1.99`).
- **`MX` Record (Mail Exchange)**: Specifies the mail server responsible for receiving emails for a domain.

---

#### 3.4 HTTP vs HTTPS: What is the Difference?
- **HTTP (Hypertext Transfer Protocol)**:
  - **Port**: TCP Port 80
  - **Security**: **Unencrypted / Plaintext**. Anyone sitting on the same network (e.g. public Wi-Fi) can intercept and read passcodes, usernames, and messages.
- **HTTPS (HTTP Secure)**:
  - **Port**: TCP Port 443
  - **Security**: **Encrypted using SSL/TLS**. All data sent between the web browser and web server is scrambled into unreadable mathematical code. Even if intercepted, an attacker sees only gibberish.

---

#### 3.5 What is FTP? (File Transfer Protocol)
- **Role**: A client-server protocol used specifically to upload, download, rename, list, and delete files on a remote server.
- **Operation**: FTP uses **two separate channels (ports)**:
  - **Control Channel (TCP Port 21)**: Used to send commands (login, change directory, delete file).
  - **Data Channel (TCP Port 20)**: Used to actually transmit the raw file contents.
- **Permissions (RWDNL)**:
  - **R**ead: Download files.
  - **W**rite: Upload new files.
  - **D**elete: Remove files from server.
  - **N**ame / Rename: Rename existing files.
  - **L**ist: View directory file listings.

---

#### 3.6 TCP vs UDP: Transport Layer Protocols

##### TCP (Transmission Control Protocol)
- **Characteristics**: Connection-oriented, highly reliable, ordered delivery, error checking, retransmission of lost packets.
- **How It Works (3-Way Handshake)**:
  Before sending data, TCP establishes a verified connection:
  1. Client sends **SYN** (*"Can we talk?"*)
  2. Server responds with **SYN-ACK** (*"Yes, I am ready!"*)
  3. Client sends **ACK** (*"Great, sending data now!"*)
- **Analogy**: A certified mail letter with return receipt requested. If a letter gets lost in transit, sender resends it until receipt is confirmed.
- **Used For**: Web browsing (HTTP/HTTPS), File transfers (FTP), Emails (SMTP).

##### UDP (User Datagram Protocol)
- **Characteristics**: Connectionless, unreliable (no guarantee of delivery), no handshake, zero retransmission, extremely fast and low-latency.
- **Analogy**: A physical postcard thrown into a mailbox. You hope it arrives, but you get no receipt and no confirmation.
- **Used For**: Live video streaming, online gaming, VoIP phone calls, DNS lookups, DHCP.

---

#### 3.7 What is a Network Port?
- **Explanation**: A **Port** is a 16-bit numerical channel (ranging from `0` to `65535`) assigned by an operating system to direct incoming network traffic to the correct software application.
- **Analogy (Apartment Building & Door Numbers)**:
  - **IP Address** = The physical street address of the apartment building (locates the computer).
  - **Port Number** = The specific apartment unit number (e.g. Apt 80 for Web Server, Apt 21 for FTP Server). Without port numbers, data would arrive at the computer building but wouldn't know which room to go into!

##### Core Services Protocol & Port Table

| Protocol | Service Name | Default Port | Transport Layer | OSI Layer |
|---|---|---|---|---|
| **DHCP** | Dynamic Host Configuration | Server: 67 / Client: 68 | UDP | Layer 7 (Application) |
| **DNS** | Domain Name System | 53 | UDP / TCP | Layer 7 (Application) |
| **HTTP** | Hypertext Transfer Protocol | 80 | TCP | Layer 7 (Application) |
| **HTTPS**| HTTP Secure | 443 | TCP | Layer 7 (Application) |
| **FTP** | File Transfer Protocol | 20 (Data) / 21 (Control) | TCP | Layer 7 (Application) |

---

### 🛣️ Section 4: Routers, Gateways & Static Routing (Exercises 4–8)

#### 4.1 What is a Router and What is Its Role?
- **Definition**: A **Router** is an intelligent Layer 3 device that connects two or more completely separate networks (subnets) and routes data packets between them based on destination IP addresses.
- **Role**: While switches connect computers *within* a single neighborhood, routers act as the highways connecting different towns and cities together!

---

#### 4.2 Switch vs Router: How Do They Differ?

| Feature | Layer 2 Switch 🔀 | Layer 3 Router 🛣️ |
|---|---|---|
| **Primary OSI Layer** | Layer 2 (Data Link) | Layer 3 (Network) |
| **Addressing** | Uses physical **MAC Addresses** | Uses logical **IP Addresses** |
| **Network Boundary** | Connects devices within the **SAME subnet** | Connects devices across **DIFFERENT subnets** |
| **Broadcast Domains** | Forwards broadcasts to all ports | **Blocks broadcasts** (Isolates broadcast domains) |
| **Table Used** | MAC Address Table (CAM Table) | **Routing Table** |

---

#### 4.3 What is a Default Gateway?
- **Explanation**: A **Default Gateway** is the IP address of a local router interface connected to your subnet. It serves as the "designated exit door" for any device wanting to send data outside its local network.
- **Analogy (Airport International Terminal)**:
  If you want to talk to your neighbor down the hall (same subnet), you walk across the hall directly. But if you want to travel to another country (different network), you MUST pass through the security gate at the International Airport (**Default Gateway**). If a PC has no Default Gateway configured, it cannot communicate with any device outside its own local subnet!

---

#### 4.4 What is a Routing Table and How Does It Work?
- **Definition**: A **Routing Table** is a data file stored inside a router's memory that lists destination networks, subnet masks, next-hop router IP addresses, and physical exit interfaces.
- **How a Router Uses It**:
  When an IP packet arrives at a router interface, the router reads the destination IP address (e.g. `192.168.20.10`), consults its routing table, and asks:
  *"Do I know how to reach network 192.168.20.0/24? Yes! The routing table says send it to Next-Hop IP 10.0.0.2 via interface Serial0/0/0."*

##### Example Static Route Command (Cisco IOS)
```ios
! Syntax: ip route <destination_network> <netmask> <next_hop_ip>
ip route 192.168.20.0 255.255.255.0 10.0.0.2
```
- **Explanation**: *"To reach any host on network `192.168.20.0` with subnet mask `255.255.255.0`, forward the packets to the router at IP address `10.0.0.2`."*

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
