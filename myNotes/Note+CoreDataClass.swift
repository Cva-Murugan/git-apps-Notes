//
//  Note+CoreDataClass.swift
//  MyNotes
//
//  Created by Novastrid on 31/05/23.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    
    var title: String {
        return text!.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? "" // returns the first line of the text
        }
        
    var desc: String {
            var lines = text!.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
            lines.removeFirst()
            return "\(lastUpdate!.format()) \(lines.first ?? "")" // return second line
        }
    
}
