//
//  LoadingViewController.swift
//  Compass AI V2
//
//  Created by Steve on 8/21/25.
//
import UIKit
import Foundation

// MARK: - Loading View Controller
class LoadingViewController: BaseViewController {
    
    private let titleLabel = UILabel()
    private let spinnerView = UIView()
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startSpinning()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Title
        titleLabel.text = "Calculating..."
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .systemGray
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Spinner (custom circular view)
        spinnerView.backgroundColor = .clear
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtitle
        subtitleLabel.text = "This may take a while.."
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(spinnerView)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            spinnerView.widthAnchor.constraint(equalToConstant: 60),
            spinnerView.heightAnchor.constraint(equalToConstant: 60),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: spinnerView.bottomAnchor, constant: 28)
//            subtitleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    private func startSpinning() {
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 30, y: 30),
            radius: 25,
            startAngle: 0,
            endAngle: CGFloat.pi * 1.6,
            clockwise: true
        )
        
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemBlue.cgColor
        circleLayer.lineWidth = 6
        circleLayer.lineCap = .round
        
        spinnerView.layer.addSublayer(circleLayer)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        
        spinnerView.layer.add(rotationAnimation, forKey: "rotation")
    }
}


// MARK: - Loading View Controller
//class LoadingViewController: UIViewController {
//    
//    private let titleLabel = UILabel()
//    private let spinnerView = UIView()
//    private let subtitleLabel = UILabel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        startSpinning()
//        
//        // Hide navigation bar
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = UIColor.systemGroupedBackground
//        
//        // Title
//        titleLabel.text = "Calculating..."
//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
//        titleLabel.textColor = .systemGray
//        titleLabel.textAlignment = .center
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Spinner (custom circular view)
//        spinnerView.backgroundColor = .clear
//        spinnerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Subtitle
//        subtitleLabel.text = "This may take a while.."
//        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
//        subtitleLabel.textColor = .systemGray
//        subtitleLabel.textAlignment = .center
//        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(titleLabel)
//        view.addSubview(spinnerView)
//        view.addSubview(subtitleLabel)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
//            
//            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            spinnerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            spinnerView.widthAnchor.constraint(equalToConstant: 60),
//            spinnerView.heightAnchor.constraint(equalToConstant: 60),
//            
//            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            subtitleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
//        ])
//    }
//    
//    private func startSpinning() {
//        let circleLayer = CAShapeLayer()
//        let circlePath = UIBezierPath(
//            arcCenter: CGPoint(x: 30, y: 30),
//            radius: 25,
//            startAngle: 0,
//            endAngle: CGFloat.pi * 1.6,
//            clockwise: true
//        )
//        
//        circleLayer.path = circlePath.cgPath
//        circleLayer.fillColor = UIColor.clear.cgColor
//        circleLayer.strokeColor = UIColor.systemBlue.cgColor
//        circleLayer.lineWidth = 6
//        circleLayer.lineCap = .round
//        
//        spinnerView.layer.addSublayer(circleLayer)
//        
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotationAnimation.fromValue = 0
//        rotationAnimation.toValue = CGFloat.pi * 2
//        rotationAnimation.duration = 1.0
//        rotationAnimation.repeatCount = .infinity
//        
//        spinnerView.layer.add(rotationAnimation, forKey: "rotation")
//    }
//}
