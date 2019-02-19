//
//  Topic.swift
//  SimpleRss
//
//  Created by Voldem on 2/18/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import CoreData

public class Topic: NSManagedObject {
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var picUrl: String
    @NSManaged public var feedUrl: String
}
