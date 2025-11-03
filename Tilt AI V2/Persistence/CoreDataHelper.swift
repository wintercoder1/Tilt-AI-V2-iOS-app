//
//  CoreDataHelper.swift
//  Tilt AI
//
//  Created by Steve on 11/2/25.
//
import CoreData

class CoreDataHelper {
    
    class func addPersistedQueryAnswer(context: NSManagedObjectContext, analysis: OrganizationAnalysis, organizationName: String?, overviewPageCompletion: @escaping ((Bool) -> Void) ) {
        
        context.perform { //[weak self] in
//            guard let self = self else {
//                print("lol self issue")
//                return
//            }
            
            let qa = QueryAnswerObject(context: context)
            qa.date_persisted = Date()
            qa.topic = organizationName ?? analysis.topic
            qa.lean = analysis.lean
            qa.rating = Int16(analysis.rating)
            qa.context = analysis.description
            qa.created_with_financial_contributions_info = analysis.hasFinancialContributions
            
            print("Will try do try save now...")
            do {
                try context.save()
                DispatchQueue.main.async {
//                    self.isSaved = true
//                    self.updateSaveButtonAppearance()
//                    print("Analysis saved successfully")
                    let isSaved = true
                    print("from addPersistedQueryAnswer -- we saved the query")
                    overviewPageCompletion(isSaved)
                }
            } catch {
                print("Query answer save error:", error)
            }
        }
    }
    
    class func removePersistedQueryAnswer(context: NSManagedObjectContext, organizationName: String, completion: ((Bool) -> Void)) {
        let request: NSFetchRequest<QueryAnswerObject> = QueryAnswerObject.fetchRequest()
        request.predicate = NSPredicate(format: "topic == %@", organizationName)
        
        do {
            let results = try context.fetch(request)
            for result in results {
                context.delete(result)
            }
            try context.save()
//            isSaved = false
//            print("Analysis removed from saved items")
            let isSaved = true
            completion(isSaved)
        } catch {
            print("Error removing saved analysis: \(error)")
        }
    }
    
}
