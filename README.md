# Surge

[![C++23](https://img.shields.io/badge/C++-23-blue.svg)](https://en.cppreference.com/w/cpp/23)
[![License](https://img.shields.io/badge/license-Surge%20Proprietary-red.svg)](LICENSE)

**High-performance realistic traffic generator. Scales to 50+ Gbps.**

Surge replays pcap/pcapng captures at line rate, generating realistic stateful
traffic with per-session TCP sequence/acknowledgment correction, IP/port mutation,
and IP ID generation — making traffic indistinguishable from real clients for
DPI/IDS testing. Built for network stress testing, DPI validation, and
infrastructure benchmarking.

---

## Features

| Feature | Description |
|---|---|
| **50+ Gbps** | Multi-threaded engine with CPU pinning and busy-polling |
| **Realistic Traffic** | Per-session TCP seq/ack correction, IP ID generation, randomized ISN |
| **pcap/pcapng** | Reads captures from tcpdump, Wireshark, and other tools |
| **QDISC bypass** | Skips kernel traffic control for maximum throughput |
| **TX_RING (packet_mmap)** | Optional zero-copy async TX mode (requires kernel/driver support) |
| **Auto-fallback** | Unsupported modes fall back automatically |
| **Rate limiting** | Per-thread rate control with hybrid sleep/spin waiting |
| **Live stats** | Real-time PPS, throughput, errors, and runtime |

---

## Important: Interface Requirements

> Surge can generate traffic on physical interfaces, virtual ethernet pairs (veth),
> bridge interfaces, bond interfaces, VLAN sub-interfaces, and other virtual
> interface types. **Only the Linux dummy interface (`dummy0`) is not supported**
> as it silently drops all transmitted packets.
>
> **Not supported:**
> - Dummy interfaces (`dummy0`, etc.)

---

## Installation

Download the latest `.deb` package from the
[Releases](https://github.com/Harry-Not-Potter/surge/releases) page:

```bash
sudo dpkg -i surge_*.deb
```

### Requirements

- Linux kernel 5.10+
- Root privileges for network access

---

## Usage

```bash
# Basic generation
sudo surge --generator \
    --interface eth0 \
    --pcap ./traffic.pcap \
    --workers 4 \
    --speed-limit 10000

# With TxRing mode
sudo surge --generator \
    --interface eth0 \
    --pcap ./traffic/ \
    --send-mode txring

# All options
surge --help
```

### CLI Options

| Option | Default | Description |
|---|---|---|
| `--interface <name>` | *required* | Network interface (**dummy not supported**) |
| `--pcap <path>` | *required* | PCAP/PCAPNG file or directory |
| `--workers <N>` | `1` | Worker threads |
| `--speed-limit <N>` | `0` (unlimited) | Throughput cap in Mbps |
| `--batch <N>` | `64` | Packets per sendmmsg call |
| `--send-mode <mode>` | `qdisc` | `qdisc` or `txring` |
| `--ip-pool-size <N>` | `512` | IP/port pool size, power of 2 |

---

## Performance

| Tactic | Impact |
|---|---|
| `SO_BUSY_POLL` | Reduces TX latency under load |
| `PACKET_QDISC_BYPASS` | Skips kernel traffic control |
| `TPACKET_V3 + packet_mmap` | Zero-copy async TX |
| CPU pinning | One thread per physical core |
| Per-session ISN | Randomized TCP sequence numbers |

---

## License

**Surge Proprietary License Agreement v1.0, July 2026**

Copyright (c) 2026 Harry-Not-Potter. All rights reserved.

Free installation and use from the original `.deb` package. Reverse engineering,
modification, and redistribution of modified binaries are prohibited.
Attribution required for public use, presentations, and distributions.

See [LICENSE](LICENSE) for full terms.

---

## Contact

harrynotpotter17th@gmail.com  
https://github.com/Harry-Not-Potter/surge