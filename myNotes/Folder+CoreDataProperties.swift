//
//  Folder+CoreDataProperties.swift
//  MyNotes
//
//  Created by Novastrid on 31/05/23.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notesRel: NSSet?

}

// MARK: Generated accessors for notesRel
extension Folder {

    @objc(addNotesRelObject:)
    @NSManaged public func addToNotesRel(_ value: Note)

    @objc(removeNotesRelObject:)
    @NSManaged public func removeFromNotesRel(_ value: Note)

    @objc(addNotesRel:)
    @NSManaged public func addToNotesRel(_ values: NSSet)

    @objc(removeNotesRel:)
    @NSManaged public func removeFromNotesRel(_ values: NSSet)

}

extension Folder : Identifiable {

}
