import UIKit

class HourlyForecastCell: UICollectionViewCell {
    
    static let identifier = "HourlyForecastCell"
    
    private let containerView = UIView()
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        timeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center

        tempLabel.font = .systemFont(ofSize: 14)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white // на всякий випадок для template rendering

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 6

        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(tempLabel)
        containerView.addSubview(stackView)
    }
    
    private func setupLayout() {
        [containerView, stackView, iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with forecast: HourlyWeather) {
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
        timeLabel.text = formatToHour(date)
        tempLabel.text = String(format: "%.0f°", forecast.temp)

        let iconCode = forecast.weather.first?.icon ?? ""
        let iconURL = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        NetworkManager.shared.downloadImage(url: iconURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }
    }
    
    private func formatToHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        timeLabel.text = nil
        tempLabel.text = nil
    }

}
