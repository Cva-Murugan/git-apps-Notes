
import Foundation
import CoreData

class DataManager{
    
    static var shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
         
            let container = NSPersistentContainer(name: "MyNotes")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
              
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
          
//    let viewcontext = persistentContainer.viewContext
    
        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            }
        }
        
    }


extension DataManager{
    
    // create
    func createNote(folderId:UUID) -> Note{
        let context = persistentContainer.viewContext
        let note = Note(context: context)
        note.id = UUID()
        note.lastUpdate = Date()
        note.folderid  = folderId
        note.text = ""
        
        saveContext()
        
        return note
    }
    
    // delete
    func deleteNote(note: Note){
        persistentContainer.viewContext.delete(note)
        saveContext()
    }
    // fetch
    
    func fetchNotes(filter: UUID? = nil ) -> [Note]{
        let request = Note.fetchRequest()
        let sort = NSSortDescriptor(keyPath: \Note.lastUpdate, ascending: false)
        request.sortDescriptors = [sort]
        
        if let filter = filter{
            let predicte = NSPredicate(format: "folderid == '\(filter)'")
            request.predicate = predicte
        }
        
        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    // create folder
    func createFolder() -> Folder{
        let context = persistentContainer.viewContext
        let folder = Folder(context: context)
        folder.id = UUID()
        folder.name = ""
     
        saveContext()
        return folder
    }
        
    // delete folder
    func deleteFolder(folder: Folder){
        persistentContainer.viewContext.delete(folder)
        saveContext()
    }
    
    // fetch folder
    func fetchFolders() -> [Folder]{
        let request = Folder.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }
    
}


