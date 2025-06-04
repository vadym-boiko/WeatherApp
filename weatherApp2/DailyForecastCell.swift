//
//  DailyForecastCell.swift
//  weatherApp2
//
//  Created by VAD on 16.05.2025.
//

import Foundation
import UIKit
import UIKit

class DailyForecastCell: UICollectionViewCell {
    
    static let identifier = "DailyForecastCell"
    
    
    private let dayLabel = UILabel()
    private let dateLabel = UILabel()
    private let tempLabel = UILabel()
    private let iconImageView = UIImageView()
    private let containerView = UIView()
    private let stackView = UIStackView()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        containerView.clipsToBounds = true

        
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.backgroundColor = .clear

        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        containerView.clipsToBounds = true
        
        dayLabel.textColor = .white
        dayLabel.font = .systemFont(ofSize: 14, weight: .bold)
        dayLabel.textAlignment = .center

        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textAlignment = .center

        tempLabel.textColor = .white
        tempLabel.font = .systemFont(ofSize: 14)
        tempLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit

        contentView.addSubview(containerView)
        [dayLabel, dateLabel, iconImageView, tempLabel].forEach { containerView.addSubview($0)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 6

        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(tempLabel)

        containerView.addSubview(stackView)

        }
    }

    private func setupLayout() {
        [containerView, dayLabel, dateLabel, tempLabel, iconImageView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
        ])

    }

    func configure(with forecast: DailyWeather) {
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
        dayLabel.text = formatToDayName(date)
        dateLabel.text = formatToDayAndMonth(date)
        tempLabel.text = String(format: "%.0f° / %.0f°", forecast.temp.min, forecast.temp.max)

        let iconCode = forecast.weather.first?.icon ?? ""
        let iconURL = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        NetworkManager.shared.downloadImage(url: iconURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }
    }

    private func formatToDayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "E"
        return formatter.string(from: date).capitalized
    }

    private func formatToDayAndMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        tempLabel.text = nil
        dayLabel.text = nil
        dateLabel.text = nil
    }

}
