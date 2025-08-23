//
//  FinancialContributionsViewModel.swift
//  Tilt AI V2
//
//  Created by Steve on 8/23/25.
//
import Foundation

// MARK: - Financial Contributions ViewModel
class FinancialContributionsViewModel {
    weak var coordinator: AppCoordinator?
    private let networkManager = NetworkManager.shared
    
    // Published properties for the view to observe
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onDataLoaded: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchFinancialContributions(for organizationName: String) {
        onLoadingStateChanged?(true)
        
        networkManager.getFinancialContributionsOverview(for: organizationName) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChanged?(false)
                
                switch result {
                case .success(let financialResponse):
                    self?.onDataLoaded?(financialResponse.fecFinancialContributionsSummaryText)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
