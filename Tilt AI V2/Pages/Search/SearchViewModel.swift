//
//  SearchViewModelDelegate.swift
//  Tilt AI V2
//
//  Created by Steve on 8/21/25.
//
import UIKit
import Foundation

// MARK: - Search ViewModel
protocol SearchViewModelDelegate: AnyObject {
    func searchDidStart()
    func searchDidComplete(with analysis: OrganizationAnalysis)
    func searchDidFail(with error: String)
}

// MARK: - Search ViewModel
class SearchViewModel {
    weak var coordinator: AppCoordinator?
    private let networkManager = NetworkManager.shared
    
    let suggestedCompanies = [
        "Microsoft",
        "Alpha and Omega Semiconductor Limited",
        "Lattice Semiconductor Corporation",
        "indie Semiconductor, Inc.",
        "NXP Semiconductors N.V.",
        "Microchip Technology Incorporated",
        "Microsoft Corporation"
    ]
    
    func getFilteredCompanies(for searchText: String) -> [String] {
        if searchText.isEmpty {
            return suggestedCompanies
        }
        return suggestedCompanies.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func searchOrganization(topic: String, from viewController: UIViewController) {
        guard !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        coordinator?.showLoadingScreen()
        
        networkManager.getPoliticalLeaning(for: topic) { [weak self] result in
            print("Political Leaning Result: \(result)\n")
            switch result {
            case .success(let politicalResponse):
                print("Political Leaning Response: \(politicalResponse)\n")
                // Check if we need financial contributions
//                if politicalResponse.createdWithFinancialContributionsInfo == true {
//                    self?.fetchFinancialContributions(
//                        for: topic,
//                        politicalResponse: politicalResponse
//                    )
//                } else {
                
                    let analysis = OrganizationAnalysis(
                        lean: politicalResponse.lean,
                        rating: politicalResponse.rating.value, // TODO: Remove value (and flexible in as a while) and replace with int once the backend code is correctly updated.
                        description: politicalResponse.context,
                        hasFinancialContributions: politicalResponse.createdWithFinancialContributionsInfo,
                        financialContributionsText: nil
                    )
                    DispatchQueue.main.async {
                        self?.coordinator?.showResultsScreen(with: analysis, organizationName: topic)
                    }
                
//                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.coordinator?.showError(message: error.localizedDescription, from: viewController)
                }
            }
        }
    }
    
    private func fetchFinancialContributions(for topic: String, politicalResponse: PoliticalLeaningResponse) {
        networkManager.getFinancialContributionsOverview(for: topic) { [weak self] result in
            print("Financial Result: \(result)\n")
            let analysis: OrganizationAnalysis
            switch result {
            case .success(let financialResponse):
                print("Financial Response: \(financialResponse)\n")
                analysis = OrganizationAnalysis(
                    lean: politicalResponse.lean,
                    rating: politicalResponse.rating.value, // TODO: Remove value (and flexible in as a while) and replace with int once the backend code is correctly updated.
                    description: politicalResponse.context,
                    hasFinancialContributions: true,
                    financialContributionsText: financialResponse.fecFinancialContributionsSummaryText
                )
                
            case .failure:
                // If financial contributions fail, still show the political data
                analysis = OrganizationAnalysis(
                    lean: politicalResponse.lean,
                    rating: politicalResponse.rating.value, // TODO: Remove value (and flexible in as a while) and replace with int once the backend code is correctly updated.
                    description: politicalResponse.context,
                    hasFinancialContributions: false,
                    financialContributionsText: nil
                )
            }
            
            DispatchQueue.main.async {
                self?.coordinator?.showResultsScreen(with: analysis, organizationName: topic)
            }
        }
    }
}
