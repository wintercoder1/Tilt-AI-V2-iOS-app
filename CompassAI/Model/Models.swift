//
//  Models.swift
//  Compass AI V2
//
//  Created by Steve on 8/21/25.
//

// MARK: - Models
struct OrganizationAnalysis {
    let topic: String
    let lean: String
    let rating: Int // FlexibleInt // TODO: Remove and replace with int once the backend is correctly updated.
    let description: String
    let hasFinancialContributions: Bool
    let financialContributionsText: String?
    let financialContributionsOverviewAnalysis: FinancialContributionsAnalysis?
}

struct FinancialContributionsAnalysis {
    let financialContributionsText: String?
    let committeeOrPACName: String?
    let committeeOrPACID: String?
    let percentContributions: PercentContributions?
    let contributionTotals: [ContributionTotal]?
    let leadershipContributionsToCommittee: [LeadershipContribution]?
}

struct PoliticalLeaningResponse: Codable {
    // Mandatory
    let lean: String
    let rating: FlexibleInt // TODO: Remove and replace with int once the backend is correctly updated.
    let context: String
    let createdWithFinancialContributionsInfo: Bool
    // Optional
    let timestamp: Double?
    let normalizedTopicName: String?
    let topic: String?
    let citation: String?
    let upvoteCount: Int?
    let downvoteCount: Int?
    let queryType: String?
    let debug: DebugInfo?
    let response_error: PoliticalLeaningResponseError?
    
    enum CodingKeys: String, CodingKey {
        case lean
        case rating
        case context
        case createdWithFinancialContributionsInfo = "created_with_financial_contributions_info"
        case timestamp
        case normalizedTopicName = "normalized_topic_name"
        case topic
        case citation
        case upvoteCount = "upvote_count"
        case downvoteCount = "downvote_count"
        case queryType = "query_type"
        case debug
        case response_error
        case response
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to get rating, lean, and context from nested response object first
        // TODO: Make this never get returned from the backend.
        if let responseObject = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response) {

            rating = try responseObject.decode(FlexibleInt.self, forKey: .rating)
//            rating = try responseObject.decode(Int.self, forKey: .rating)
            lean = try responseObject.decode(String.self, forKey: .lean)
            context = try responseObject.decode(String.self, forKey: .context)
            createdWithFinancialContributionsInfo = try responseObject.decode(Bool.self, forKey: .createdWithFinancialContributionsInfo)
            
            timestamp = nil
            normalizedTopicName = nil
            topic = nil
            citation = nil
            upvoteCount = nil
            downvoteCount = nil
            queryType = nil
            debug  = nil
            response_error = nil
            
        } else {
            // Fall back to top-level fields
            // This is the correct case.
            // TODO: Change the backend so that this is the only type we need to account for.
            rating = try container.decode(FlexibleInt.self, forKey: .rating)
//            rating = try container.decode(Int.self, forKey: .rating)
            lean = try container.decode(String.self, forKey: .lean)
            context = try container.decode(String.self, forKey: .context)
            createdWithFinancialContributionsInfo = try container.decode(Bool.self, forKey: .createdWithFinancialContributionsInfo)
            timestamp = try container.decode(Double.self, forKey: .timestamp)
            normalizedTopicName = try container.decode(String.self, forKey: .normalizedTopicName)
            topic = try container.decode(String.self, forKey: .topic)
            citation = try container.decode(String.self, forKey: .citation)
            upvoteCount = try container.decode(Int.self, forKey: .upvoteCount)
            downvoteCount = try container.decode(Int.self, forKey: .downvoteCount)
            queryType = try container.decode(String.self, forKey: .queryType)
            debug = try container.decode(DebugInfo.self, forKey: .debug)
            response_error = try container.decode(PoliticalLeaningResponseError.self, forKey: .debug)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(normalizedTopicName, forKey: .normalizedTopicName)
        try container.encode(topic, forKey: .topic)
        try container.encode(rating, forKey: .rating)
        try container.encode(context, forKey: .context)
        try container.encode(citation, forKey: .citation)
        try container.encode(createdWithFinancialContributionsInfo, forKey: .createdWithFinancialContributionsInfo)
        try container.encode(lean, forKey: .lean)
        try container.encode(upvoteCount, forKey: .upvoteCount)
        try container.encode(downvoteCount, forKey: .downvoteCount)
        try container.encode(queryType, forKey: .queryType)
        try container.encode(debug, forKey: .debug)
    }
    
    private enum ResponseKeys: String, CodingKey {
        case rating
        case lean
        case context
        case createdWithFinancialContributionsInfo  = "created_with_financial_contributions_info"
    }
}

// The backend could return either a string or in as the rating. This is a workaround. Only temporary.
struct FlexibleInt: Codable {
    let value: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let stringValue = try? container.decode(String.self),
                  let intValue = Int(stringValue) {
            value = intValue
        } else {
            throw DecodingError.typeMismatch(Int.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected Int or String that can be converted to Int"
            ))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

struct DebugInfo: Codable {
    let persistedResponse: Bool
    let newlyGenerated: Bool
    
    enum CodingKeys: String, CodingKey {
        case persistedResponse = "persisted_response"
        case newlyGenerated = "newly_generated"
    }
}

struct PoliticalLeaningResponseError: Codable {
    let error: Bool? // Only on errror case
    let message: String? // Only on errror case
    enum CodingKeys: String, CodingKey {
        case error
        case message
    }
}

struct FinancialContributionsResponse: Codable {
    let topic: String
    let normalizedTopicName: String
    let timestamp: String?
    let committeeId: String
    let individualId: Int
    let fecFinancialContributionsSummaryText: String
    let upvoteCount: Int?
    let downvoteCount: Int?
    let timeRangeOfData: String?
    let cycleEndYear: String?
    let committeeName: String?
    let queryType: String?
    let debug: FinancialDebugInfo?
    let percentContributions: PercentContributions?
    let contributionTotals: [ContributionTotal]?
    let leadershipContributionsToCommittee: [LeadershipContribution]?
    
    enum CodingKeys: String, CodingKey {
        case topic
        case normalizedTopicName = "normalized_topic_name"
        case timestamp
        case committeeId = "committee_id"
        case individualId = "individual_id"
        case fecFinancialContributionsSummaryText = "fec_financial_contributions_summary_text"
        case upvoteCount = "upvote_count"
        case downvoteCount = "downvote_count"
        case timeRangeOfData = "time_range_of_data"
        case cycleEndYear = "cycle_end_year"
        case committeeName = "committee_name"
        case queryType = "query_type"
        case debug
        case percentContributions = "percent_contributions"
        case contributionTotals = "contribution_totals"
        case leadershipContributionsToCommittee = "leadership_contributors_to_committee"
            
    }
}

struct FinancialDebugInfo: Codable {
    let modelUsed: String
    let automatedEntry: Bool
    let dateGenerated: String
    let truncatedData: Bool
    let percentOfDataWithinTimeRange: Int
    let persistedResponse: Bool
    let newlyGenerated: Bool
    
    enum CodingKeys: String, CodingKey {
        case modelUsed = "model_used"
        case automatedEntry = "automated_entry"
        case dateGenerated = "date_generated"
        case truncatedData = "truncated_data"
        case percentOfDataWithinTimeRange = "precent_of_data_within_time_range"
        case persistedResponse = "persisted_response"
        case newlyGenerated = "newly_generated"
    }
}

struct PercentContributions: Codable {
    let totalToDemocrats: Int
    let totalToRepublicans: Int
    let percentToDemocrats: Float
    let percentToRepublicans: Float
    let totalContributions: Int
    
    enum CodingKeys: String, CodingKey {
        case totalToDemocrats = "total_to_democrats"
        case totalToRepublicans = "total_to_republicans"
        case percentToDemocrats = "percent_to_democrats"
        case percentToRepublicans = "percent_to_republicans"
        case totalContributions = "total_contributions"
    }
}

struct ContributionTotal: Codable {
    let recipientID: String?
    let recipientName: String?
    let numberOfContributions: Int?
    let totalContributionAmount: Int?
    
    enum CodingKeys: String, CodingKey {
        case recipientID = "recipient_id"
        case recipientName = "recipient_name"
        case numberOfContributions = "number_of_contributions"
        case totalContributionAmount = "total_contribution_amount"
    }
}

struct LeadershipContribution: Codable {
    let occupation: String
    let name: String
    let employer: String
    let transactionAmount: String
    
    enum CodingKeys: String, CodingKey {
        case occupation
        case name
        case employer
        case transactionAmount = "transaction_amount"
    }
}
