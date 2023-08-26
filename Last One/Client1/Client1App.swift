//
//  Client1App.swift
//  Client1
//
//  Created by ii on 06.06.23.
//

import SwiftUI

@main
struct Client1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(DatabaseService(previewContent: false))
        }
    }
}
