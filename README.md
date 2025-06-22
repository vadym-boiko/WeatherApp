# 🌤 WeatherApp2

**WeatherApp2** is a simple iOS weather application built with UIKit that displays the current weather, hourly, and daily forecasts using the [OpenWeather One Call API 3.0](https://openweathermap.org/api/one-call-3). The app uses Core Location to automatically determine your city and display weather data for it.

---

## 🔧 Technologies Used

- Swift 5
- UIKit
- CoreLocation
- URLSession
- CollectionView (custom cells in code)
- OpenWeather API
- MVVM-inspired architecture

---

## ⚙ Features

- Detects user location using CoreLocation
- Displays:
  - Current temperature and condition
  - Max/Min daily temperature
  - Humidity, wind speed, and chance of precipitation
- Scrollable hourly and daily forecast collections
- Downloads and displays condition icons dynamically

---

## 📁 Project Structure

- `ViewController.swift`: Main view controller showing all weather data
- `WeatherViewModel.swift`: Handles fetching location and weather data
- `HourlyForecastCell.swift` & `DailyForecastCell.swift`: Custom cells for forecasts
- `NetworkManager.swift`: Centralized network logic
- `Models.swift`: Codable structs for API responses
- `Protocols.swift`: Delegate protocol for ViewModel updates

