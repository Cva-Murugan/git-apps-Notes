

import UIKit




class FolderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
// passing

//    var foldersArr : [Folder]?
//    var notesArr: [Note]?
//    lazy var life:[Note] = {
//        return self.noteObj.allNotes
//    }()
    
//    var noteObj = ListNotesViewController()
//    var notesInFolder :[[Note]]?
    
    let context = DataManager.shared.persistentContainer.viewContext
    var folder: Folder?
    var allFolder: [Folder] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        notesInFolder = noteObj.collectionOfNote

        tableView.delegate = self
        tableView.dataSource = self
        
        self.fetchData()
    }
    
    
    
    
//    func hit(){
//
//        var fol = Folder(context: context)
//        var note = Note(context: context)
//        foldersArr?.append(fol)
//        notesArr?.append(note)
//
//        var folderNotes = noteObj.allNotes[0]
//
//    }
    
    
    func fetchData(){
        let request = Folder.fetchRequest()
        do{
            try self.allFolder = context.fetch(request)
        }catch{
            print("Error in Folder fetching")
        }
        tableView.reloadData()
    }
    
    @IBAction func addFolder(_ sender: Any) {
        let alert = UIAlertController(title: "Create Folder", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let create = UIAlertAction(title: "Create", style: .default){ (action) in
            let textField = alert.textFields![0]
            
            if self.validate(textField){
                let folder = Folder(context:self.context)
                
                folder.name = textField.text
                folder.id = UUID()
                
                do{
                    try self.context.save()
                    self.fetchData()
                }catch{
                    print("error in adding folder")
                }
            }else{
                self.dismiss(animated: true)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive){_ in
            self.dismiss(animated: true)
        }
        
        alert.addAction(create)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

extension FolderViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as! FolderTableViewCell)
            
        cell.folder.text = allFolder[indexPath.row].name
        
//        let allNotes = DataManager.shared.fetchNotes(filter: allFolder[indexPath.row].id)
//
//        cell.notesCount.text = allNotes.count.description
        
//        cell.notesCount.text = String(notesInFolder![indexPath.row].count) //?? ""
        
        cell.notesCount.text = ""
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "notesVc") as! ListNotesViewController
        
        // todo   pass arrays as value to next viewcontroller
//        vc.filteredNotes = notesInFolder![indexPath.row]
        
        vc.index = indexPath.row
        vc.folder = allFolder[indexPath.row]
        
        dump(allFolder[0])
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
      let alert = UIAlertController(title: "Edit", message: "change name", preferredStyle: .alert)
      alert.addTextField()
      let edited = alert.textFields![0]
      
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            let editbtn = UIAlertAction(title: "Change", style: .default){ _ in
              
                if self.validate(edited){
                    let folder = self.allFolder[indexPath.row]
                    folder.name = edited.text
                    do{
                        try self.context.save()
                        self.fetchData()
                    }catch{
                        print("error in Edit folder")
                    }
                }else{
                    self.dismiss(animated: true)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive){_ in
                self.dismiss(animated: true)
            }
    
            alert.addAction(editbtn)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ (action, view,
            completionHandler) in

            let folder = self.allFolder[indexPath.row]
            
            self.context.delete(folder)
            
            do{
                try self.context.save()
            }catch {
            }
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [editAction , deleteAction])
    }
    
    
    func validate(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            
            return false
        }
        return true
    }
    
}



