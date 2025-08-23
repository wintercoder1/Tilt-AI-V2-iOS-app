//
//  FinancialContributionsController.swift
//  Tilt AI V2
//
//  Created by Steve on 8/21/25.
//
import UIKit
import Foundation

// MARK: - Financial Contributions View Controller
class FinancialContributionsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let cardView = UIView()
    private let loadingView = UIView()
    private let spinnerView = UIView()
    private let loadingLabel = UILabel()
    
    private var organizationName: String = ""
    private var viewModel: FinancialContributionsViewModel!
    private weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
    }
    
    func configure(organizationName: String, viewModel: FinancialContributionsViewModel, coordinator: AppCoordinator) {
        self.organizationName = organizationName
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    private func bindViewModel() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.showLoading()
            } else {
                self?.hideLoading()
            }
        }
        
        viewModel.onDataLoaded = { [weak self] financialText in
            self?.showFinancialContent(financialText)
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showError(errorMessage)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupHeader()
        setupCard()
        setupLoadingView()
    }
    
    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Back button
        backButton.setTitle("← Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Title
        titleLabel.text = "Tilt AI"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        contentView.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
    
    private func setupCard() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowRadius = 16
        cardView.layer.shadowOpacity = 0.1
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cardView)
    }
    
    private func setupLoadingView() {
        loadingView.backgroundColor = UIColor.systemGroupedBackground
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        // Loading label
        loadingLabel.text = "Loading financial data..."
        loadingLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        loadingLabel.textColor = .systemGray
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Spinner
        spinnerView.backgroundColor = .clear
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinnerView)
        cardView.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: cardView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: -30),
            
            spinnerView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinnerView.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 20),
            spinnerView.widthAnchor.constraint(equalToConstant: 40),
            spinnerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        startLoadingSpinner()
    }
    
    private func startLoadingSpinner() {
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 20, y: 20),
            radius: 15,
            startAngle: 0,
            endAngle: CGFloat.pi * 1.6,
            clockwise: true
        )
        
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemBlue.cgColor
        circleLayer.lineWidth = 3
        circleLayer.lineCap = .round
        
        spinnerView.layer.addSublayer(circleLayer)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        
        spinnerView.layer.add(rotationAnimation, forKey: "rotation")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
            // Card view
            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func showLoading() {
        loadingView.isHidden = false
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
    }
    
    private func showFinancialContent(_ financialText: String) {
        // Clear existing content in card (except loading view)
        cardView.subviews.forEach { subview in
            if subview != loadingView {
                subview.removeFromSuperview()
            }
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Financial Contributions Overview for \(organizationName)"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        // Financial text content
        let contentLabel = UILabel()
        contentLabel.text = financialText
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        
        cardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30)
        ])
    }
    
    private func showError(_ message: String) {
        // Clear existing content in card (except loading view)
        cardView.subviews.forEach { subview in
            if subview != loadingView {
                subview.removeFromSuperview()
            }
        }
        
        let errorStackView = UIStackView()
        errorStackView.axis = .vertical
        errorStackView.spacing = 16
        errorStackView.alignment = .center
        errorStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let errorLabel = UILabel()
        errorLabel.text = "Failed to load financial data"
        errorLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        
        let detailLabel = UILabel()
        detailLabel.text = message
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = .systemGray
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        retryButton.backgroundColor = UIColor.systemBlue
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 8
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        errorStackView.addArrangedSubview(errorLabel)
        errorStackView.addArrangedSubview(detailLabel)
        errorStackView.addArrangedSubview(retryButton)
        
        cardView.addSubview(errorStackView)
        
        NSLayoutConstraint.activate([
            errorStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            errorStackView.leadingAnchor.constraint(greaterThanOrEqualTo: cardView.leadingAnchor, constant: 30),
            errorStackView.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -30)
        ])
    }
    
    @objc private func retryButtonTapped() {
        viewModel.fetchFinancialContributions(for: organizationName)
    }
    
    @objc private func backButtonTapped() {
        coordinator?.navigateBack()
    }
}
