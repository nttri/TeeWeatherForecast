//
//  AirPollutionSingleIndexView.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 16/10/2022.
//

import UIKit

final class AirPollutionSingleIndexView: UIView {
    
    // MARK: - Properties
    
    private var indexLabel: UILabel!
    private let viewHeight: CGFloat = 48.0
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Configuration
    
    func updateView(with indexType: AirPollutionIndexType) {
        indexLabel.text = indexType.description
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemGreen.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemRed.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
        
        drawIndexPointer(from: indexType.level)
    }
}

private extension AirPollutionSingleIndexView {
    func configure() {
        indexLabel = UILabel()
        indexLabel.font = .preferredFont(forTextStyle: .body)
        indexLabel.textColor = .black
        indexLabel.textAlignment = .center
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(indexLabel)
        indexLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indexLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = viewHeight * 0.5
        layer.shadowOpacity = 0.3
    }
    
    func getColor(from level: AirPollutionIndexType.Level) -> UIColor {
        switch level {
        case .bad: return .systemRed
        case .medium: return .systemYellow
        case .good: return .systemGreen
        }
    }
    
    func drawIndexPointer(from level: AirPollutionIndexType.Level) {
        let pointerSize: CGFloat = 14.0
        let offsetFromPointer: CGFloat = 8.0
        var xStart: CGFloat = 0
        
        switch level {
        case .good:
            xStart = bounds.width/6         // mid of 1st range
        case .medium:
            xStart = bounds.width/2         // mid of 2st range
        case .bad:
            xStart = (bounds.width*5)/6     // mid of 3st range
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xStart, y: offsetFromPointer))
        path.addLine(to: CGPoint(x: xStart - (pointerSize/2), y: -pointerSize + offsetFromPointer))
        path.addLine(to: CGPoint(x: xStart + (pointerSize/2), y: -pointerSize + offsetFromPointer))
        path.addLine(to: CGPoint(x: xStart, y: offsetFromPointer))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = getColor(from: level).cgColor
        shapeLayer.lineWidth = 1
        
        layer.addSublayer(shapeLayer)
    }
}
