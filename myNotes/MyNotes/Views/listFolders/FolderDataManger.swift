

//import Foundation
//import CoreData
//
//class FolderDataManager{
//    
//    static var shared = DataManager()
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//         
//            let container = NSPersistentContainer(name: "MyNotes")
//            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//                if let error = error as NSError? {
//              
//                    fatalError("Unresolved error \(error), \(error.userInfo)")
//                }
//            })
//            return container
//        }()
//    
//        func saveContext () {
//            let context = persistentContainer.viewContext
//            if context.hasChanges {
//                do {
//                    try context.save()
//                } catch {
//                    let nserror = error as NSError
//                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//                }
//            }
//        }
//        
//    }
//
//
//extension FolderDataManager{
//    
//    // create
//    func createFolder() -> Folder{
//        let context = persistentContainer.viewContext
//        let folder = Folder(context: context)
//        folder.id = UUID()
//        folder.name = ""
//     
//        saveContext()
//        return folder
//    }
//        
//    // delete
//    func deleteFolder(folder: Folder){
//        persistentContainer.viewContext.delete(folder)
//        saveContext()
//    }
//    // fetch
//    
//    func fetchFolders() -> [Folder]{
//        let request = Folder.fetchRequest()
//        return (try? persistentContainer.viewContext.fetch(request)) ?? []
//    }
//    
//}
