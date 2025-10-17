# === Import Required Libraries ===
import requests
from sgp4.api import Satrec, jday
import numpy as np

# === Function to Fetch TLE from CelesTrak ===
def fetch_tle(satellite_name, url):
    """
    Fetches the first TLE entry from a given CelesTrak URL
    """
    response = requests.get(url)
    data = response.text.strip().splitlines()

    # Each TLE is 3 lines: name, line1, line2
    for i in range(len(data)):
        if satellite_name.upper() in data[i].upper():
            return data[i], data[i+1], data[i+2]
    raise ValueError(f"Satellite {satellite_name} not found in TLE list.")

# === Example URLs from CelesTrak ===
url_stations = "https://celestrak.org/NORAD/elements/stations.txt"
url_fy1c = "https://celestrak.org/NORAD/elements/gp.php?GROUP=fengyun-1c-debris&FORMAT=tle"

# === Fetch TLEs Automatically ===
tle_iss = fetch_tle("ISS (ZARYA)", url_stations)
tle_fy1c = fetch_tle("FENGYUN 1C DEB", url_fy1c)

print("ISS TLE:")
print(tle_iss)
print("\nFENGYUN 1C DEB TLE:")
print(tle_fy1c)

# === Convert to Satellite Objects ===
sat1 = Satrec.twoline2rv(tle_iss[1], tle_iss[2])
sat2 = Satrec.twoline2rv(tle_fy1c[1], tle_fy1c[2])

# === Choose Propagation Time (UTC) ===
year, month, day, hour, minute, second = 2025, 10, 16, 12, 0, 0
jd, fr = jday(year, month, day, hour, minute, second)

# === Propagate to Get ECI Position and Velocity ===
_, r1, v1 = sat1.sgp4(jd, fr)
_, r2, v2 = sat2.sgp4(jd, fr)

# === Convert km → meters ===
r1 = np.array(r1) * 1000
v1 = np.array(v1) * 1000
r2 = np.array(r2) * 1000
v2 = np.array(v2) * 1000

# === Print Results ===
print("\n=== Propagated ECI States ===")
print("ISS Position (m):", r1)
print("ISS Velocity (m/s):", v1)
print("\nFENGYUN 1C DEB Position (m):", r2)
print("FENGYUN 1C DEB Velocity (m/s):", v2)