#!/bin/bash

export LC_NUMERIC="C"

# Define the log file paths
LOG_FILE="./GNU.txt"
OUTPUT_FILE="gnu.png"

# Function to measure latency
measure_latency() {
    ping -c 5 google.com | grep 'avg' | awk -F'/' '{print $5}'
}

# Function to measure traffic (incoming and outgoing) using jq with vnstat JSON output
measure_traffic() {
    # Use vnstat in JSON format and parse with jq to get only incoming and outgoing data
    vnstat --json 2>/dev/null | jq -r '.interfaces[0].traffic.total.rx, .interfaces[0].traffic.total.tx'
}

# Function to measure active connections
measure_active_connections() {
    netstat -an | grep 'ESTABLISHED' | wc -l
}

# Function to log data to a file
log_data() {
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    latency=$(measure_latency)

    # Debug latency
    echo "Latency: $latency"

    # Get traffic data and handle unexpected formatting
    traffic=($(measure_traffic))
    echo "Raw Traffic Data: ${traffic[@]}"  # Debugging line

    # Ensure traffic data is valid
    if [[ -z "${traffic[0]}" || -z "${traffic[1]}" ]]; then
        echo "Error: Unable to fetch traffic data. Skipping this log entry."
        return
    fi

    # Replace commas with dots if necessary and convert to MB
    incoming_traffic=$(printf "%.2f" "$(echo "${traffic[0]}" | sed 's/,/./' | awk '{print $1 / 1048576}')")
    outgoing_traffic=$(printf "%.2f" "$(echo "${traffic[1]}" | sed 's/,/./' | awk '{print $1 / 1048576}')")

    # Debug traffic
    echo "Incoming Traffic (MB): $incoming_traffic"
    echo "Outgoing Traffic (MB): $outgoing_traffic"

    active_connections=$(measure_active_connections)

    # Debug active connections
    echo "Active Connections: $active_connections"

    # Log the data in space-separated format for easy gnuplot parsing
    echo "$timestamp $latency $incoming_traffic $outgoing_traffic $active_connections" >> "$LOG_FILE"
}

# Remove the old log file if it exists to create a new one
rm -f "$LOG_FILE"

# Ensure the log file exists (create if not)
touch "$LOG_FILE"

# Run the log_data function every 10 seconds
echo "Collecting data... Press Ctrl+C to stop."

# Collect data for a period of time (e.g., 1 hour) for testing purposes
for ((i=0; i<3600; i+=10)); do
    log_data
    sleep 10
done

# Generate the gnuplot script for creating the graph
GNUPLOT_SCRIPT=$(mktemp)

# Write gnuplot commands to the temporary script
cat << EOF > "$GNUPLOT_SCRIPT"
set terminal pngcairo enhanced size 800,600
set output "$OUTPUT_FILE"
set title "Network Monitoring Data"
set xlabel "Time"
set ylabel "Latency (ms)"
set y2label "Traffic (MB) / Active Connections"
set y2tics

# Format the timestamp on the x-axis
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M:%S"
set xtics rotate by -45

# Set logarithmic scale for the secondary y-axis (y2) for Traffic and Active Connections
set logscale y2

# Plot latency on the primary y-axis and traffic on the secondary y-axis
plot "$LOG_FILE" using 1:2 title "Latency (ms)" with lines lw 2, \
     "$LOG_FILE" using 1:3 axes x1y2 title "Incoming Traffic (MB)" with lines lw 2, \
     "$LOG_FILE" using 1:4 axes x1y2 title "Outgoing Traffic (MB)" with lines lw 2, \
     "$LOG_FILE" using 1:5 axes x1y2 title "Active Connections" with lines lw 2
EOF

# Run the gnuplot script to generate the PNG file
gnuplot "$GNUPLOT_SCRIPT"

# Remove the temporary gnuplot script
rm -f "$GNUPLOT_SCRIPT"

# Inform the user about the output
echo "Graph has been saved as $OUTPUT_FILE"
