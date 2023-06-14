//
//  ContentView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//

import SwiftUI
import SwiftData

struct ContentView: View
{
    init() {
            UIView.appearance().backgroundColor = UIColor.red
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.orange
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            
        }
    // @Binding var showMenu: Bool
    @State private var isShowingSheet = false
    
    var body: some View
    {
        ZStack
        {
            Color("backGroundMain").ignoresSafeArea()
            NavigationStack
            {
                NavigationLink("Tap me") {
                    Text("Destination")
                }
                .navigationTitle("Ajustes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading)
                    { Button { isShowingSheet.toggle()}
                        label: { Image(systemName: "line.3.horizontal")}}
                    
                    ToolbarItem(placement: .navigationBarTrailing)
                    { Button { isShowingSheet.toggle()}
                        label: { Image(systemName: "car.2")}}
                }
            }
        }
    }
    
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    //
    //    var body: some View {
    //        NavigationView {
    //            List {
    //                ForEach(items) { item in
    //                    NavigationLink {
    //                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
    //                    } label: {
    //                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
    //                    }
    //                }
    //                .onDelete(perform: deleteItems)
    //            }
    //            .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    EditButton()
    //                }
    //                ToolbarItem {
    //                    Button(action: addItem) {
    //                        Label("Add Item", systemImage: "plus")
    //                    }
    //                }
    //            }
    //            Text("Select an item")
    //        }
    //    }
    //
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(timestamp: Date())
    //            modelContext.insert(newItem)
    //        }
    //    }
    //
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            for index in offsets {
    //                modelContext.delete(items[index])
    //            }
    //        }
    //    }
}

#Preview
{
    ContentView()
}
