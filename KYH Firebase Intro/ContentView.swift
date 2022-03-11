//
//  ContentView.swift
//  KYH Firebase Intro
//
//  Created by David Svensson on 2022-03-11.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ContentView: View {
    @StateObject var viewModel = ItemsViewModel()
    var auth = Auth.auth()
    
    var body: some View {
        VStack {
            ItemListView(viewModel: viewModel)
            AddItemView(viewModel: viewModel)
        }.onAppear() {
            auth.signInAnonymously { authResult, error in
                guard let user = authResult?.user else { return }
                
                viewModel.listenToFirestore()
            }
            
        }
    }
}


struct ItemListView : View {
    @ObservedObject var viewModel : ItemsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Button {
                        viewModel.toggle(item: item)
                    } label: {
                        Image(systemName: item.done ? "checkmark.square" : "square")
                    }
                }
            }.onDelete { indexSet in
                viewModel.deleteItem(at: indexSet)
            }
        }
    }
}

struct AddItemView : View {
    var viewModel : ItemsViewModel
    @State var newItemName = ""
    
    var body: some View {
        HStack {
            TextField("Item name", text: $newItemName ).padding()
            Button(action: {
                if newItemName != "" {
                    viewModel.createItem(name: newItemName)
                    newItemName = ""
                }
            }, label: {
                Text("Add")
            }).padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
