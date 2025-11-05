
//
//  HeaderView.swift
//  Compass AI V2
//
//  Created by Steve on 8/25/25.
//
import UIKit

// MARK: - Compass AI Header View
class CompassAIHeaderView: UIView {
    
    // MARK: - UI Components
    private let backButton = UIButton(type: .system)
    private let centerContentView = UIView()
    private let slashLineView = UIView()
    private let titleLabel = UILabel()
    private let separatorLine = UIView()
    
    // MARK: - Properties
    weak var delegate: CompassAIHeaderViewDelegate?
    
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
        
        // TODO: Replace the slash line with a compass logo.
//         Configure slash line (the diagonal line/logo)
//        slashLineView.backgroundColor = .black
//        slashLineView.translatesAutoresizingMaskIntoConstraints = false
//        slashLineView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 6) // 30 degree rotation
        
        // Configure title label
        titleLabel.text = "Compass AI"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure separator line at bottom
        separatorLine.backgroundColor = UIColor.systemGray4
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(backButton)
        addSubview(centerContentView)
//        centerContentView.addSubview(slashLineView)
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
//            slashLineView.leadingAnchor.constraint(equalTo: centerContentView.leadingAnchor),
//            slashLineView.centerYAnchor.constraint(equalTo: centerContentView.centerYAnchor),
//            slashLineView.widthAnchor.constraint(equalToConstant: 3),
//            slashLineView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label - positioned next to slash line
//            titleLabel.leadingAnchor.constraint(equalTo: slashLineView.trailingAnchor, constant: 12),
//            titleLabel.leadingAnchor.constraint(equalTo: centerContentView.leadingAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: centerContentView.leadingAnchor),
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
    func configure(title: String = "Compass AI", showBackButton: Bool = true) {
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
protocol CompassAIHeaderViewDelegate: AnyObject {
    func headerViewBackButtonTapped(_ headerView: CompassAIHeaderView)
}

// MARK: - UIViewController Extension
extension UIViewController {
    
    /// Adds a Compass AI header to the view controller that extends to the top of the screen
    /// - Parameters:
    ///   - title: The title to display (defaults to "Compass AI")
    ///   - showBackButton: Whether to show the back button (defaults to true)
    /// - Returns: The configured header view
    @discardableResult
    func addCompassAIHeader(title: String = "Compass AI", showBackButton: Bool = true) -> CompassAIHeaderView {
        
        let headerView = CompassAIHeaderView()
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
