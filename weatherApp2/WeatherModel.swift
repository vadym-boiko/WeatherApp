import Foundation

struct GeocodingResponse: Codable {
    let name: String
    let lat: Double
    let lon: Double
}

struct OpenWeatherResponse: Codable {
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [WeatherCondition]

    enum CodingKeys: String, CodingKey {
        case temp, humidity, weather
        case windSpeed = "wind_speed"
    }
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let weather: [WeatherCondition]
}

struct DailyWeather: Codable {
    let dt: Int
    let temp: TempRange
    let weather: [WeatherCondition]
    let humidity: Int
    let windSpeed: Double
    let pop: Double

    enum CodingKeys: String, CodingKey {
        case dt, temp, weather, humidity, pop
        case windSpeed = "wind_speed"
    }
}

struct TempRange: Codable {
    let min: Double
    let max: Double
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}
