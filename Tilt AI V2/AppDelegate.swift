//
//  AppDelegate.swift
//  Tilt AI V2
//
//  Created by Steve on 8/21/25.
//

import UIKit


// MARK: - App Delegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        return true
//    }
//    
//    // MARK: UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }


//}askIntoConstraints = false
//        
//        let copyrightLabel = UILabel()
//        copyrightLabel.text = "© 2025 Correlation LLC. All rights reserved."
//        copyrightLabel.font = UIFont.systemFont(ofSize: 14)
//        copyrightLabel.textColor = .systemGray
//        copyrightLabel.textAlignment = .center
//        
//        let dataSourceLabel = UILabel()
//        dataSourceLabel.text = "Data sourced from public FEC filings and other regulatory sources."
//        dataSourceLabel.font = UIFont.systemFont(ofSize: 14)
//        dataSourceLabel.textColor = .systemGray
//        dataSourceLabel.textAlignment = .center
//        dataSourceLabel.numberOfLines = 0
//        
//        let emailImageView = UIImageView(image: UIImage(systemName: "envelope"))
//        emailImageView.tintColor = .systemGray
//        emailImageView.contentMode = .scaleAspectFit
//        
//        let disclaimerLabel = UILabel()
//        disclaimerLabel.text = "This website provides information derived from publicly available data. Tilt AI and Correlation LLC do not endorse any political candidates or organizations mentioned."
//        disclaimerLabel.font = UIFont.systemFont(ofSize: 12)
//        disclaimerLabel.textColor = .systemGray
//        disclaimerLabel.textAlignment = .center
//        disclaimerLabel.numberOfLines = 0
//        
//        footerStackView.addArrangedSubview(copyrightLabel)
//        footerStackView.addArrangedSubview(dataSourceLabel)
//        footerStackView.addArrangedSubview(emailImageView)
//        footerStackView.addArrangedSubview(disclaimerLabel)
//        
//        contentView.addSubview(footerStackView)
//    }
//    
//    // MARK: - Constraints
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Scroll view
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            // Content view
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            
//            // Card view
//            cardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50),
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            
//            // Title
//            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
//            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
//            
//            // Search text field
//            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
//            searchTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
//            searchTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
//            searchTextField.heightAnchor.constraint(equalToConstant: 50),
//            
//            // Table view (dropdown)
//            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
//            tableView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
//            
//            // Continue button
//            continueButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
//            continueButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
//            continueButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
//            continueButton.heightAnchor.constraint(equalToConstant: 50),
//            continueButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30),
//            
//            // Footer
//            footerStackView.topAnchor.constraint(greaterThanOrEqualTo: cardView.bottomAnchor, constant: 40),
//            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
//            
//            // Content view height
//            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
//        ])
//    }
//    
//    // MARK: - Actions
//    @objc private func textFieldDidChange() {
//        updateContinueButton()
//        updateDropdown()
//    }
//    
//    @objc private func textFieldDidBeginEditing() {
//        updateDropdown()
//    }
//    
//    @objc private func continueButtonTapped() {
//        guard let text = searchTextField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            return
//        }
//        
//        viewModel.searchOrganization(topic: text)
//    }
//    
//    @objc private func dismissDropdown() {
//        searchTextField.resignFirstResponder()
//        hideDropdown()
//    }
//    
//    private func updateContinueButton() {
//        let hasText = !(searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
//        continueButton.isEnabled = hasText
//        continueButton.backgroundColor = hasText ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
//    }
//    
//    private func updateDropdown() {
//        let searchText = searchTextField.text ?? ""
//        filteredCompanies = viewModel.getFilteredCompanies(for: searchText)
//        
//        if !filteredCompanies.isEmpty && searchTextField.isFirstResponder {
//            showDropdown()
//        } else {
//            hideDropdown()
//        }
//        
//        tableView.reloadData()
//    }
//    
//    private func showDropdown() {
//        isDropdownVisible = true
//        tableView.isHidden = false
//        
//        let maxHeight: CGFloat = 200
//        let calculatedHeight = min(CGFloat(filteredCompanies.count * 44), maxHeight)
//        
//        tableViewHeightConstraint.constant = calculatedHeight
//        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    private func hideDropdown() {
//        isDropdownVisible = false
//        tableViewHeightConstraint.constant = 0
//        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        } completion: { _ in
//            self.tableView.isHidden = true
//        }
//    }
//}
