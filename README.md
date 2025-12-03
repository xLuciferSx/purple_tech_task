# Weather Forecast – Tech Task

A simple SwiftUI + TCA application that displays a 7-day weather forecast based on the user’s current location.  
Supports offline caching and basic network status feedback.

---

## Setup

1. Open `Purple Tech Task.xcodeproj` in Xcode.
2. Wait for Swift Package Manager to finish resolving dependencies.
   > Note: the app may appear stuck on the first build while SPM resolves.
3. Select an iOS simulator (iPhone 15 or newer recommended).
4. Build & run (`⌘ + R`).

---

## Features

- Fetches current location using **CoreLocation**
- Gets 7-day forecast from **Open-Meteo API**
- Automatic **offline caching** of the last successful forecast
- Shows **“Last updated”** when using cached data
- Snackbar notifications:
  - No internet
  - Back online

---

## Known Issue

Network monitoring has a small bug on the initial app launch:

- The first network status event may not fire until the app is moved to background and returned to foreground.
- After that, online/offline detection works normally.

This is related to `NWPathMonitor` initialization during early dependency loading.

---
