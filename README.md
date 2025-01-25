# Bash_monitoring_project

This repository contains scripts for network monitoring and graph generation using Bash and gnuplot.

## Features
- **Measure Latency**: Uses `ping` to measure the average latency to a remote server.
- **Monitor Traffic**: Retrieves incoming and outgoing traffic using `vnstat` and `jq`.
- **Count Active Connections**: Uses `netstat` to count active network connections.
- **Generate Graphs**: Visualizes collected data as a PNG graph with gnuplot.

## Requirements
The following tools are required to run the scripts:
- `bash` (default shell on Linux)
- `jq`
- `vnstat`
- `gnuplot`

Install them on a Debian/Ubuntu system with:
```bash
sudo apt update
sudo apt install jq vnstat gnuplot net-tools
```
## Notes on Safety and Privacy

- The files `GNU.txt` and `gnu.png` included in this repository were generated in a controlled environment (Ubuntu virtual machine) and do not contain sensitive information such as IP addresses or hostnames.
- If you generate these files in a different environment, ensure no personal or sensitive data is exposed before sharing.
