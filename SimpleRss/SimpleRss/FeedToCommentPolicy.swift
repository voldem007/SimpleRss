import CoreData

class FeedToCommentPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
 
        let dInstance = NSEntityDescription.insertNewObject(forEntityName: mapping.destinationEntityName!, into: manager.destinationContext)
        
        let comment = sInstance.primitiveValue(forKey: "comment") as? String
        let rating = sInstance.primitiveValue(forKey: "rating") as? Double
        
        if rating != nil || comment != nil {
            dInstance.setValue(UUID().uuidString, forKey: "id")
            dInstance.setValue(comment, forKey: "comment")
            dInstance.setValue(rating, forKey: "rating")
            
            manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
        }
    }
}
