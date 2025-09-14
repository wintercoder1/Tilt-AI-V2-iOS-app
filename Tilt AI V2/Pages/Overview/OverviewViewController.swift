//
//  ResultsViewController.swift
//  Tilt AI V2
//
//  Created by Steve on 8/21/25.
//
import UIKit
import Foundation

// MARK: - Results View Controller
class OverviewViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var headerView: TiltAIHeaderView!
    private let cardView = UIView()
    private var footerStackView = UIStackView()
    private let bottomPaddingView = UIView()
    
    private var analysis: OrganizationAnalysis?
    private var organizationName: String = ""
    private weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    func configure(with analysis: OrganizationAnalysis, organizationName: String, coordinator: AppCoordinator) {
        self.analysis = analysis
        self.organizationName = organizationName
        self.coordinator = coordinator
        
        if isViewLoaded {
            updateContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContent()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Hide the navigation bar since we're using our custom header
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add the custom header using the extension
        headerView = addTiltAIHeader(title: "Tilt AI")
        headerView.delegate = self
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupCard()
//        setupFooter()
        setupFooterOld()
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
    
//    private func setupFooter() {
//        addTiltAIFooterStackView(to: contentView, below: cardView.bottomAnchor, topConstant: 25)
//    }
    
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
    
    private func setupConstraints() {
        let footerViewHeight: CGFloat = 140.0
        NSLayoutConstraint.activate([
            // Scroll view - positioned below the header
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Card view
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Footer
            footerStackView.topAnchor.constraint(greaterThanOrEqualTo: cardView.bottomAnchor, constant: 25),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            footerStackView.heightAnchor.constraint(equalToConstant: footerViewHeight),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Bottom Padding
            bottomPaddingView.topAnchor.constraint(equalTo: footerStackView.bottomAnchor, constant: 0),
            bottomPaddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bottomPaddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            bottomPaddingView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func updateContent() {
        guard let analysis = analysis else { return }
    
        print("Analysis: \(analysis)")
        
        // Clear existing content in card
        cardView.subviews.forEach { $0.removeFromSuperview() }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Overview title
        let overviewLabel = UILabel()
        overviewLabel.text = "Overview for \(organizationName)"
        overviewLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        overviewLabel.textColor = .black
        overviewLabel.numberOfLines = 0
        
        // Lean and rating section
        let leanRatingView = UIView()
        
        let leanStackView = UIStackView()
        leanStackView.axis = .vertical
        leanStackView.spacing = 4
        leanStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let leanTitleLabel = UILabel()
        leanTitleLabel.text = "Lean:"
        leanTitleLabel.font = UIFont.systemFont(ofSize: 16)
        leanTitleLabel.textColor = .systemGray
        
        let leanValueLabel = UILabel()
        leanValueLabel.text = analysis.lean
        leanValueLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        leanValueLabel.textColor = .black
        
        leanStackView.addArrangedSubview(leanTitleLabel)
        leanStackView.addArrangedSubview(leanValueLabel)
        
        let ratingLabel = UILabel()
        ratingLabel.text = "\(analysis.rating)"
        ratingLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        ratingLabel.textColor = .black
        ratingLabel.textAlignment = .right
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leanRatingView.addSubview(leanStackView)
        leanRatingView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            leanStackView.leadingAnchor.constraint(equalTo: leanRatingView.leadingAnchor),
            leanStackView.topAnchor.constraint(equalTo: leanRatingView.topAnchor),
            leanStackView.bottomAnchor.constraint(equalTo: leanRatingView.bottomAnchor),
            
            ratingLabel.trailingAnchor.constraint(equalTo: leanRatingView.trailingAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: leanRatingView.centerYAnchor)
        ])
        
        // Description
        let descriptionLabel = UILabel()
        descriptionLabel.text = analysis.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(leanRatingView)
        stackView.addArrangedSubview(descriptionLabel)
        
        // Citations section (if applicable)
        if analysis.hasFinancialContributions {
            let citationsLabel = UILabel()
            citationsLabel.text = "Citations:"
            citationsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            citationsLabel.textColor = .black
            
            let financialButton = UIButton(type: .system)
            financialButton.setTitle("Financial Contributions Overview for \(organizationName)", for: .normal)
            financialButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            financialButton.setTitleColor(.systemBlue, for: .normal)
            financialButton.contentHorizontalAlignment = .left
            financialButton.addTarget(self, action: #selector(financialContributionsButtonTapped), for: .touchUpInside)
            
            // Add underline to make it look like a link
            let buttonTitle = "Financial Contributions Overview" // for \(organizationName)"
            let attributedTitle = NSMutableAttributedString(string: buttonTitle)
            attributedTitle.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedTitle.length))
            attributedTitle.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 0, length: attributedTitle.length))
            financialButton.setAttributedTitle(attributedTitle, for: .normal)
            
            stackView.addArrangedSubview(citationsLabel)
            stackView.addArrangedSubview(financialButton)
        }
        
        cardView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30)
        ])
    }
    
    @objc private func financialContributionsButtonTapped() {
        // Fetch financial contributions when user taps the link
        let financialViewModel = FinancialContributionsViewModel()
        financialViewModel.coordinator = coordinator
        
        // Show the financial contributions screen and start fetching data
        coordinator?.showFinancialContributionsScreen(organizationName: organizationName, viewModel: financialViewModel)
        
        // Trigger the data fetch
        financialViewModel.fetchFinancialContributions(for: organizationName)
    }
}

// MARK: - TiltAIHeaderViewDelegate
extension OverviewViewController: TiltAIHeaderViewDelegate {
    func headerViewBackButtonTapped(_ headerView: TiltAIHeaderView) {
        coordinator?.navigateToRoot()
    }
}
