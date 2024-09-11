

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Event: Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var author: String
    var date: Date
}

final class StoreManager {
    
    
    let db = Firestore.firestore().collection("events")
    
    var listener: ListenerRegistration?
    
    func getEvents(completion: @escaping (([Event]?) -> Void)) {
//        db.getDocuments { querySnapshot, error in
//            let result = querySnapshot?.documents.compactMap { document in
//                return try? document.data(as: Event.self)
//            }
//            completion(result)
//        }
        listener?.remove()
        
        listener = db.addSnapshotListener({ querySnapshot, error in
            let result = querySnapshot?.documents.compactMap { document in
                return try? document.data(as: Event.self)
            }
            completion(result)
        })
    }
    
    func addEvent(event: Event, completion: @escaping ((_ errorString: Error?) -> Void)) {
        _ = try? db.addDocument(from: event) { error in
            completion(error)
        }
    }
    
    func deleteEvent(event: Event, completion: @escaping ((_ errorString: Error?) -> Void)) {
        db.document(event.id!).delete { error in
            completion(error)
        }
    }
    
    func updateEvent(event: Event, completion: @escaping ((_ errorString: Error?) -> Void)) {
        try? db.document(event.id!).setData(from: event) { error in
            completion(error)
        }
    }
    
}
