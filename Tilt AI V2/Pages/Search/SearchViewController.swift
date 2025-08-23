//
//  SearchViewController.swift
//  Tilt AI V2
//
//  Created by Steve on 8/21/25.
//
import UIKit
import Foundation

// MARK: - Search View Controller
class SearchViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerLabel = UILabel()
    private let titleLabel = UILabel()
    private let cardView = UIView()
    private let searchTextField = UITextField()
    private let tableView = UITableView()
    private let continueButton = UIButton(type: .system)
    private let footerStackView = UIStackView()
    
    // MARK: - Properties
    var viewModel: SearchViewModel!
    private var filteredCompanies: [String] = []
    private var isDropdownVisible = false
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Header
        setupHeader()
        
        // Main card
        setupCard()
        
        // Footer
        setupFooter()
        
        // Dropdown table
        setupDropdown()
        
        // Tap gesture to dismiss dropdown
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDropdown))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupHeader() {
        let headerStackView = UIStackView()
        headerStackView.axis = .horizontal
        headerStackView.spacing = 8
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let slashLabel = UILabel()
        slashLabel.text = "/"
        slashLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
        slashLabel.textColor = .black
        
        headerLabel.text = "Tilt AI"
        headerLabel.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        headerLabel.textColor = .black
        
        headerStackView.addArrangedSubview(slashLabel)
        headerStackView.addArrangedSubview(headerLabel)
        
        contentView.addSubview(headerStackView)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
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
        
        // Title
        titleLabel.text = "What organization do you want to find the political leaning of?"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Search text field
        searchTextField.placeholder = "Type here..."
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.borderStyle = .roundedRect
        searchTextField.layer.borderColor = UIColor.systemGray4.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 8
        searchTextField.backgroundColor = .white
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        
        // Continue button
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        continueButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 8
        continueButton.isEnabled = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(searchTextField)
        cardView.addSubview(continueButton)
        contentView.addSubview(cardView)
    }
    
    private func setupDropdown() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 8
        tableView.layer.borderColor = UIColor.systemGray4.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 8
        tableView.layer.shadowOpacity = 0.1
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CompanyCell")
        tableView.isHidden = true
        
        cardView.addSubview(tableView)
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
    }
    
    private func setupFooter() {
        footerStackView.axis = .vertical
        footerStackView.spacing = 8
        footerStackView.alignment = .center
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let copyrightLabel = UILabel()
        copyrightLabel.text = "© 2025 Correlation LLC. All rights reserved."
        copyrightLabel.font = UIFont.systemFont(ofSize: 14)
        copyrightLabel.textColor = .systemGray
        copyrightLabel.textAlignment = .center
        
        let dataSourceLabel = UILabel()
        dataSourceLabel.text = "Data sourced from public FEC filings and other regulatory sources."
        dataSourceLabel.font = UIFont.systemFont(ofSize: 14)
        dataSourceLabel.textColor = .systemGray
        dataSourceLabel.textAlignment = .center
        dataSourceLabel.numberOfLines = 0
        
        let emailImageView = UIImageView(image: UIImage(systemName: "envelope"))
        emailImageView.tintColor = .systemGray
        emailImageView.contentMode = .scaleAspectFit
        
        let disclaimerLabel = UILabel()
        disclaimerLabel.text = "This website provides information derived from publicly available data. Tilt AI and Correlation LLC do not endorse any political candidates or organizations mentioned."
        disclaimerLabel.font = UIFont.systemFont(ofSize: 12)
        disclaimerLabel.textColor = .systemGray
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.numberOfLines = 0
        
        footerStackView.addArrangedSubview(copyrightLabel)
        footerStackView.addArrangedSubview(dataSourceLabel)
        footerStackView.addArrangedSubview(emailImageView)
        footerStackView.addArrangedSubview(disclaimerLabel)
        
        contentView.addSubview(footerStackView)
    }
    
    // MARK: - Constraints
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
            
            // Card view
            cardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            // Search text field
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Table view (dropdown)
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            
            // Continue button
            continueButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            continueButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30),
            
            // Footer
            footerStackView.topAnchor.constraint(greaterThanOrEqualTo: cardView.bottomAnchor, constant: 40),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Content view height
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        updateContinueButton()
        updateDropdown()
    }
    
    @objc private func textFieldDidBeginEditing() {
        updateDropdown()
    }
    
    @objc private func continueButtonTapped() {
        guard let text = searchTextField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        viewModel.searchOrganization(topic: text, from: self)
    }
    
    @objc private func dismissDropdown() {
        searchTextField.resignFirstResponder()
        hideDropdown()
    }
    
    private func updateContinueButton() {
        let hasText = !(searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        continueButton.isEnabled = hasText
        continueButton.backgroundColor = hasText ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
    }
    
    private func updateDropdown() {
        let searchText = searchTextField.text ?? ""
        filteredCompanies = viewModel.getFilteredCompanies(for: searchText)
        
        if !filteredCompanies.isEmpty && searchTextField.isFirstResponder {
            showDropdown()
        } else {
            hideDropdown()
        }
        
        tableView.reloadData()
    }
    
    private func showDropdown() {
        isDropdownVisible = true
        tableView.isHidden = false
        
        let maxHeight: CGFloat = 200
        let calculatedHeight = min(CGFloat(filteredCompanies.count * 44), maxHeight)
        
        tableViewHeightConstraint.constant = calculatedHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDropdown() {
        isDropdownVisible = false
        tableViewHeightConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.tableView.isHidden = true
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath)
        cell.textLabel?.text = filteredCompanies[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchTextField.text = filteredCompanies[indexPath.row]
        updateContinueButton()
        hideDropdown()
        searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - Search View Controller
// MARK: - Search View Controller
//class SearchViewController: UIViewController {
//    
//    // MARK: - UI Components
//    private let scrollView = UIScrollView()
//    private let contentView = UIView()
//    private let headerLabel = UILabel()
//    private let titleLabel = UILabel()
//    private let cardView = UIView()
//    private let searchTextField = UITextField()
//    private let tableView = UITableView()
//    private let continueButton = UIButton(type: .system)
//    private let footerStackView = UIStackView()
//    
//    // MARK: - Properties
//    var viewModel: SearchViewModel!
//    private var filteredCompanies: [String] = []
//    private var isDropdownVisible = false
//    private var tableViewHeightConstraint: NSLayoutConstraint!
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupConstraints()
//    }
//    
//    // MARK: - UI Setup
//    private func setupUI() {
//        view.backgroundColor = UIColor.systemGroupedBackground
//        
//        // Configure scroll view
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        
//        // Header
//        setupHeader()
//        
//        // Main card
//        setupCard()
//        
//        // Footer
//        setupFooter()
//        
//        // Dropdown table
//        setupDropdown()
//        
//        // Tap gesture to dismiss dropdown
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDropdown))
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    private func setupHeader() {
//        let headerStackView = UIStackView()
//        headerStackView.axis = .horizontal
//        headerStackView.spacing = 8
//        headerStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let slashLabel = UILabel()
//        slashLabel.text = "/"
//        slashLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
//        slashLabel.textColor = .black
//        
//        headerLabel.text = "Tilt AI"
//        headerLabel.font = UIFont.systemFont(ofSize: 40, weight: .medium)
//        headerLabel.textColor = .black
//        
//        headerStackView.addArrangedSubview(slashLabel)
//        headerStackView.addArrangedSubview(headerLabel)
//        
//        contentView.addSubview(headerStackView)
//        
//        NSLayoutConstraint.activate([
//            headerStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
//            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
//        ])
//    }
//    
//    private func setupCard() {
//        cardView.backgroundColor = .white
//        cardView.layer.cornerRadius = 16
//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
//        cardView.layer.shadowRadius = 16
//        cardView.layer.shadowOpacity = 0.1
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Title
//        titleLabel.text = "What organization do you want to find the political leaning of?"
//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
//        titleLabel.textColor = .black
//        titleLabel.numberOfLines = 0
//        titleLabel.textAlignment = .center
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Search text field
//        searchTextField.placeholder = "Type here..."
//        searchTextField.font = UIFont.systemFont(ofSize: 16)
//        searchTextField.borderStyle = .roundedRect
//        searchTextField.layer.borderColor = UIColor.systemGray4.cgColor
//        searchTextField.layer.borderWidth = 1
//        searchTextField.layer.cornerRadius = 8
//        searchTextField.backgroundColor = .white
//        searchTextField.translatesAutoresizingMaskIntoConstraints = false
//        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        searchTextField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
//        
//        // Continue button
//        continueButton.setTitle("Continue", for: .normal)
//        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        continueButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
//        continueButton.setTitleColor(.white, for: .normal)
//        continueButton.layer.cornerRadius = 8
//        continueButton.isEnabled = false
//        continueButton.translatesAutoresizingMaskIntoConstraints = false
//        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
//        
//        cardView.addSubview(titleLabel)
//        cardView.addSubview(searchTextField)
//        cardView.addSubview(continueButton)
//        contentView.addSubview(cardView)
//    }
//    
//    private func setupDropdown() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .white
//        tableView.layer.cornerRadius = 8
//        tableView.layer.borderColor = UIColor.systemGray4.cgColor
//        tableView.layer.borderWidth = 1
//        tableView.layer.shadowColor = UIColor.black.cgColor
//        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        tableView.layer.shadowRadius = 8
//        tableView.layer.shadowOpacity = 0.1
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CompanyCell")
//        tableView.isHidden = true
//        
//        cardView.addSubview(tableView)
//        
//        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
//        tableViewHeightConstraint.isActive = true
//    }
//    
//    private func setupFooter() {
//        footerStackView.axis = .vertical
//        footerStackView.spacing = 8
//        footerStackView.alignment = .center
//        footerStackView.translatesAutoresizingMaskIntoConstraints = false
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
//        viewModel.searchOrganization(topic: text, from: self)
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
//
//// MARK: - TableView DataSource & Delegate
//extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredCompanies.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath)
//        cell.textLabel?.text = filteredCompanies[indexPath.row]
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
//        cell.selectionStyle = .default
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        searchTextField.text = filteredCompanies[indexPath.row]
//        updateContinueButton()
//        hideDropdown()
//        searchTextField.resignFirstResponder()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
//}

//class SearchViewController: UIViewController {
//    
//    // MARK: - UI Components
//    private let scrollView = UIScrollView()
//    private let contentView = UIView()
//    private let headerLabel = UILabel()
//    private let titleLabel = UILabel()
//    private let cardView = UIView()
//    private let searchTextField = UITextField()
//    private let tableView = UITableView()
//    private let continueButton = UIButton(type: .system)
//    private let footerStackView = UIStackView()
//    
//    // MARK: - Properties
//    private let viewModel = SearchViewModel()
//    private var filteredCompanies: [String] = []
//    private var isDropdownVisible = false
//    private var tableViewHeightConstraint: NSLayoutConstraint!
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupConstraints()
//        viewModel.delegate = self
//        
//        // Hide navigation bar
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    
//    // MARK: - UI Setup
//    private func setupUI() {
//        view.backgroundColor = UIColor.systemGroupedBackground
//        
//        // Configure scroll view
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        
//        // Header
//        setupHeader()
//        
//        // Main card
//        setupCard()
//        
//        // Footer
//        setupFooter()
//        
//        // Dropdown table
//        setupDropdown()
//        
//        // Tap gesture to dismiss dropdown
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDropdown))
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    private func setupHeader() {
//        let headerStackView = UIStackView()
//        headerStackView.axis = .horizontal
//        headerStackView.spacing = 8
//        headerStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let slashLabel = UILabel()
//        slashLabel.text = "/"
//        slashLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
//        slashLabel.textColor = .black
//        
//        headerLabel.text = "Tilt AI"
//        headerLabel.font = UIFont.systemFont(ofSize: 40, weight: .medium)
//        headerLabel.textColor = .black
//        
//        headerStackView.addArrangedSubview(slashLabel)
//        headerStackView.addArrangedSubview(headerLabel)
//        
//        contentView.addSubview(headerStackView)
//        
//        NSLayoutConstraint.activate([
//            headerStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
//            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
//        ])
//    }
//    
//    private func setupCard() {
//        cardView.backgroundColor = .white
//        cardView.layer.cornerRadius = 16
//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
//        cardView.layer.shadowRadius = 16
//        cardView.layer.shadowOpacity = 0.1
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Title
//        titleLabel.text = "What organization do you want to find the political leaning of?"
//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
//        titleLabel.textColor = .black
//        titleLabel.numberOfLines = 0
//        titleLabel.textAlignment = .center
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Search text field
//        searchTextField.placeholder = "Type here..."
//        searchTextField.font = UIFont.systemFont(ofSize: 16)
//        searchTextField.borderStyle = .roundedRect
//        searchTextField.layer.borderColor = UIColor.systemGray4.cgColor
//        searchTextField.layer.borderWidth = 1
//        searchTextField.layer.cornerRadius = 8
//        searchTextField.backgroundColor = .white
//        searchTextField.translatesAutoresizingMaskIntoConstraints = false
//        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        searchTextField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
//        
//        // Continue button
//        continueButton.setTitle("Continue", for: .normal)
//        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        continueButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
//        continueButton.setTitleColor(.white, for: .normal)
//        continueButton.layer.cornerRadius = 8
//        continueButton.isEnabled = false
//        continueButton.translatesAutoresizingMaskIntoConstraints = false
//        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
//        
//        cardView.addSubview(titleLabel)
//        cardView.addSubview(searchTextField)
//        cardView.addSubview(continueButton)
//        contentView.addSubview(cardView)
//    }
//    
//    private func setupDropdown() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .white
//        tableView.layer.cornerRadius = 8
//        tableView.layer.borderColor = UIColor.systemGray4.cgColor
//        tableView.layer.borderWidth = 1
//        tableView.layer.shadowColor = UIColor.black.cgColor
//        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        tableView.layer.shadowRadius = 8
//        tableView.layer.shadowOpacity = 0.1
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CompanyCell")
//        tableView.isHidden = true
//        
//        cardView.addSubview(tableView)
//        
//        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
//        tableViewHeightConstraint.isActive = true
//    }
//    
//    private func setupFooter() {
//        footerStackView.axis = .vertical
//        footerStackView.spacing = 8
//        footerStackView.alignment = .center
//        footerStackView.translatesAutoresizingMaskIntoConstraints = false
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
//
//// MARK: - TableView DataSource & Delegate
//extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredCompanies.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath)
//        cell.textLabel?.text = filteredCompanies[indexPath.row]
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
//        cell.selectionStyle = .default
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        searchTextField.text = filteredCompanies[indexPath.row]
//        updateContinueButton()
//        hideDropdown()
//        searchTextField.resignFirstResponder()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
//}



//// MARK: - SearchViewModel Delegate
//extension SearchViewController: SearchViewModelDelegate {
//    func searchDidStart() {
//        let loadingVC = LoadingViewController()
//        navigationController?.pushViewController(loadingVC, animated: true)
//    }
//    
//    func searchDidComplete(with analysis: OrganizationAnalysis) {
//        // Remove loading view controller if it exists
//        if let loadingVC = navigationController?.topViewController as? LoadingViewController {
//            navigationController?.popViewController(animated: false)
//        }
//        
//        let resultsVC = ResultsViewController()
//        resultsVC.configure(with: analysis, organizationName: searchTextField.text ?? "", coordinator: <#AppCoordinator#>)
//        navigationController?.pushViewController(resultsVC, animated: true)
//    }
//    
//    func searchDidFail(with error: String) {
//        // Remove loading view controller if it exists
//        if let loadingVC = navigationController?.topViewController as? LoadingViewController {
//            navigationController?.popViewController(animated: false)
//        }
//        
//        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
