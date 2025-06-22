//
//  ViewController.swift
//  Weather app
//
//  Created by VAD on 08.02.2025.
//

import UIKit

class ViewController: UIViewController, WeatherViewModelProtocol {

    
    let viewModel = WeatherViewModel()

    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hightTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var chanseOfPrecipitationLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var conditionTextLabel: UILabel!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.requestLocation()

        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.delegate = self

        dailyForecastCollectionView.dataSource = self
        dailyForecastCollectionView.delegate = self

        hourlyForecastCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.identifier)
        dailyForecastCollectionView.register(DailyForecastCell.self, forCellWithReuseIdentifier: DailyForecastCell.identifier)
        
        hourlyForecastCollectionView.backgroundColor = .clear
        dailyForecastCollectionView.backgroundColor = .clear
        
    }
    // Update UI with new weather data

    func didUpdateWeather(_ weather: OpenWeatherResponse) {
        currentTempLabel.text = String(format: "%.0f°C", weather.current.temp)
        humidityLabel.text = "\(weather.current.humidity)%"
        windLabel.text = String(format: "%.0f m/s", weather.current.windSpeed)
        locationLabel.text = viewModel.city.capitalized

        // Weather description
        if let condition = weather.current.weather.first?.description {
            conditionTextLabel.text = condition.capitalized
        }

        if let firstDay = weather.daily.first {
            lowTempLabel.text = String(format: "%.0f°C", firstDay.temp.min)
            hightTempLabel.text = String(format: "%.0f°C", firstDay.temp.max)
            chanseOfPrecipitationLabel.text = String(format: "%.0f%%", firstDay.pop * 100)
        }

        viewModel.getConditionImage { [weak self] image in
            DispatchQueue.main.async {
                self?.conditionImage.image = image
            }
        }

        DispatchQueue.main.async {
            self.hourlyForecastCollectionView.reloadData()
            self.dailyForecastCollectionView.reloadData()
        }
    }

}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyForecastCollectionView {
            return viewModel.hourlyForecast?.count ?? 0
        } else {
            return viewModel.dailyForecast?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == hourlyForecastCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCell", for: indexPath) as? HourlyForecastCell,
                  let forecast = viewModel.hourlyForecast?[indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.configure(with: forecast)
            return cell

        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForecastCell", for: indexPath) as? DailyForecastCell,
                  let forecast = viewModel.dailyForecast?[indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.configure(with: forecast)
            return cell
        }
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == hourlyForecastCollectionView {
            let height = collectionView.frame.height - 8
            return CGSize(width: 60, height: height)
        } else {
            let height = collectionView.frame.height - 8
            return CGSize(width: 80, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}



