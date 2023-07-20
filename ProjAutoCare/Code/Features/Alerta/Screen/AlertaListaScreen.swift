//
//  AlertaListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI

struct AlertaListaScreen: View
{
    @State var favoriteColor: Int = 0
    var body: some View
    {
        VStack
        {
            Picker("What is your favorite color?", selection: $favoriteColor) {
                Text("Red").tag(0)
                Text("Green").tag(1)
            }
            .pickerStyle(.segmented)
            Spacer()
            
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }.navigationTitle("Alertas")
            .background(Color("backGroundColor"))
    }
}
