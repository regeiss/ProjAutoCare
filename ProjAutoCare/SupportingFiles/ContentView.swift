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
            // UIView.appearance().backgroundColor = UIColor.red
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.orange
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            
        }
    // @Binding var showMenu: Bool
    @State private var isShowingSheet = false
    @State var showSidebar: Bool = false
    
    var body: some View
    {
        SideBarStack(sidebarWidth: 125, showSidebar: $showSidebar)
        {
                   // Sidebar content here
            Text("Destination")
        } content: {
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
                        { Button { showSidebar.toggle()}
                            label: { Image(systemName: "line.3.horizontal")}}
                        
                        ToolbarItem(placement: .navigationBarTrailing)
                        { Button { isShowingSheet.toggle()}
                            label: { Image(systemName: "car.2")}}
                    }
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

struct ItemsSideBar
{
        var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Login")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            .onTapGesture
            {
                showMenu = false
                // router.toLogin()
            }
            HStack
            {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Perfil")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .onTapGesture
            {
                showMenu = false
                // router.toListaPerfil()
            }
            HStack
            {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Mensagens")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .onTapGesture
            {
                showMenu = false
                // router.toMenu()
            }
            HStack
            {
                Image(systemName: "gearshape")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Configurações")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .onTapGesture
            {
                showMenu = false
                //pilot.push(.settings)
            }
            Spacer()
            HStack
            {
                let appBuild = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                Text("WerkstadtG v.")
                Text(appBuild ?? "1.0")
                    .foregroundColor(.gray)
            }.padding([.leading, .bottom])
        }.background(Color(red: 32/255, green: 32/255, blue: 32/255))
}

#Preview
{
    ContentView()
}
