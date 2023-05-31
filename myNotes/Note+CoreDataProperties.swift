//
//  Note+CoreDataProperties.swift
//  MyNotes
//
//  Created by Novastrid on 31/05/23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var folderid: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var text: String?
    @NSManaged public var foldersRel: Folder?

}

extension Note : Identifiable {

}
