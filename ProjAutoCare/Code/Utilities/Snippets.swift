//
//  Snippets.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/06/23.
//

import Foundation
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
public protocol Coordinator: AnyObject {
    func navigate(to route: Route)
}

public protocol Route { }

public protocol NavigationContext {
    func setInitialView<T: View>(view: T)
    func push<T: View>(view: T, animated: Bool)
    func pop(animated: Bool)
    func present<T: View>(view: T, animated: Bool)
    func dismiss(animated: Bool)
}

public class MyNavController: UINavigationController, NavigationContext {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setInitialView<T: View>(view: T) {
        let vc = UIHostingController(rootView: view)
        viewControllers = [vc]
    }
    
    public func push<T: View>(view: T, animated: Bool) {
        let vc = UIHostingController(rootView:: view)
        pushViewController(vc, animated: animated)
    }
    
    public func present<T: View>(view: T, animated: Bool) {
        let vc = UIHostingController(rootView: view)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .automatic 
        present(vc, animated: animated)
    }
}