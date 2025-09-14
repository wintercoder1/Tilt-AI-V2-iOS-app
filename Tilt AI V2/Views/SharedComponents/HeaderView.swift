
//
//  HeaderView.swift
//  Tilt AI V2
//
//  Created by Steve on 8/25/25.
//
import UIKit

// MARK: - Tilt AI Header View
class TiltAIHeaderView: UIView {
    
    // MARK: - UI Components
    private let backButton = UIButton(type: .system)
    private let centerContentView = UIView()
    private let slashLineView = UIView()
    private let titleLabel = UILabel()
    private let separatorLine = UIView()
    
    // MARK: - Properties
    weak var delegate: TiltAIHeaderViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .white
        
        // Configure back button with chevron icon
        let chevronImage = UIImage(systemName: "chevron.left")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        backButton.setImage(chevronImage, for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Configure center content view to hold logo and title
        centerContentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure slash line (the diagonal line/logo)
        slashLineView.backgroundColor = .black
        slashLineView.translatesAutoresizingMaskIntoConstraints = false
        slashLineView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 6) // 30 degree rotation
        
        // Configure title label
        titleLabel.text = "Tilt AI"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure separator line at bottom
        separatorLine.backgroundColor = UIColor.systemGray4
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(backButton)
        addSubview(centerContentView)
        centerContentView.addSubview(slashLineView)
        centerContentView.addSubview(titleLabel)
        addSubview(separatorLine)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back button - positioned on the left in safe area
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backButton.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -12),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Center content view - contains logo and title
            centerContentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerContentView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            // Slash line - positioned within center content
            slashLineView.leadingAnchor.constraint(equalTo: centerContentView.leadingAnchor),
            slashLineView.centerYAnchor.constraint(equalTo: centerContentView.centerYAnchor),
            slashLineView.widthAnchor.constraint(equalToConstant: 3),
            slashLineView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label - positioned next to slash line
            titleLabel.leadingAnchor.constraint(equalTo: slashLineView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerContentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: centerContentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: centerContentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: centerContentView.bottomAnchor),
            
            // Separator line at the bottom
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    // MARK: - Public Configuration Methods
    func configure(title: String = "Tilt AI", showBackButton: Bool = true) {
        titleLabel.text = title
        backButton.isHidden = !showBackButton
    }
    
    func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    
    func setSlashColor(_ color: UIColor) {
        slashLineView.backgroundColor = color
    }
    
    func setBackButtonColor(_ color: UIColor) {
        backButton.tintColor = color
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        delegate?.headerViewBackButtonTapped(self)
    }
    
    // MARK: - Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 70)
    }
}

// MARK: - Delegate Protocol
protocol TiltAIHeaderViewDelegate: AnyObject {
    func headerViewBackButtonTapped(_ headerView: TiltAIHeaderView)
}

// MARK: - UIViewController Extension
extension UIViewController {
    
    /// Adds a Tilt AI header to the view controller that extends to the top of the screen
    /// - Parameters:
    ///   - title: The title to display (defaults to "Tilt AI")
    ///   - showBackButton: Whether to show the back button (defaults to true)
    /// - Returns: The configured header view
    @discardableResult
    func addTiltAIHeader(title: String = "Tilt AI", showBackButton: Bool = true) -> TiltAIHeaderView {
        
        let headerView = TiltAIHeaderView()
        headerView.configure(title: title, showBackButton: showBackButton)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add a background view that extends to the very top to prevent any gray showing through
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            // Background view extends to the very top
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            
            // Header view on top of background
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
        ])
        
        return headerView
    }
}

//import UIKit
//
//// MARK: - Tilt AI Header View
//class TiltAIHeaderView: UIView {
//    
//    // MARK: - UI Components
//    private let backButton = UIButton(type: .system)
//    private let centerContentView = UIView()
//    private let slashLineView = UIView()
//    private let titleLabel = UILabel()
//    private let separatorLine = UIView()
//    
//    // MARK: - Properties
//    weak var delegate: TiltAIHeaderViewDelegate?
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
//        
//        // Configure back button with chevron icon
//        let chevronImage = UIImage(systemName: "chevron.left")?
//            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
//        backButton.setImage(chevronImage, for: .normal)
//        backButton.tintColor = .black
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        
//        // Configure center content view to hold logo and title
//        centerContentView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure slash line (the diagonal line/logo)
//        slashLineView.backgroundColor = .black
//        slashLineView.translatesAutoresizingMaskIntoConstraints = false
//        slashLineView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 6) // 30 degree rotation
//        
//        // Configure title label
//        titleLabel.text = "Tilt AI"
//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
//        titleLabel.textColor = .black
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure separator line at bottom
//        separatorLine.backgroundColor = UIColor.systemGray4
//        separatorLine.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add subviews
//        addSubview(backButton)
//        addSubview(centerContentView)
//        centerContentView.addSubview(slashLineView)
//        centerContentView.addSubview(titleLabel)
//        addSubview(separatorLine)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Back button - positioned on the left in safe area
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            backButton.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -12),
//            backButton.widthAnchor.constraint(equalToConstant: 44),
//            backButton.heightAnchor.constraint(equalToConstant: 44),
//            
//            // Center content view - contains logo and title
//            centerContentView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            centerContentView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
//            
//            // Slash line - positioned within center content
//            slashLineView.leadingAnchor.constraint(equalTo: centerContentView.leadingAnchor),
//            slashLineView.centerYAnchor.constraint(equalTo: centerContentView.centerYAnchor),
//            slashLineView.widthAnchor.constraint(equalToConstant: 3),
//            slashLineView.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Title label - positioned next to slash line
//            titleLabel.leadingAnchor.constraint(equalTo: slashLineView.trailingAnchor, constant: 12),
//            titleLabel.centerYAnchor.constraint(equalTo: centerContentView.centerYAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: centerContentView.trailingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: centerContentView.topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: centerContentView.bottomAnchor),
//            
//            // Separator line at the bottom
//            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
//            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
//            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
//            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//    
//    // MARK: - Public Configuration Methods
//    func configure(title: String = "Tilt AI", showBackButton: Bool = true) {
//        titleLabel.text = title
//        backButton.isHidden = !showBackButton
//    }
//    
//    func setTitleColor(_ color: UIColor) {
//        titleLabel.textColor = color
//    }
//    
//    func setSlashColor(_ color: UIColor) {
//        slashLineView.backgroundColor = color
//    }
//    
//    func setBackButtonColor(_ color: UIColor) {
//        backButton.tintColor = color
//    }
//    
//    // MARK: - Actions
//    @objc private func backButtonTapped() {
//        delegate?.headerViewBackButtonTapped(self)
//    }
//    
//    // MARK: - Intrinsic Content Size
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 70)
//    }
//}
//
//// MARK: - Delegate Protocol
//protocol TiltAIHeaderViewDelegate: AnyObject {
//    func headerViewBackButtonTapped(_ headerView: TiltAIHeaderView)
//}
//
//// MARK: - UIViewController Extension
//extension UIViewController {
//    
//    /// Adds a Tilt AI header to the view controller that extends to the top of the screen
//    /// - Parameters:
//    ///   - title: The title to display (defaults to "Tilt AI")
//    ///   - showBackButton: Whether to show the back button (defaults to true)
//    /// - Returns: The configured header view
//    @discardableResult
//    func addTiltAIHeader(title: String = "Tilt AI", showBackButton: Bool = true) -> TiltAIHeaderView {
//        
//        let headerView = TiltAIHeaderView()
//        headerView.configure(title: title, showBackButton: showBackButton)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add a background view that extends to the very top to prevent any gray showing through
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = .white
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(backgroundView)
//        
//        view.addSubview(headerView)
//        
//        NSLayoutConstraint.activate([
//            // Background view extends to the very top
//            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
//            
//            // Header view on top of background
//            headerView.topAnchor.constraint(equalTo: view.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
//        ])
//        
//        return headerView
//    }
//}
//import UIKit
//
//// MARK: - Tilt AI Header View
//class TiltAIHeaderView: UIView {
//    
//    // MARK: - UI Components
//    private let backButton = UIButton(type: .system)
//    private let centerContentView = UIView()
//    private let slashLineView = UIView()
//    private let titleLabel = UILabel()
//    private let separatorLine = UIView()
//    
//    // MARK: - Properties
//    weak var delegate: TiltAIHeaderViewDelegate?
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
//        
//        // Configure back button with chevron icon
//        let chevronImage = UIImage(systemName: "chevron.left")?
//            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
//        backButton.setImage(chevronImage, for: .normal)
//        backButton.tintColor = .black
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        
//        // Configure center content view to hold logo and title
//        centerContentView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure slash line (the diagonal line/logo)
//        slashLineView.backgroundColor = .black
//        slashLineView.translatesAutoresizingMaskIntoConstraints = false
//        slashLineView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 6) // 30 degree rotation
//        
//        // Configure title label
//        titleLabel.text = "Tilt AI"
//        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
//        titleLabel.textColor = .black
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure separator line at bottom
//        separatorLine.backgroundColor = UIColor.systemGray4
//        separatorLine.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add subviews
//        addSubview(backButton)
//        addSubview(centerContentView)
//        centerContentView.addSubview(slashLineView)
//        centerContentView.addSubview(titleLabel)
//        addSubview(separatorLine)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Back button - positioned on the left in safe area
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            backButton.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -12),
//            backButton.widthAnchor.constraint(equalToConstant: 44),
//            backButton.heightAnchor.constraint(equalToConstant: 44),
//            
//            // Center content view - contains logo and title
//            centerContentView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            centerContentView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
//            
//            // Slash line - positioned within center content
//            slashLineView.leadingAnchor.constraint(equalTo: centerContentView.leadingAnchor),
//            slashLineView.centerYAnchor.constraint(equalTo: centerContentView.centerYAnchor),
//            slashLineView.widthAnchor.constraint(equalToConstant: 3),
//            slashLineView.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Title label - positioned next to slash line
//            titleLabel.leadingAnchor.constraint(equalTo: slashLineView.trailingAnchor, constant: 12),
//            titleLabel.centerYAnchor.constraint(equalTo: centerContentView.centerYAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: centerContentView.trailingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: centerContentView.topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: centerContentView.bottomAnchor),
//            
//            // Separator line at the bottom
//            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
//            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
//            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
//            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//    
//    // MARK: - Public Configuration Methods
//    func configure(title: String = "Tilt AI", showBackButton: Bool = true) {
//        titleLabel.text = title
//        backButton.isHidden = !showBackButton
//    }
//    
//    func setTitleColor(_ color: UIColor) {
//        titleLabel.textColor = color
//    }
//    
//    func setSlashColor(_ color: UIColor) {
//        slashLineView.backgroundColor = color
//    }
//    
//    func setBackButtonColor(_ color: UIColor) {
//        backButton.tintColor = color
//    }
//    
//    // MARK: - Actions
//    @objc private func backButtonTapped() {
//        delegate?.headerViewBackButtonTapped(self)
//    }
//    
//    // MARK: - Intrinsic Content Size
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 70)
//    }
//}
//
//// MARK: - Delegate Protocol
//protocol TiltAIHeaderViewDelegate: AnyObject {
//    func headerViewBackButtonTapped(_ headerView: TiltAIHeaderView)
//}
//
//// MARK: - UIViewController Extension
//extension UIViewController {
//    
//    /// Adds a Tilt AI header to the view controller that extends to the top of the screen
//    /// - Parameters:
//    ///   - title: The title to display (defaults to "Tilt AI")
//    ///   - showBackButton: Whether to show the back button (defaults to true)
//    /// - Returns: The configured header view
//    @discardableResult
//    func addTiltAIHeader(title: String = "Tilt AI", showBackButton: Bool = true) -> TiltAIHeaderView {
//        
//        let headerView = TiltAIHeaderView()
//        headerView.configure(title: title, showBackButton: showBackButton)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(headerView)
//        
//        NSLayoutConstraint.activate([
//            // Extend to the very top of the screen (above safe area)
//            headerView.topAnchor.constraint(equalTo: view.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            // Height includes safe area top + content height
//            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
//        ])
//        
//        return headerView
//    }
//}

//import UIKit
//
//// MARK: - Tilt AI Header View
//class TiltAIHeaderView: UIView {
//    
//    // MARK: - UI Components
//    private let slashLineView = UIView()
//    private let titleLabel = UILabel()
//    private let separatorLine = UIView()
//    
//    // MARK: - Properties
//    weak var delegate: TiltAIHeaderViewDelegate?
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
//        
//        // Configure slash line (the diagonal line on the left)
//        slashLineView.backgroundColor = .black
//        slashLineView.translatesAutoresizingMaskIntoConstraints = false
//        slashLineView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 6) // 30 degree rotation
//        
//        // Configure title label
//        titleLabel.text = "Tilt AI"
//        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
//        titleLabel.textColor = .black
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure separator line at bottom
//        separatorLine.backgroundColor = UIColor.systemGray4
//        separatorLine.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add subviews
//        addSubview(slashLineView)
//        addSubview(titleLabel)
//        addSubview(separatorLine)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Slash line - positioned on the left side
//            slashLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            slashLineView.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -12),
//            slashLineView.widthAnchor.constraint(equalToConstant: 3),
//            slashLineView.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Title label - positioned on the right side
//            titleLabel.leadingAnchor.constraint(equalTo: slashLineView.trailingAnchor, constant: 16),
//            titleLabel.centerYAnchor.constraint(equalTo: slashLineView.centerYAnchor),
//            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
//            
//            // Separator line at the bottom
//            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
//            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
//            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
//            separatorLine.heightAnchor.constraint(equalToConstant: 1)
//        ])
//    }
//    
//    // MARK: - Public Configuration Methods
//    func configure(title: String = "Tilt AI") {
//        titleLabel.text = title
//    }
//    
//    func setTitleColor(_ color: UIColor) {
//        titleLabel.textColor = color
//    }
//    
//    func setSlashColor(_ color: UIColor) {
//        slashLineView.backgroundColor = color
//    }
//    
//    // MARK: - Intrinsic Content Size
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 70) // Taller to accommodate the design
//    }
//}
//
//// MARK: - Delegate Protocol
//protocol TiltAIHeaderViewDelegate: AnyObject {
//    func headerViewBackButtonTapped(_ headerView: TiltAIHeaderView)
//}
//
//// MARK: - UIViewController Extension
//extension UIViewController {
//    
//    /// Adds a Tilt AI header to the view controller that extends to the top of the screen
//    /// - Parameters:
//    ///   - title: The title to display (defaults to "Tilt AI")
//    /// - Returns: The configured header view
//    @discardableResult
//    func addTiltAIHeader(title: String = "Tilt AI") -> TiltAIHeaderView {
//        
//        let headerView = TiltAIHeaderView()
//        headerView.configure(title: title)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(headerView)
//        
//        NSLayoutConstraint.activate([
//            // Extend to the very top of the screen (above safe area)
//            headerView.topAnchor.constraint(equalTo: view.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            // Height includes safe area top + content height
//            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
//        ])
//        
//        return headerView
//    }
//}
//import UIKit
//
//// MARK: - Tilt AI Header View
//class HeaderView: UIView {
//    
//    // MARK: - UI Components
//    private let backButton = UIButton(type: .system)
//    private let titleLabel = UILabel()
//    private let separatorView = UIView()
//    
//    // MARK: - Properties
//    weak var delegate: TiltAIHeaderViewDelegate?
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
////        backgroundColor = UIColor.systemGroupedBackground
//        backgroundColor = UIColor.white
//        
//        // Configure back button
//        backButton.setTitle("← Back", for: .normal)
//        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        backButton.setTitleColor(.systemBlue, for: .normal)
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        
//        // Configure title label
//        titleLabel.text = "Tilt AI"
//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
//        titleLabel.textColor = .black
//        titleLabel.textAlignment = .right
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Configure separator (optional, for visual separation)
//        separatorView.backgroundColor = UIColor.systemGray5
//        separatorView.translatesAutoresizingMaskIntoConstraints = false
//        separatorView.isHidden = true // Hidden by default, can be shown if needed
//        
//        // Add subviews
//        addSubview(backButton)
//        addSubview(titleLabel)
//        addSubview(separatorView)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Back button
//            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            
//            // Title label
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 20),
//            
//            // Separator
//            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//    
//    // MARK: - Public Configuration Methods
//    func configure(title: String = "Tilt AI", showBackButton: Bool = true, showSeparator: Bool = false) {
//        titleLabel.text = title
//        backButton.isHidden = !showBackButton
//        separatorView.isHidden = !showSeparator
//    }
//    
//    func setBackButtonTitle(_ title: String) {
//        backButton.setTitle(title, for: .normal)
//    }
//    
//    func setTitleColor(_ color: UIColor) {
//        titleLabel.textColor = color
//    }
//    
//    func setBackButtonColor(_ color: UIColor) {
//        backButton.setTitleColor(color, for: .normal)
//    }
//    
//    // MARK: - Actions
//    @objc private func backButtonTapped() {
//        delegate?.headerViewBackButtonTapped(self)
//    }
//    
//    // MARK: - Intrinsic Content Size
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 44)
//    }
//}
//
//// MARK: - Delegate Protocol
//protocol TiltAIHeaderViewDelegate: AnyObject {
//    func headerViewBackButtonTapped(_ headerView: HeaderView)
//}
//
//// MARK: - UIViewController Extension
//extension UIViewController {
//    
//    /// Adds a Tilt AI header to the view controller
//    /// - Parameters:
//    ///   - title: The title to display (defaults to "Tilt AI")
//    ///   - showBackButton: Whether to show the back button (defaults to true)
//    ///   - showSeparator: Whether to show a separator line (defaults to false)
//    ///   - topConstraintConstant: The top constraint constant from safe area (defaults to 10)
//    /// - Returns: The configured header view
//    @discardableResult
//    func addTiltAIHeader(title: String = "Tilt AI",
//                        showBackButton: Bool = true,
//                        showSeparator: Bool = false,
//                        topConstraintConstant: CGFloat = 10) -> HeaderView {
//        
//        let headerView = HeaderView()
//        headerView.configure(title: title, showBackButton: showBackButton, showSeparator: showSeparator)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(headerView)
//        
//        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 44)
//        ])
//        
//        return headerView
//    }
//}
