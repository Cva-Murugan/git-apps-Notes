

import UIKit

protocol ListNotesDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

//protocol noteDataDelegate{
//    var test: Int {get}
//
//}

class ListNotesViewController: UIViewController {
    
    
//    var delegate: noteDataDelegate?
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var notesCountLbl: UILabel!
    
    private let searchController = UISearchController()
    
    var index:Int = 0
    
    var folder: Folder?
    var filteredNotes: [Note] = []
//    var collectionOfNote:[[Note]] = []
    
     var allNotes: [Note] = [] {
        didSet {
            notesCountLbl.text = "\(allNotes.count) \(allNotes.count == 1 ? "Note" : "Notes")"
            filteredNotes = allNotes
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(index)
        
        dump(
            folder
        )
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        
    
        configureSearchBar()
        fetchNotesFromStorage()
    }
    
//    func appendNotesInCollection() {
//        collectionOfNote.append(filteredNotes)
//    }
//
    private func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    @IBAction func createNewNoteClicked(_ sender: UIButton) {
        goToEditNote(createNote())
    }
    
    private func goToEditNote(_ note: Note) {
        let controller = storyboard?.instantiateViewController(identifier: EditNoteViewController.identifier) as! EditNoteViewController
        controller.note = note
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
   
    private func createNote() -> Note {
        
        let note = DataManager.shared.createNote(folderId: folder!.id!)
        
        // Update table
        allNotes.insert(note, at: 0)
        print(allNotes.count)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        // relationship
//        folderVc?.allFolder[index].addToNotes(note)
//        note.folders?.addToNotes(note)
//        note.foldersRel = folderVc?.allFolder[index]
        
        return note
    }
    
    private func fetchNotesFromStorage() {
      
        allNotes = DataManager.shared.fetchNotes(filter: folder!.id!)
//        tableView.reloadData()
        print("Fetching all notes")
    }
    
    private func deleteNoteFromStorage(_ note: Note) {
        
        let context = DataManager.shared.persistentContainer.viewContext
        
        deleteNote(with: note.id!)
        
        context.delete(note)
        do{
            try context.save()
            fetchNotesFromStorage()
        }catch{
            print("error in delete notes")
        }
        print("Deleting note")
        
        // Update the list
    }
    
    private func searchNotesFromStorage(_ text: String) {
        
//        allNotes = DataManager.shared.fetchNotes(filter: text)
//        tableView.reloadData()
        print("Searching notes")
    }
}


extension ListNotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListNoteTableViewCell.identifier) as! ListNoteTableViewCell
        print(filteredNotes.count)
        
        cell.setup(note: filteredNotes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let id = filteredNotes[indexPath.row].id

        goToEditNote(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorage(filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//Search Controller Configuration
extension ListNotesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search("")
//      fetchNotesFromStorage()
//      tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchNotesFromStorage(query)
    }
    
    func search(_ query: String) {
        
        if query.count >= 1 {
            filteredNotes = allNotes.filter { $0.text!.lowercased().contains(query.lowercased()) }
        } else{
            filteredNotes = allNotes
        }
        tableView.reloadData()
    }
    
   
}

// MARK:- ListNotes Delegate
extension ListNotesViewController: ListNotesDelegate {
    
    func refreshNotes() {
        allNotes = allNotes.sorted(by:{ $0.lastUpdate! > $1.lastUpdate!})
        tableView.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // just so that it doesn't come back when we search from the array
        allNotes.remove(at: indexForNote(id: id, in: allNotes).row)
    }
    
    
}
