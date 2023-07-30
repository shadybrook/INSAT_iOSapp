import Foundation
import CoreLocation

struct WeatherData: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let sunrise: Int
    let sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case sunrise
        case sunset
    }
}

struct Rain: Codable {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: WeatherData
    let wind: Wind
    let rain: Rain?
}

struct Weather: Codable {
    let description: String
}

struct Wind: Codable {
    let speed: Double
}

class WeatherManager: ObservableObject {
    private let openWeatherAPIKey = "53424305f0a38698c832b7b0d3ab2795"
    
    @Published var weatherDescription: String = ""
    @Published var temperature: Double = 0
    @Published var feelsLike: Double = 0
    @Published var tempMin: Double = 0
    @Published var tempMax: Double = 0
    @Published var pressure: Int = 0
    @Published var humidity: Int = 0
    @Published var sunrise: Int = 0
    @Published var sunset: Int = 0
    @Published var windSpeed: Double = 0
    @Published var rain: Double? = 0

    func fetchWeather(lat: Double, lon: Double) {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        fetchWeather(location: location)
    }

    func fetchWeather(location: CLLocationCoordinate2D) {
        Task {
            do {
                let weather = try await fetchWeatherAsync(location: location)
                DispatchQueue.main.async {
                    self.weatherDescription = weather.weather[0].description
                    self.temperature = weather.main.temp
                    self.feelsLike = weather.main.feelsLike
                    self.tempMin = weather.main.tempMin
                    self.tempMax = weather.main.tempMax
                    self.pressure = weather.main.pressure
                    self.humidity = weather.main.humidity
                    self.sunrise = weather.main.sunrise
                    self.sunset = weather.main.sunset
                    self.windSpeed = weather.wind.speed
                    self.rain = weather.rain?.oneHour
                }
            } catch {
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWeatherAsync(location: CLLocationCoordinate2D) async throws -> WeatherResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(openWeatherAPIKey)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        return decodedResponse
    }
}

