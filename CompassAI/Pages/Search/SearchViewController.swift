import UIKit
import Foundation
import CoreData

// MARK: - Search View Controller
class SearchViewController: BaseViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var headerView: CompassAIHeaderView!
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let searchTextField = UITextField()
    private let tableView = UITableView()
    private let continueButton = UIButton(type: .system)
    private var footerView: CompassAIFooterView!
    
    // MARK: - Hamburger Menu Components
    private let hamburgerButton = UIButton(type: .system)
    private let sidePanel = UIView()
    private let sidePanelTableView = UITableView()
    private let overlayView = UIView()
    private var sidePanelLeadingConstraint: NSLayoutConstraint!
    private var isSidePanelVisible = false
    
    // MARK: - Properties
    var viewModel: SearchViewModel!
    private var filteredCompanies: [String] = []
    private var persistedQueryAnswers: [QueryAnswerObject] = []
    private var isDropdownVisible = false
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHamburgerMenu()
        setupSidePanel()
        setupConstraints()
//        fetchPersistedQueryAnswerObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPersistedQueryAnswerObjects()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPersistedQueryAnswerObjects()
        self.sidePanelTableView.reloadData()
    }
  
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Hide the navigation bar since we're using our custom header
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add the custom header with larger font size and no back button
        headerView = addCompassAIHeader(title: "Compass AI", showBackButton: false)
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.systemGroupedBackground
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Main card
        setupCard()
        
        // Footer
        setupFooter()
        
        // Dropdown table
        setupDropdown()
        
        // Tap gesture to dismiss dropdown
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDropdown))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupHamburgerMenu() {
        // Hamburger button
        hamburgerButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        hamburgerButton.tintColor = .black
        hamburgerButton.translatesAutoresizingMaskIntoConstraints = false
        hamburgerButton.addTarget(self, action: #selector(hamburgerButtonTapped), for: .touchUpInside)
        view.addSubview(hamburgerButton)
        
        // Overlay view for dimming background when side panel is open
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.alpha = 0
        overlayView.isHidden = true
        
        let overlayTap = UITapGestureRecognizer(target: self, action: #selector(closeSidePanel))
        overlayView.addGestureRecognizer(overlayTap)
        view.addSubview(overlayView)
    }
    
    private func setupSidePanel() {
        // Side panel setup
        sidePanel.backgroundColor = .white
        sidePanel.translatesAutoresizingMaskIntoConstraints = false
        sidePanel.layer.shadowColor = UIColor.black.cgColor
        sidePanel.layer.shadowOffset = CGSize(width: 2, height: 0)
        sidePanel.layer.shadowRadius = 8
        sidePanel.layer.shadowOpacity = 0.3
        view.addSubview(sidePanel)
        
        // Side panel header
        let headerLabel = UILabel()
        headerLabel.text = "Saved Answers"
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        sidePanel.addSubview(headerLabel)
        
        // Close button for side panel
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeSidePanel), for: .touchUpInside)
        sidePanel.addSubview(closeButton)
        
        // Side panel table view
        sidePanelTableView.delegate = self
        sidePanelTableView.dataSource = self
        sidePanelTableView.backgroundColor = .white
        sidePanelTableView.separatorStyle = .singleLine
        sidePanelTableView.translatesAutoresizingMaskIntoConstraints = false
        sidePanelTableView.register(QueryHistoryCell.self, forCellReuseIdentifier: "QueryHistoryCell")
        sidePanel.addSubview(sidePanelTableView)
        
        // Side panel constraints
        sidePanelLeadingConstraint = sidePanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -280)
        
        NSLayoutConstraint.activate([
            sidePanelLeadingConstraint,
            sidePanel.topAnchor.constraint(equalTo: view.topAnchor),
            sidePanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sidePanel.widthAnchor.constraint(equalToConstant: 280),
            
            // Header label
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: sidePanel.leadingAnchor, constant: 20),
            
            // Close button
            closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: sidePanel.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Table view
            sidePanelTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            sidePanelTableView.leadingAnchor.constraint(equalTo: sidePanel.leadingAnchor),
            sidePanelTableView.trailingAnchor.constraint(equalTo: sidePanel.trailingAnchor),
            sidePanelTableView.bottomAnchor.constraint(equalTo: sidePanel.bottomAnchor),
            
            // Overlay view
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        tableView.isUserInteractionEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CompanyCell")
        tableView.isHidden = true
        
        cardView.addSubview(tableView)
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
    }
    
    private func setupFooter() {
        footerView = addCompassAIFooter(
            to: scrollView,
            below: cardView.bottomAnchor
        )
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Hamburger button
            hamburgerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            hamburgerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            hamburgerButton.widthAnchor.constraint(equalToConstant: 30),
            hamburgerButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Scroll view - positioned flush against the header
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view - with spacing from scroll view top
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Card view - centered vertically with some offset
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
            
            // Content view height
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func hamburgerButtonTapped() {
        toggleSidePanel()
    }
    
    @objc private func closeSidePanel() {
        hideSidePanel()
    }
    
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
    
    // MARK: - Side Panel Methods
    private func toggleSidePanel() {
        if isSidePanelVisible {
            hideSidePanel()
        } else {
            showSidePanel()
        }
    }
    
    private func showSidePanel() {
        isSidePanelVisible = true
        overlayView.isHidden = false
        sidePanelLeadingConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideSidePanel() {
        isSidePanelVisible = false
        sidePanelLeadingConstraint.constant = -280
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.overlayView.isHidden = true
        }
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
    
    private func fetchPersistedQueryAnswerObjects() {
        let req: NSFetchRequest<QueryAnswerObject> = QueryAnswerObject.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: #keyPath(QueryAnswerObject.date_persisted), ascending: false)]
        let persistence = CoreDataPersistence()
        let context = persistence.container.viewContext
        
        do {
            self.persistedQueryAnswers = try context.fetch(req)
//            // Debug print
//            print("First Persisted query answers:")
//            for oneQueryAnswerObject in self.persistedQueryAnswers {
//                print(oneQueryAnswerObject.topic ?? "No topic")
//            }
//            print()
            // Debug: Check if relationships are loaded
            for qa in self.persistedQueryAnswers {
                if qa.created_with_financial_contributions_info {
                    print("Topic: \(qa.topic ?? "nil")")
                    print("Has financial relationship: \(qa.finanicial_contributions_overview != nil)")
                    if let financial = qa.finanicial_contributions_overview {
                        print("  - Committee: \(financial.committee_name ?? "nil")")
                        print("  - Summary preview: \(financial.fec_financial_contributions_summary_text?.prefix(50) ?? "nil")")
                    }
                }
            }
        } catch {
            print("Fetch error:", error)
        }
    }
    
    private func removePersistedQueryAnswer(context: NSManagedObjectContext, organizationName: String) {
        let request: NSFetchRequest<QueryAnswerObject> = QueryAnswerObject.fetchRequest()
        request.predicate = NSPredicate(format: "topic == %@", organizationName)
        
        do {
            let results = try context.fetch(request)
            for result in results {
                context.delete(result)
            }
            try context.save()
//            print("Analysis removed from saved items")
        } catch {
            print("Error removing saved analysis: \(error)")
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sidePanelTableView {
            return persistedQueryAnswers.count
        } else {
            return filteredCompanies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sidePanelTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueryHistoryCell", for: indexPath) as! QueryHistoryCell
            // The correct way?
            do {
                let (objectID, context) = objectIDForIndexPathRow(indexPathRow: indexPath.row)
                let freshObject: QueryAnswerObject = try context.existingObject(with: objectID) as! QueryAnswerObject
//                print("Fresh object topic: \(freshObject.topic ?? "nil")")
                if freshObject.topic != nil {
                    cell.configure(with: freshObject)
                }
            } catch { // If that won't work fall back to something else idk.
                // This pretty much won't ever actually get called.
                print("Error getting fresh object: \(error)")
                let queryAnswer: QueryAnswerObject = persistedQueryAnswers[indexPath.row]
                cell.configure(with: queryAnswer)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath)
            cell.textLabel?.text = filteredCompanies[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.selectionStyle = .default
            cell.isUserInteractionEnabled = true
            cell.contentView.isUserInteractionEnabled = true
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == sidePanelTableView {
            return 70
        } else {
            return 44
        }
    }
    
    // MARK: - Swipe to Delete for Side Panel
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Only allow editing (swipe to delete) for the side panel table view
        return tableView == sidePanelTableView
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == sidePanelTableView && editingStyle == .delete {

            // Get a fresh copy of the object
            let (objectID, context) = objectIDForIndexPathRow(indexPathRow: indexPath.row)
            
            do {
                let freshObject: QueryAnswerObject = try context.existingObject(with: objectID) as! QueryAnswerObject
//                print("Fresh object topic: \(freshObject.topic ?? "nil")")
                
                // Now proceed with deletion using the fresh object
                if let topicToDelete = freshObject.topic {
                    CoreDataHelper.removePersistedQueryAnswer(
                        context: context,
                        organizationName: topicToDelete,
                        completion: { _ in
                            // Remove from local array and table view
                            DispatchQueue.main.async {
                                // Remove from local array and table view
                                self.persistedQueryAnswers.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                            }
                        }
                    )
                }
            } catch {
                print("Error getting fresh object: \(error)")
            }
        }
    }
        
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if tableView == sidePanelTableView {
            return "Delete"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == sidePanelTableView {
            
            // Get a fresh copy of the object
            let (objectID, context) = objectIDForIndexPathRow(indexPathRow: indexPath.row)
            
            do {
                let freshObject = try context.existingObject(with: objectID) as! QueryAnswerObject
//                print("Fresh object topic: \(freshObject.topic ?? "nil")")
                
                if let topic = freshObject.topic {
                    
                    let financialContributions = freshObject.finanicial_contributions_overview
                    let finanical_exits = financialContributions != nil
                    var financialContributionsOverviewAnaylsis: FinancialContributionsAnalysis?
//                    print("||Financial contributions loaded: \(finanical_exits)")
                    if let financial_contributions = financialContributions {
//                        print("Committee: \(financial.committee_name ?? "nil")")
//                        print("Summary: \(financial.fec_financial_contributions_summary_text?.prefix(100) ?? "nil")")
                        
//                        print("Financial percent_contributions          \(financial.percent_contributions)\n")
//                        print("||Financial contributions_totals_list      \(financial.contributions_totals_list)\n")
//                        print("||Financial leadership_con//**tributions_list  \(financial.leadership_contrib*/utions_list)\n\n")
                        
                        // Percent contributions.
                        // This is much more important than the other two sub relations.
                        var percentContributions:PercentContributions?
                        if let percentContributionsManagedObject = financial_contributions.percent_contributions {
                            percentContributions = PercentContributions(
                                totalToDemocrats: Int(percentContributionsManagedObject.total_to_democrats),
                                totalToRepublicans: Int(percentContributionsManagedObject.total_to_republicans),
                                percentToDemocrats: percentContributionsManagedObject.percent_to_democrats,
                                percentToRepublicans: percentContributionsManagedObject.percent_to_republicans,
                                totalContributions: Int(percentContributionsManagedObject.total_contributions)
                            )
                        } else{
                            
                        }
                        
                        
                        // I think this is kind of different than the other ones.
                        // Contribution totals
                        // TODO: This feels like way to much for object deserialization. Think of a more modern way to do this.
                        var contributionTotalsList = [ContributionTotal]()
                        _ = financial_contributions.contributions_totals_list?.count
                        if let contributionTotalsListManagedObject = financial_contributions.contributions_totals_list {
                            
//                            print("|| contributionTotalsListManagedObject \(contributionTotalsListManagedObject)")
                            for case let one_contributionTotalsListManagedObject as     FinancialContribution_ContributionTotals_ListItem in contributionTotalsListManagedObject {
                                let oneContributionTotal = ContributionTotal(
                                    recipientID: one_contributionTotalsListManagedObject.recipient_id,
                                    recipientName: one_contributionTotalsListManagedObject.recipient_name,
                                    numberOfContributions: Int(one_contributionTotalsListManagedObject.number_of_contributions),
                                    totalContributionAmount: Int(one_contributionTotalsListManagedObject.total_contribution_amount)
                                )
                                contributionTotalsList.append(oneContributionTotal)
                            }
                        }
//                        
                        // Leadership contributions
                        var leadershipContributionsToCommitteeList = [LeadershipContribution]()
                        if let leadershipContributionsToCommitteeListManagedObject = financial_contributions.leadership_contributions_list {
//                            print("|| leadershipContributionsToCommitteeListManagedObject \(leadershipContributionsToCommitteeListManagedObject)")
                            for case let one_leadershipContributionsToCommitteeManagedObject as     FinancialContribution_LeadershipContributorsToCommittee_ListItem in leadershipContributionsToCommitteeListManagedObject {
                                let oneleadershipContributionsToCommittee = LeadershipContribution(
                                    occupation: one_leadershipContributionsToCommitteeManagedObject.occupation  ?? "",
                                    name: one_leadershipContributionsToCommitteeManagedObject.name  ?? "",
                                    employer: one_leadershipContributionsToCommitteeManagedObject.employer  ?? "",
                                    transactionAmount: one_leadershipContributionsToCommitteeManagedObject.transaction_amount ?? "")
                                leadershipContributionsToCommitteeList.append(oneleadershipContributionsToCommittee)
                            }
                        }
                        
                        financialContributionsOverviewAnaylsis = FinancialContributionsAnalysis(
                            financialContributionsText: financial_contributions.fec_financial_contributions_summary_text,
                            committeeOrPACName: financial_contributions.committee_name,
                            committeeOrPACID: financial_contributions.committee_id,
                            percentContributions: percentContributions,
                            contributionTotals: contributionTotalsList,
                            leadershipContributionsToCommittee: leadershipContributionsToCommitteeList)
                        
                    }
                    
                    
                    // Create OrganizationAnalysis from persisted data
                    let analysis = OrganizationAnalysis(
                        topic: freshObject.topic ?? "", // The json calls it topic, but this is the name.
                        lean: freshObject.lean ?? "Unknown",
                        rating: Int(freshObject.rating),
                        description: freshObject.context ?? "No description available",
                        hasFinancialContributions: freshObject.created_with_financial_contributions_info, /*financialContributionsOverviewAnalysis: nil*/
//                        financialContributionsText: freshObject.context
                        financialContributionsText: "No description available",
                        financialContributionsOverviewAnalysis: financialContributionsOverviewAnaylsis
                    )
                    print("\n\nPersisted freshObject for topic: \(topic)")
                    print("Persisted freshObject:\n\n      \(freshObject)\n\n")
                    print("Analysis object for topic: \(topic)")
                    print("Analysis:\n\n      \(analysis)")
                    print("Analysis Financial percent_contributions          \(analysis.financialContributionsOverviewAnalysis?.percentContributions)\n")
                    print("Analysis Financial percent_contributions more         \(analysis.financialContributionsOverviewAnalysis?.percentContributions?.percentToDemocrats)\n")
                    print("Analysis Financial percent_contributions more         \(analysis.financialContributionsOverviewAnalysis?.percentContributions?.percentToRepublicans)\n")
                    print("Analysis Financial percent_contributions more         \(analysis.financialContributionsOverviewAnalysis?.percentContributions?.totalContributions)\n")
                    print("Analysis Financial percent_contributions more         \(analysis.financialContributionsOverviewAnalysis?.percentContributions?.totalToDemocrats)\n")
                    print("Analysis Financial percent_contributions more         \(analysis.financialContributionsOverviewAnalysis?.percentContributions?.totalToRepublicans)\n")
                    
                    // Navigate to overview page using your coordinator/navigation method
                    // You'll need to replace this with your actual navigation method
                    viewModel.navigateToOverviewWithPersistedData(
                        analysis: analysis,
                        organizationName: topic,
                        from: self
                    )
                    
                    hideSidePanel()
                }
                
            } catch {
                print("Error getting fresh object: \(error)")
            }
            
        } else {
            DispatchQueue.main.async { [self] in
                tableView.deselectRow(at: indexPath, animated: true)
                self.searchTextField.text = self.filteredCompanies[indexPath.row]
                self.updateContinueButton()
                self.hideDropdown()
                self.searchTextField.resignFirstResponder()
            }
        }
    }
    
    
    func objectIDForIndexPathRow(indexPathRow: Int) -> (NSManagedObjectID, NSManagedObjectContext) {
        // Get a fresh copy of the object
        let persistence = CoreDataPersistence()
        let context = persistence.container.viewContext
        
        let objectID = self.persistedQueryAnswers[indexPathRow].objectID
        return (objectID, context)
    }
    
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view?.superview is UITableViewCell)
    }
}



//
//
// Query history
//
//

// MARK: - Custom Cell for Query History
class QueryHistoryCell: UITableViewCell {
    private let topicLabel = UILabel()
    private let dateLabel = UILabel()
    private let ratingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Topic label
        topicLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        topicLabel.textColor = .black
        topicLabel.numberOfLines = 2
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Date label
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Rating label
        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        ratingLabel.textColor = .systemBlue
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(topicLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            topicLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            topicLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
//            topicLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -8),
            topicLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: 0),
            
            dateLabel.topAnchor.constraint(equalTo: topicLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: topicLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with queryAnswer: QueryAnswerObject) {

        if let topicName = queryAnswer.topic {
            topicLabel.text = topicName
        } else {
            topicLabel.text = "Unknown Topic at configure"
        }
 
    }
}
