Dashy IoT based solar power monitoring system

An open-source IoT solution for real-time monitoring and analysis of solar photovoltaic (PV) systems. Designed to track key performance metrics, enhance energy efficiency, and provide actionable insights through a user-friendly web dashboard.
GitHub

Overview
This project implements a real-time monitoring system for solar power plants, integrating microcontrollers and single-board computers to collect, process, and visualize data. Inspired by research conducted at the Engineering Physics Department of Institut Teknologi Sepuluh Nopember (ITS), the system aims to assess the performance and efficiency of solar power plants under real environmental conditions .It's sensor or smart meters measure power generation, daily energy consumption, battery charge or discharge and inverters efficiency. The system is designed to be scalable, flexible, and adaptable to various solar power plant configurations.And communication module via Wi-Fi or Ethernet to send data to the cloud for further analysis and visualization.For Live Data Visualization Real-time graphs will be implemented for voltage, current, power, and environmental parameters.

Features
Real-Time Monitoring: Continuously tracks voltage, current, power output, and environmental conditions.

Data Logging: Stores historical trends data for performance analysis and reporting(daily/weekly/monthly).

Web Dashboard: Interactive interface displaying live metrics, trends, and system status.

Alerts & Notifications: Configurable alerts for anomalies or performance issues(faults or underperformance).

Remote Access: Monitor system performance from any location via the internet.

What it monitors:
Energy produced
Energy consumed
battery level and activity(charges/discharges)
System uptime/performance
Grid interaction (imported/exported energy)

Hardware Components

Microcontroller: ATmega32 or Arduino Nano for sensor data acquisition.

Single-Board Computer: Raspberry Pi for data processing and web server hosting.

Sensors:

Voltage Sensor (e.g., Voltage Divider)

Current Sensor (e.g., ACS712)

Light Intensity Sensor (e.g., LDR)

Temperature & Humidity Sensor (e.g., DHT11/DHT22)

Communication Module: NRF24L01 for wireless data transmission between microcontroller and Raspberry Pi.

Sensor Integration Overview
To effectively monitor and optimize solar power systems, it's essential to integrate appropriate sensors that capture critical parameters. Here's a step-by-step guide:

1. Identify Key Parameters
   Determine the essential metrics for monitoring:

Electrical Metrics: Voltage, current, and power output.

Environmental Conditions: Solar irradiance, temperature, and humidity.

System Health: Battery status and panel efficiency.

2. Select Suitable Sensors
   Choose sensors that align with the identified parameters:

Voltage Measurement: Voltage Divider Circuit.

Current Measurement: ACS712 or ACS758.

Solar Irradiance: Light Dependent Resistor (LDR) or Photodiode.

Temperature & Humidity: DHT11 or DHT22.

Battery Monitoring: INA219 for voltage and current.

3. Connect Sensors to Microcontroller
   Utilize a microcontroller like ESP32 or Arduino Nano:

Wiring: Connect sensor outputs to appropriate analog or digital pins.

Power Supply: Ensure sensors receive correct voltage (typically 3.3V or 5V).

Signal Conditioning: Use resistors or capacitors if necessary to stabilize signals.

4. Develop Firmware for Data Acquisition
   Program your microcontroller to read sensor data:

Libraries: Incorporate relevant libraries for sensor communication.

Data Reading: Implement functions to read and process sensor outputs.

Error Handling: Include checks to handle sensor malfunctions or anomalies.

5. Implement Data Transmission
   Transmit collected data to a central system or cloud platform:

Communication Protocols: Use MQTT, HTTP, or WebSockets.

Connectivity: Ensure stable Wi-Fi or cellular connections for data transfer.

Data Formatting: Structure data in JSON or XML for compatibility.

6. Set Up Data Storage and Visualization
   Store and visualize the data for analysis:

Databases: Use Firebase, InfluxDB, or MySQL.

Dashboards: Implement platforms like Grafana or develop custom web interfaces.

Alerts: Configure notifications for parameter thresholds.

Installation & Setup
Hardware Assembly:

Connect sensors to the microcontroller as per the wiring diagram.

Establish communication between the microcontroller and Raspberry Pi using NRF24L01 modules.

Hardware Setup

1. ESP32 Development Board:

Ensure your ESP32 is flashed with the Espruino firmware.

2. Sensor Connections:

DHT22 (Temperature & Humidity Sensor):

VCC → ESP32 3.3V

GND → ESP32 GND

DATA → ESP32 GPIO4

Note: Use a 10kΩ pull-up resistor between VCC and DATA lines.
Esp Boards
+2
Espruino
+2
EzloPi
+2
Random Nerd Tutorials

INA219 (Voltage & Current Sensor):

VCC → ESP32 3.3V

GND → ESP32 GND

SDA → ESP32 GPIO21

SCL → ESP32 GPIO22

ACS712 (Current Sensor):

VCC → ESP32 5V

GND → ESP32 GND

OUT → ESP32 GPIO36 (ADC1_CH0)

Note: Ensure the output voltage does not exceed the ESP32's ADC input range (0–3.3V).

📦 Required Modules
Espruino provides built-in modules for various sensors:

DHT22 Module: For reading temperature and humidity.

INA219 Module: For voltage, current, and power measurements.

ADC Reading: For analog voltage readings from ACS712.

Ensure these modules are available in your Espruino environment.

🧾 Combined JavaScript Code
javascript
Copy
Edit
// Initialize I2C for INA219
I2C1.setup({scl: 22, sda: 21});
const ina219 = require("INA219").connect(I2C1);

// Initialize DHT22 on GPIO4
const dht = require("DHT22").connect(D4);

// ACS712 connected to GPIO36 (ADC1_CH0)
const ACS712_PIN = 36;
const ACS712_SENSITIVITY = 0.185; // V/A for 5A module
const V_REF = 3.3; // Reference voltage

function readSensors() {
// Read DHT22
dht.read(function (a) {
console.log("Temperature: " + a.temp.toFixed(2) + "°C");
console.log("Humidity: " + a.rh.toFixed(2) + "%");
});

// Read INA219
ina219.getBusVoltage(function (voltage) {
ina219.getCurrent(function (current) {
ina219.getPower(function (power) {
console.log("Voltage: " + voltage.toFixed(2) + " V");
console.log("Current: " + current.toFixed(2) + " mA");
console.log("Power: " + power.toFixed(2) + " mW");
});
});
});

// Read ACS712
var adcValue = analogRead(ACS712_PIN);
var voltage = adcValue \* V_REF;
var current = (voltage - (V_REF / 2)) / ACS712_SENSITIVITY;
console.log("ACS712 Current: " + current.toFixed(2) + " A");

console.log("-----------------------------");
}

// Read sensors every 2 seconds
setInterval(readSensors, 2000);
🌐 Optional: Web Interface
To visualize the sensor data on a web page, you can set up a simple HTTP server:

Microcontroller Firmware:

Program the microcontroller with the provided firmware to read sensor data and transmit it wirelessly.

Raspberry Pi Configuration:

Install necessary libraries and dependencies.

Set up the web server and database.

Deploy the dashboard application.

Dashboard Features
Live Data Visualization: Real-time graphs for voltage, current, power, and environmental parameters.

Historical Data Access: View and analyze past performance metrics.

System Alerts: Notifications for predefined thresholds and anomalies.

User Authentication: Secure access to dashboard features.

Why it is important:
This project is important because it provides a comprehensive solution for monitoring and managing renewable energy systems.

Helps identify isues early (panel shading , overheating,dirt/fault or inverter failure) .
Improves energy efficiency and reduces energy waste.
Helps maximize return on investment (ROI) for renewable energy systems.
Useful for planning future upgrades like adding batteries.
