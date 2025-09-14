//
//  FooterView.swift
//  Tilt AI V2
//
//  Created by Steve on 8/25/25.
//

import UIKit

// MARK: - Tilt AI Footer View
class TiltAIFooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Remove any background color, corner radius, shadow, or border styling
        backgroundColor = UIColor.white // or match your app's background
        layer.cornerRadius = 0 // Remove rounded corners
        layer.shadowOpacity = 0 // Remove shadow
        layer.borderWidth = 0 // Remove border
        
        setupFooterContent()
    }
    
    private func setupFooterContent() {
        // Copyright label
        let copyrightLabel = UILabel()
        copyrightLabel.text = "© 2025 Correlation LLC. All rights reserved."
        copyrightLabel.font = UIFont.systemFont(ofSize: 12)
        copyrightLabel.textColor = UIColor.systemGray
        copyrightLabel.textAlignment = .center
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Data source label
        let dataSourceLabel = UILabel()
        dataSourceLabel.text = "Data sourced from public FEC filings and other regulatory sources."
        dataSourceLabel.font = UIFont.systemFont(ofSize: 12)
        dataSourceLabel.textColor = UIColor.systemGray
        dataSourceLabel.textAlignment = .center
        dataSourceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Email icon (you can use SF Symbols or a custom image)
//        let emailIcon = UIImageView()
//        emailIcon.image = UIImage(systemName: "envelope")
//        emailIcon.tintColor = UIColor.systemGray
//        emailIcon.contentMode = .scaleAspectFit
//        emailIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Disclaimer label
        let disclaimerLabel = UILabel()
        disclaimerLabel.text = "This website provides information derived from publicly available data. Tilt AI and Correlation LLC do not endorse any political candidates or organizations mentioned."
        disclaimerLabel.font = UIFont.systemFont(ofSize: 11)
        disclaimerLabel.textColor = UIColor.systemGray2
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(copyrightLabel)
        addSubview(dataSourceLabel)
//        addSubview(emailIcon)
        addSubview(disclaimerLabel)
        
        NSLayoutConstraint.activate([
            // Copyright at top
            copyrightLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            copyrightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            copyrightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Data source below copyright
            dataSourceLabel.topAnchor.constraint(greaterThanOrEqualTo: copyrightLabel.bottomAnchor, constant: 18),
            dataSourceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dataSourceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Email icon below data source
//            emailIcon.topAnchor.constraint(equalTo: dataSourceLabel.bottomAnchor, constant: 16),
//            emailIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
//            emailIcon.widthAnchor.constraint(equalToConstant: 24),
//            emailIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Disclaimer at bottom
//            disclaimerLabel.topAnchor.constraint(equalTo: emailIcon.bottomAnchor, constant: 16),
            disclaimerLabel.topAnchor.constraint(greaterThanOrEqualTo: dataSourceLabel.bottomAnchor, constant: 26),
            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            disclaimerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
}
//class TiltAIFooterView: UIView {
//    
//    // MARK: - UI Components
//    private let stackView = UIStackView()
//    private let copyrightLabel = UILabel()
//    private let dataSourceLabel = UILabel()
//    private let emailImageView = UIImageView()
//    private let disclaimerLabel = UILabel()
//    
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//        setupConstraints()
//    }
//    
//    // MARK: - Setup Methods
//    private func setupUI() {
//        backgroundColor = .white
//        layer.cornerRadius = 16
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 8)
//        layer.shadowRadius = 16
//        layer.shadowOpacity = 0.1
//        
//        // Configure stack view
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure copyright label
//        copyrightLabel.text = "© 2025 Correlation LLC. All rights reserved."
//        copyrightLabel.font = UIFont.systemFont(ofSize: 14)
//        copyrightLabel.textColor = .systemGray
//        copyrightLabel.textAlignment = .center
//        
//        // Configure data source label
//        dataSourceLabel.text = "Data sourced from public FEC filings and other regulatory sources."
//        dataSourceLabel.font = UIFont.systemFont(ofSize: 14)
//        dataSourceLabel.textColor = .systemGray
//        dataSourceLabel.textAlignment = .center
//        dataSourceLabel.numberOfLines = 0
//        
//        // Configure email image view
//        emailImageView.image = UIImage(systemName: "envelope")
//        emailImageView.tintColor = .systemGray
//        emailImageView.contentMode = .scaleAspectFit
//        emailImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure disclaimer label
//        disclaimerLabel.text = "This website provides information derived from publicly available data. Tilt AI and Correlation LLC do not endorse any political candidates or organizations mentioned."
//        disclaimerLabel.font = UIFont.systemFont(ofSize: 12)
//        disclaimerLabel.textColor = .systemGray
//        disclaimerLabel.textAlignment = .center
//        disclaimerLabel.numberOfLines = 0
//        
//        // Add arranged subviews
//        stackView.addArrangedSubview(copyrightLabel)
//        stackView.addArrangedSubview(dataSourceLabel)
//        stackView.addArrangedSubview(emailImageView)
//        stackView.addArrangedSubview(disclaimerLabel)
//        
//        addSubview(stackView)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Stack view constraints
//            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
//            
//            // Email image view size
//            emailImageView.heightAnchor.constraint(equalToConstant: 20),
//            emailImageView.widthAnchor.constraint(equalToConstant: 20)
//        ])
//    }
//    
//    // MARK: - Public Configuration Methods
//    func configure(copyrightText: String? = nil,
//                  dataSourceText: String? = nil,
//                  disclaimerText: String? = nil,
//                  showEmailIcon: Bool = true) {
//        
//        if let copyrightText = copyrightText {
//            copyrightLabel.text = copyrightText
//        }
//        
//        if let dataSourceText = dataSourceText {
//            dataSourceLabel.text = dataSourceText
//        }
//        
//        if let disclaimerText = disclaimerText {
//            disclaimerLabel.text = disclaimerText
//        }
//        
//        emailImageView.isHidden = !showEmailIcon
//    }
//    
//    func setTextColor(_ color: UIColor) {
//        copyrightLabel.textColor = color
//        dataSourceLabel.textColor = color
//        disclaimerLabel.textColor = color
//        emailImageView.tintColor = color
//    }
//    
//    func setBackgroundColor(_ color: UIColor) {
//        backgroundColor = color
//    }
//    
//    // MARK: - Intrinsic Content Size
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
//    }
//}

// MARK: - UIViewController Extension
extension UIViewController {
    
    /// Adds a Tilt AI footer to a container view
    /// - Parameters:
    ///   - containerView: The view to add the footer to
    ///   - topAnchor: The anchor to position the footer below
    ///   - bottomAnchor: The anchor to position the footer above (optional)
    ///   - leadingConstant: Leading margin (defaults to 20)
    ///   - trailingConstant: Trailing margin (defaults to -20)
    ///   - topConstant: Top spacing (defaults to 40)
    ///   - bottomConstant: Bottom spacing (defaults to -40)
    /// - Returns: The configured footer view
    @discardableResult
//    func addTiltAIFooter(to containerView: UIView,
//                            below topAnchor: NSLayoutYAxisAnchor,
//                            above bottomAnchor: NSLayoutYAxisAnchor? = nil,
//                            leadingConstant: CGFloat = 0, // Changed from 20 to 0 for full width
//                            trailingConstant: CGFloat = 0, // Changed from -20 to 0 for full width
//                            topConstant: CGFloat = 80,
//                            bottomConstant: CGFloat = 0) -> TiltAIFooterView { // Changed from -40 to 0
//            
//        let footerView = TiltAIFooterView()
//        footerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.addSubview(footerView)
//            
//        var constraints = [
//            footerView.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
//            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leadingConstant),
//            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailingConstant)
//        ]
//        constraints[0].priority = UILayoutPriority(1000)
//        
//        if let bottomAnchor = bottomAnchor {
//            let bottomConstraint = footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant)
////            bottomConstraint.priority = UILayoutPriority(800) // Required priority
//            constraints.append(bottomConstraint)
//        } else {
//            // If no bottom anchor is provided, pin to container's bottom
//            let bottomConstraint = footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottomConstant)
////            bottomConstraint.priority = UILayoutPriority(800) // Required priority
//            constraints.append(bottomConstraint)
//        }
//        
//        // Add minimum height constraint to ensure footer content is visible
//        let minHeightConstraint = footerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
//        minHeightConstraint.priority = UILayoutPriority(750) // Lower priority
//        constraints.append(minHeightConstraint)
//        
//        NSLayoutConstraint.activate(constraints)
//        
//        return footerView
//    }
//    func addTiltAIFooter(to containerView: UIView,
//                            below topAnchor: NSLayoutYAxisAnchor,
//                            above bottomAnchor: NSLayoutYAxisAnchor? = nil,
//                            leadingConstant: CGFloat = 0, // Changed from 20 to 0 for full width
//                            trailingConstant: CGFloat = 0, // Changed from -20 to 0 for full width
//                            topConstant: CGFloat = 80,
//                            bottomConstant: CGFloat = 0) -> TiltAIFooterView { // Changed from -40 to 0
//            
//        let footerView = TiltAIFooterView()
//        footerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.addSubview(footerView)
//        
//        var constraints = [
//            footerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: topConstant),
//            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leadingConstant),
//            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailingConstant)
//        ]
//
//        if let bottomAnchor = bottomAnchor {
//            constraints.append(footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant))
//        } else {
//            // If no bottom anchor is provided, pin to container's bottom
//            constraints.append(footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottomConstant))
//        }
//        
//        NSLayoutConstraint.activate(constraints)
//        
//        return footerView
//    }
    func addTiltAIFooter(to containerView: UIView,
                            below topAnchor: NSLayoutYAxisAnchor,
                            above bottomAnchor: NSLayoutYAxisAnchor? = nil,
                            leadingConstant: CGFloat = 0, // Changed from 20 to 0 for full width
                            trailingConstant: CGFloat = 0, // Changed from -20 to 0 for full width
                            topConstant: CGFloat = 100,
                            bottomConstant: CGFloat = -100) -> TiltAIFooterView {
            
        let footerView = TiltAIFooterView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(footerView)
        
        let constraints = [
            footerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: topConstant),
            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leadingConstant),
            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailingConstant),
//            footerView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: bottomConstant)
//            footerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
            footerView.heightAnchor.constraint(equalToConstant: 400)
        ]
 constraints.append(footerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50))
        
        NSLayoutConstraint.activate(constraints)
        
        return footerView
    }
//    func addTiltAIFooter(to containerView: UIView,
//                        below topAnchor: NSLayoutYAxisAnchor,
//                        above bottomAnchor: NSLayoutYAxisAnchor? = nil,
//                        leadingConstant: CGFloat = 20,
//                        trailingConstant: CGFloat = -20,
//                        topConstant: CGFloat = 80,
//                        bottomConstant: CGFloat = -40) -> TiltAIFooterView {
//        
//        let footerView = TiltAIFooterView()
//        footerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.addSubview(footerView)
//        
//        var constraints = [
//            footerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: topConstant),
//            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leadingConstant),
//            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailingConstant)
//        ]
//        
//        if let bottomAnchor = bottomAnchor {
//            constraints.append(footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant))
//        }
//        
//        NSLayoutConstraint.activate(constraints)
//        
//        return footerView
//    }
}
