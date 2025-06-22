import Foundation
import UIKit
import CoreLocation

class WeatherViewModel: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: WeatherViewModelProtocol?
    
    var weather: OpenWeatherResponse?
    var hourlyForecast: [HourlyWeather]?
    var dailyForecast: [DailyWeather]?
    
    var city = "..."
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        // Retrieve city name using reverse geocoding
        let locale = Locale(identifier: "en_US") // English language
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            if let cityName = placemarks?.first?.locality {
                self.city = cityName
            }
        }

        
        getWeatherByCoordinates(lat: lat, lon: lon)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error:", error.localizedDescription)
        getData() // fallback
    }

    func getData(completion: (() -> Void)? = nil) {
        NetworkManager.shared.fetchCoordinates(for: city) { [weak self] geocode in
            guard let self = self, let geocode = geocode else {
                print("❌ Geocoding failed")
                return
            }
            self.getWeatherByCoordinates(lat: geocode.lat, lon: geocode.lon)
        }
    }
    
    func getWeatherByCoordinates(lat: Double, lon: Double) {
        NetworkManager.shared.fetchWeatherData(lat: lat, lon: lon) { [weak self] response in
            guard let self = self, let response = response else { return }
            self.weather = response
            self.hourlyForecast = response.hourly
            self.dailyForecast = response.daily
            
            DispatchQueue.main.async {
                self.delegate?.didUpdateWeather(response)
            }
        }
    }
    
    func getConditionImage(completion: @escaping (UIImage?) -> Void) {
        guard let iconCode = weather?.current.weather.first?.icon else {
            completion(nil)
            return
        }
        let url = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        NetworkManager.shared.downloadImage(url: url, completion: completion)
    }
}
