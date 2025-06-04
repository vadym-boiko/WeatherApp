//
//  Protocols.swift
//  weatherApp2
//
//  Created by VAD on 22.04.2025.
//

import Foundation

protocol WeatherViewModelProtocol: AnyObject {
    func didUpdateWeather(_ weather: OpenWeatherResponse)
}
