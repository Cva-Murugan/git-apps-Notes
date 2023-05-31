//
//  FolderTableViewCell.swift
//  MyNotes
//
//  Created by Novastrid on 30/05/23.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

    @IBOutlet weak var folder: UILabel!
    
    @IBOutlet weak var notesCount: UILabel!
    
    func setup(folderCD: Folder){
        folder.text = folderCD.name
    }

}
