#!/bin/bash

# Define the input and output files
LOG_FILE="./GNU.txt"
OUTPUT_FILE="gnu.png"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file $LOG_FILE not found. Please ensure the log data has been collected."
    exit 1
fi

# Create the gnuplot script
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
