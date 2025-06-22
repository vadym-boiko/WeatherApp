import Foundation
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let apiKey = "acc871a3df33fd95bfd52ce972ab1052"
    
    /// Geocoding: city → coordinates
    func fetchCoordinates(for city: String, completion: @escaping (GeocodingResponse?) -> Void) {
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let geocodingURL = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityEncoded)&limit=1&appid=\(apiKey)"
        
        guard let url = URL(string: geocodingURL) else {
            print("❌ Invalid geocoding URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("❌ Error fetching coordinates")
                completion(nil)
                return
            }
            
            do {
                let locations = try JSONDecoder().decode([GeocodingResponse].self, from: data)
                completion(locations.first)
            } catch {
                print("❌ Geocoding decode error:", error)
                completion(nil)
            }
        }.resume()
    }
    
    /// Fetch weather by coordinates
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (OpenWeatherResponse?) -> Void) {
        let weatherURL = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&exclude=minutely,alerts&current=true&hourly=true&daily=true"

        guard let url = URL(string: weatherURL) else {
            print("❌ Invalid weather URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("❌ Error fetching weather")
                completion(nil)
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                completion(weather)
            } catch {
                print("❌ Weather decode error:", error)
                completion(nil)
            }
        }.resume()
    }
    
    /// Download weather icon image
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        let fullUrlString = url.hasPrefix("http") ? url : "https:\(url)"
        
        guard let url = URL(string: fullUrlString) else {
            print("❌ URL conversion error")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("❌ Failed to retrieve image")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
