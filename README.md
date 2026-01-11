# Impact Analysis of High Solar PV Penetration on LV Distribution Networks

## Project Overview
This project simulates the impact of high rooftop Solar PV penetration on a typical Sri Lankan Low Voltage (LV) distribution feeder. Using MATLAB/Simscape Electrical, the model demonstrates the "Reverse Power Flow" phenomenon, where excess solar generation during peak irradiance hours causes the feeder voltage to rise beyond statutory limits.

The simulation integrates real-world environmental data from the NASA POWER API to create an accurate daily generation profile, validating the correlation between peak solar irradiance and grid voltage violations.

## Key Objectives
* **Model a Low Voltage Feeder:** Simulate a standard 400V distribution line using Aerial Bundled Cable (ABC) parameters.
* **Integrate Real-World Data:** Automate the retrieval of hourly solar irradiance and temperature data via the NASA POWER API.
* **Analyze Voltage Rise:** Quantify the voltage increase at the consumer end during peak noon hours.
* **Verify Compliance:** Compare the simulated voltage against the CEB (Ceylon Electricity Board) statutory limit of 230V +/- 6%.

## Technical Implementation

### System Model
* **Grid Source:** 400V (Ph-Ph), 50Hz Three-Phase Source representing the distribution transformer.
* **Transmission Line:** 500m length modeled with lumped parameter RLC branches (Resistance: 0.443 Ohm/km, Inductance: 0.25 mH/km).
* **Load Profile:** Static residential load (RLC) combined with a dynamic current injection source representing the solar inverter.
* **Solver Configuration:** Phasor mode simulation (50Hz) used for efficient 24-hour load flow analysis.

### Data Acquisition
* **Source:** NASA Prediction of Worldwide Energy Resources (POWER) API.
* **Method:** A MATLAB script (`prepare_nasa_data.m`) fetches hourly `ALLSKY_SFC_SW_DWN` (Solar Irradiance) data for Colombo, Sri Lanka (Lat: 6.9271, Lon: 79.8612).
* **Processing:** Raw CSV data is parsed and converted into a MATLAB `timeseries` object for Simulink integration.

## Prerequisites
* MATLAB (R2021a or later recommended)
* Simulink
* Simscape
* Simscape Electrical (Specialized Power Systems)

## Installation and Usage

1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/yourusername/solar-voltage-rise-study.git](https://github.com/yourusername/solar-voltage-rise-study.git)
    cd solar-voltage-rise-study
    ```

2.  **Fetch Solar Data**
    * Open `prepare_nasa_data.m` in MATLAB.
    * Run the script to download the latest solar profile from NASA.
    * Verify that the `solar_profile` variable appears in the MATLAB Workspace.

3.  **Run the Simulation**
    * Open `Solar_Voltage_Project.slx` in Simulink.
    * Ensure the Stop Time is set to `86400` (24 hours).
    * Click **Run**.

4.  **View Results**
    * Open the Scope block to observe the voltage profile.
    * The graph displays the Feeder Voltage (Blue) against the Statutory Limit (Orange).

## Results
The simulation confirms that under high penetration scenarios (approx. 5kW injection per node):
* **Base Voltage:** Maintains ~228V RMS during non-generating hours.
* **Peak Voltage:** Rises to approximately 247V RMS at 12:00 PM.
* **Conclusion:** The voltage exceeds the statutory upper limit (243.8V), indicating a potential for inverter tripping or equipment stress without active voltage regulation (Volt-Watt control).

## File Structure
* `Solar_Voltage_Project.slx` - The main Simscape Electrical model.
* `prepare_nasa_data.m` - MATLAB script for API data retrieval and processing.
* `nasa_solar_data.csv` - Cached dataset example for offline testing.
* `README.md` - Project documentation.

## Acknowledgments
* NASA POWER Project for providing open-access solar and meteorological data.
