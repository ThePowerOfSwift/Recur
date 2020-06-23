//
//  Entity.swift
//  Recur
//
//  Created by John Ababseh on 6/28/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import CoreData

class Entity: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var timeCreated: Date?

    func parse(data dict: [String: Any]) {
        if let id = dict["id"] as? String {
            self.id = id
        }
        if let timeCreatedString = dict["time_created"] as? String {
            if let timeCreated = Date.iso8601.date(from: timeCreatedString) {
                self.timeCreated = timeCreated
            }
        }
    }
}
