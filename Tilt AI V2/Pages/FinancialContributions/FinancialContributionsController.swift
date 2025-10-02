//
//  FinancialContributionsController.swift
//  Tilt AI V2
//
//  Created by Steve on 8/21/25.
//


import UIKit
import Foundation

// MARK: - Financial Contributions View Controller
class FinancialContributionsViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var headerView: TiltAIHeaderView!
    private let contributionsBreakdownCardView = UIView()
    private let detailsCardView = UIView()
    private let loadingView = UIView()
    private let spinnerView = UIView()
    private let loadingLabel = UILabel()
    private let footerStackView = UIStackView()
    private let bottomPaddingView = UIView()
    
    private var organizationName: String = ""
    private var viewModel: FinancialContributionsViewModel!
    private var financialContributions: FinancialContributionsResponse?
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
    
    // Update the bindViewModel method to handle the new callback
    private func bindViewModelUpdated() {
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
        
        // NEW: Handle the full data response
        viewModel.onFullDataLoaded = { [weak self] financialResponse in
            self?.setFinancialContributions(financialResponse)
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showError(errorMessage)
        }
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
        // May be redundant.
        // TODO: Combine this with the above call and refactor of what this calls.
        viewModel.onFullDataLoaded = { [weak self] financialResponse in
            self?.setFinancialContributions(financialResponse)
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showError(errorMessage)
        }
    }
    
    
    // Add this method to receive the full financial contributions data
    func setFinancialContributions(_ contributions: FinancialContributionsResponse) {
        self.financialContributions = contributions
        DispatchQueue.main.async {
            self.updateContributionsBreakdownCard()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Hide the navigation bar since we're using our custom header
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add the custom header using the extension
        headerView = addTiltAIHeader(title: "Tilt AI", showBackButton: true)
        headerView.delegate = self
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.systemGroupedBackground
        scrollView.contentInsetAdjustmentBehavior = .never // Prevent automatic content inset
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupContributionsBreakdownCard()
        setupDetailsCard()
        setupLoadingView()
        setupFooterOld()
    }
    
    private func setupContributionsBreakdownCard() {
        contributionsBreakdownCardView.backgroundColor = .white
        contributionsBreakdownCardView.layer.cornerRadius = 16
        contributionsBreakdownCardView.layer.shadowColor = UIColor.black.cgColor
        contributionsBreakdownCardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        contributionsBreakdownCardView.layer.shadowRadius = 16
        contributionsBreakdownCardView.layer.shadowOpacity = 0.1
        contributionsBreakdownCardView.translatesAutoresizingMaskIntoConstraints = false
        contributionsBreakdownCardView.isHidden = true // Initially hidden until data loads
        
        contentView.addSubview(contributionsBreakdownCardView)
    }
    
    private func setupDetailsCard() {
        detailsCardView.backgroundColor = .white
        detailsCardView.layer.cornerRadius = 16
        detailsCardView.layer.shadowColor = UIColor.black.cgColor
        detailsCardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        detailsCardView.layer.shadowRadius = 16
        detailsCardView.layer.shadowOpacity = 0.1
        detailsCardView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(detailsCardView)
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
        detailsCardView.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: detailsCardView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: detailsCardView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: detailsCardView.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: detailsCardView.bottomAnchor),
            
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: -30),
            
            spinnerView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinnerView.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 40),
            spinnerView.widthAnchor.constraint(equalToConstant: 40),
            spinnerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        startLoadingSpinner()
    }
    
    private func setupFooterOld() {
        footerStackView.axis = .vertical
        footerStackView.spacing = 8
        footerStackView.alignment = .center
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        footerStackView.backgroundColor = .white
        bottomPaddingView.translatesAutoresizingMaskIntoConstraints = false
        bottomPaddingView.backgroundColor = .white
//        bottomPaddingView.backgroundColor = .cyan
        
        let copyrightLabel = UILabel()
        copyrightLabel.text = "  © 2025 Correlation LLC. All rights reserved.  "
        copyrightLabel.font = UIFont.systemFont(ofSize: 14)
        copyrightLabel.textColor = .systemGray
        copyrightLabel.textAlignment = .center
        
        let dataSourceLabel = UILabel()
        dataSourceLabel.text = "  Data sourced from public FEC filings and other regulatory sources.  "
        dataSourceLabel.font = UIFont.systemFont(ofSize: 14)
        dataSourceLabel.textColor = .systemGray
        dataSourceLabel.textAlignment = .center
        dataSourceLabel.numberOfLines = 0
        
//        let emailImageView = UIImageView(image: UIImage(systemName: "envelope"))
//        emailImageView.tintColor = .systemGray
//        emailImageView.contentMode = .scaleAspectFit
        
        let disclaimerLabel = UILabel()
        disclaimerLabel.text = "  This website provides information derived from publicly available data. Tilt AI and Correlation LLC do not endorse any political candidates or organizations mentioned.  "
        disclaimerLabel.font = UIFont.systemFont(ofSize: 12)
        disclaimerLabel.textColor = .systemGray
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.numberOfLines = 0
        
        footerStackView.addArrangedSubview(copyrightLabel)
        footerStackView.addArrangedSubview(dataSourceLabel)
//        footerStackView.addArrangedSubview(emailImageView)
        footerStackView.addArrangedSubview(disclaimerLabel)
        
        contentView.addSubview(footerStackView)
        contentView.addSubview(bottomPaddingView)
    }
    
    private func updateContributionsBreakdownCard() {
        guard let contributions = financialContributions,
              let percentContributions = contributions.percentContributions else {
            contributionsBreakdownCardView.isHidden = true
//            print("|| contributionsBreakdownCardView.isHidden = true ||")
            return
        }
        
        contributionsBreakdownCardView.isHidden = false
//        print("|| contributionsBreakdownCardView.isHidden NOT HIDDEN ||")
        
        // Clear existing content
        contributionsBreakdownCardView.subviews.forEach { $0.removeFromSuperview() }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Contributions to Each Party"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        
        // Total contributions
        let totalLabel = UILabel()
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        let totalAmount = formatter.string(from: NSNumber(value: percentContributions.totalContributions)) ?? "$0"
        totalLabel.text = "Total Contributions: \(totalAmount)"
        totalLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        totalLabel.textColor = .black
        
        // Party breakdown
        let partyStackView = UIStackView()
        partyStackView.axis = .vertical
        partyStackView.spacing = 12
        
        // Republicans
        let republicanAmount = formatter.string(from: NSNumber(value: percentContributions.totalToRepublicans)) ?? "$0"
        let republicanLabel = UILabel()
        republicanLabel.text = "To Republicans: \(republicanAmount) (\(String(format: "%.2f", percentContributions.percentToRepublicans))%)"
        republicanLabel.font = UIFont.systemFont(ofSize: 16)
        republicanLabel.textColor = .black
        
        // Democrats
        let democratAmount = formatter.string(from: NSNumber(value: percentContributions.totalToDemocrats)) ?? "$0"
        let democratLabel = UILabel()
        democratLabel.text = "To Democrats: \(democratAmount) (\(String(format: "%.2f", percentContributions.percentToDemocrats))%)"
        democratLabel.font = UIFont.systemFont(ofSize: 16)
        democratLabel.textColor = .black
        
        partyStackView.addArrangedSubview(republicanLabel)
        partyStackView.addArrangedSubview(democratLabel)
        
        // Progress bar container
        let progressBarContainer = UIView()
        progressBarContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Background bar
        let backgroundBar = UIView()
        backgroundBar.backgroundColor = .systemGray5
        backgroundBar.layer.cornerRadius = 6
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Democratic bar (blue)
        let democraticBar = UIView()
        democraticBar.backgroundColor = .systemBlue
        democraticBar.layer.cornerRadius = 6
        democraticBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Republican bar (red)
        let republicanBar = UIView()
        republicanBar.backgroundColor = .systemRed
        republicanBar.layer.cornerRadius = 6
        republicanBar.translatesAutoresizingMaskIntoConstraints = false
        
        progressBarContainer.addSubview(backgroundBar)
        progressBarContainer.addSubview(democraticBar)
        progressBarContainer.addSubview(republicanBar)
        
        // Legend
        let legendStackView = UIStackView()
        legendStackView.axis = .horizontal
        legendStackView.distribution = .equalSpacing
        legendStackView.alignment = .center
        
        // Democratic legend
        let democraticLegendStack = UIStackView()
        democraticLegendStack.axis = .horizontal
        democraticLegendStack.spacing = 8
        democraticLegendStack.alignment = .center
        
        let democraticDot = UIView()
        democraticDot.backgroundColor = .systemBlue
        democraticDot.layer.cornerRadius = 6
        democraticDot.translatesAutoresizingMaskIntoConstraints = false
        
        let democraticLegendLabel = UILabel()
        democraticLegendLabel.text = "Democrats"
        democraticLegendLabel.font = UIFont.systemFont(ofSize: 14)
        democraticLegendLabel.textColor = .black
        
        democraticLegendStack.addArrangedSubview(democraticDot)
        democraticLegendStack.addArrangedSubview(democraticLegendLabel)
        
        // Republican legend
        let republicanLegendStack = UIStackView()
        republicanLegendStack.axis = .horizontal
        republicanLegendStack.spacing = 8
        republicanLegendStack.alignment = .center
        
        let republicanDot = UIView()
        republicanDot.backgroundColor = .systemRed
        republicanDot.layer.cornerRadius = 6
        republicanDot.translatesAutoresizingMaskIntoConstraints = false
        
        let republicanLegendLabel = UILabel()
        republicanLegendLabel.text = "Republicans"
        republicanLegendLabel.font = UIFont.systemFont(ofSize: 14)
        republicanLegendLabel.textColor = .black
        
        republicanLegendStack.addArrangedSubview(republicanDot)
        republicanLegendStack.addArrangedSubview(republicanLegendLabel)
        
        legendStackView.addArrangedSubview(democraticLegendStack)
        legendStackView.addArrangedSubview(republicanLegendStack)
        
        // Add all elements to main stack
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(totalLabel)
        stackView.addArrangedSubview(partyStackView)
        stackView.addArrangedSubview(progressBarContainer)
        stackView.addArrangedSubview(legendStackView)
        
        contributionsBreakdownCardView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Main stack view
            stackView.topAnchor.constraint(equalTo: contributionsBreakdownCardView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: contributionsBreakdownCardView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: contributionsBreakdownCardView.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: contributionsBreakdownCardView.bottomAnchor, constant: -30),
            
            // Progress bar container
            progressBarContainer.heightAnchor.constraint(equalToConstant: 12),
            
            // Background bar
            backgroundBar.topAnchor.constraint(equalTo: progressBarContainer.topAnchor),
            backgroundBar.leadingAnchor.constraint(equalTo: progressBarContainer.leadingAnchor),
            backgroundBar.trailingAnchor.constraint(equalTo: progressBarContainer.trailingAnchor),
            backgroundBar.bottomAnchor.constraint(equalTo: progressBarContainer.bottomAnchor),
            
            // Democratic bar (left side)
            democraticBar.topAnchor.constraint(equalTo: progressBarContainer.topAnchor),
            democraticBar.leadingAnchor.constraint(equalTo: progressBarContainer.leadingAnchor),
            democraticBar.bottomAnchor.constraint(equalTo: progressBarContainer.bottomAnchor),
            democraticBar.widthAnchor.constraint(equalTo: progressBarContainer.widthAnchor, multiplier: CGFloat(percentContributions.percentToDemocrats / 100.0)),
            
            // Republican bar (right side)
            republicanBar.topAnchor.constraint(equalTo: progressBarContainer.topAnchor),
            republicanBar.trailingAnchor.constraint(equalTo: progressBarContainer.trailingAnchor),
            republicanBar.bottomAnchor.constraint(equalTo: progressBarContainer.bottomAnchor),
            republicanBar.widthAnchor.constraint(equalTo: progressBarContainer.widthAnchor, multiplier: CGFloat(percentContributions.percentToRepublicans / 100.0)),
            
            // Legend dots
            democraticDot.widthAnchor.constraint(equalToConstant: 12),
            democraticDot.heightAnchor.constraint(equalToConstant: 12),
            
            republicanDot.widthAnchor.constraint(equalToConstant: 12),
            republicanDot.heightAnchor.constraint(equalToConstant: 12)
        ])
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
        let footerViewHeight: CGFloat = 140.0
        NSLayoutConstraint.activate([
            // Scroll view - positioned below the header
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Details card view (first)
            detailsCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailsCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailsCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            // Contributions breakdown card (second)
            contributionsBreakdownCardView.topAnchor.constraint(equalTo: detailsCardView.bottomAnchor, constant: 20),
            contributionsBreakdownCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contributionsBreakdownCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contributionsBreakdownCardView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -40),
            
            // Footer
            footerStackView.topAnchor.constraint(greaterThanOrEqualTo: contributionsBreakdownCardView.bottomAnchor, constant: 25),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            footerStackView.heightAnchor.constraint(equalToConstant: footerViewHeight),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Bottom Padding
            bottomPaddingView.topAnchor.constraint(equalTo: footerStackView.bottomAnchor, constant: 0),
            bottomPaddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bottomPaddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            bottomPaddingView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func showLoading() {
        loadingView.isHidden = false
        contributionsBreakdownCardView.isHidden = true
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
    }
    
    private func showFinancialContent(_ financialText: String) {
//    private func showFinancialContent(_ financialContributionsResponse: FinancialContributionsResponse) {
//        let financialText = financialContributionsResponse.fecFinancialContributionsSummaryText
        // Clear existing content in details card (except loading view)
        detailsCardView.subviews.forEach { subview in
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
        
        
        // Financial info source disclaimer
        let disclaimerLabel = UILabel()
        let disclaimerText = "This financial information is based on Federal Election Commission filings from the 2024 election cycle."
        let disclaimerTextAttributedString = NSMutableAttributedString(string: disclaimerText)
        disclaimerLabel.attributedText = disclaimerTextAttributedString
        disclaimerLabel.font = UIFont.systemFont(ofSize: 16)
        disclaimerLabel.textColor = .gray
        disclaimerLabel.numberOfLines = 3
        // Put in italics.
        let nsRange = NSRange(location: 0, length: disclaimerText.utf16.count)
        // Apply italic font to the specified range
        if let currentFont = disclaimerLabel.font {
            let italicFont = UIFont(descriptor: currentFont.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: currentFont.pointSize)
            disclaimerTextAttributedString.addAttribute(.font, value: italicFont, range: nsRange)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(disclaimerLabel)
        
        detailsCardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: detailsCardView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: detailsCardView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: detailsCardView.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: detailsCardView.bottomAnchor, constant: -30)
        ])
        
        // Update the breakdown card as well
        updateContributionsBreakdownCard()
    }
    
    private func showError(_ message: String) {
        // Clear existing content in details card (except loading view)
        detailsCardView.subviews.forEach { subview in
            if subview != loadingView {
                subview.removeFromSuperview()
            }
        }
        
        contributionsBreakdownCardView.isHidden = true
        
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
        
        detailsCardView.addSubview(errorStackView)
        
        NSLayoutConstraint.activate([
            errorStackView.centerXAnchor.constraint(equalTo: detailsCardView.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: detailsCardView.centerYAnchor),
            errorStackView.leadingAnchor.constraint(greaterThanOrEqualTo: detailsCardView.leadingAnchor, constant: 30),
            errorStackView.trailingAnchor.constraint(lessThanOrEqualTo: detailsCardView.trailingAnchor, constant: -30)
        ])
    }
    
    @objc private func retryButtonTapped() {
        viewModel.fetchFinancialContributions(for: organizationName)
    }
}

// MARK: - TiltAIHeaderViewDelegate
extension FinancialContributionsViewController: TiltAIHeaderViewDelegate {
    func headerViewBackButtonTapped(_ headerView: TiltAIHeaderView) {
        coordinator?.navigateBack()
    }
}
