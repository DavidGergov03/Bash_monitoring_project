# Bash_monitoring_project
Scripts for network monitoring and graph generation using Bash and gnuplot.

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
