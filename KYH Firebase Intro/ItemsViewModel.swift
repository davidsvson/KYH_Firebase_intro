//
//  ItemsViewModel.swift
//  KYH Firebase Intro
//
//  Created by David Svensson on 2022-03-11.
//

import Foundation
import Firebase

class ItemsViewModel : ObservableObject {
    @Published var items = [Item]()
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
   
    func listenToFirestore() {
        guard let uid = auth.currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error getting docuemnt \(err)")
            } else {
                self.items.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Item.self)
                    }
                    
                    switch result {
                    case .success(let item) :
                        self.items.append(item)
                    
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
    
    func createItem(name: String) {
        guard let uid = auth.currentUser?.uid else { return }
        
        let newItem = Item(name: name)
        
        do {
            _ = try db.collection("users").document(uid).collection("items").addDocument(from: newItem)
        } catch {
            print("error saving to DB")
        }
    }
 
    func toggle(item: Item) {
        guard let uid = auth.currentUser?.uid else { return }

        if let id = item.id {
            db.collection("users").document(uid).collection("items").document(id)
                .updateData(["done": !item.done ])
        }
    }
    
    func deleteItem(at indexSet: IndexSet) {
        guard let uid = auth.currentUser?.uid else { return }
        
        for index in indexSet {
            let item = items[index]
            if let id = item.id {
                db.collection("users").document(uid).collection("items").document(id).delete()
            }
        }
    }
}
