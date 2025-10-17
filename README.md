# Collision Probability Analysis (ISS vs FENGYUN-1C Debris)

This project demonstrates a simplified orbital collision risk assessment using:
- **Python (SGP4)** — to fetch real Two-Line Element (TLE) data from [CelesTrak](https://celestrak.org/NORAD/elements/) and propagate orbits into Earth-Centered Inertial (ECI) coordinates.
- **MATLAB (CARA Analysis Tool)** — to compute and visualize collision probability using NASA's 2D Foster and Hall methods.

## 🛰 Data Source
TLE data for:
- **ISS (ZARYA)** from `stations.txt`
- **FENGYUN 1C Debris** from `fengyun-1c-debris` group  
fetched directly from CelesTrak using Python's `requests` and `sgp4` libraries.

## 🧮 Workflow
1. Python: Fetch and propagate TLEs → output ECI positions and velocities.  
2. MATLAB: Compute Pc using `Pc2D_Foster` and `Pc2D_Hall` → visualize close-approach ellipse.  
3. Result: Comparison of Foster vs Hall Pc estimation for real orbital objects.

## 📊 Tools Used
- `sgp4`, `requests`, `numpy`
- NASA CARA Analysis Tool (DistributedMatlab/ProbabilityOfCollision)
- MATLAB Online (for 2D collision visualization)

## ⚙️ Run
```bash
# Python: fetch real orbital data
python fetch_tle_propagate.py
