import CoreData

class FeedToCommentPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        let comment = sInstance.primitiveValue(forKey: "comment") as? String
        let rating = sInstance.primitiveValue(forKey: "rating") as? Double
        
        if rating != nil || comment != nil {
            let dInstance = NSEntityDescription.insertNewObject(forEntityName: mapping.destinationEntityName!, into: manager.destinationContext)
            
            dInstance.setValue(UUID().uuidString, forKey: "id")
            dInstance.setValue(comment, forKey: "comment")
            dInstance.setValue(rating, forKey: "rating")
            
            manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
        }
    }
}
