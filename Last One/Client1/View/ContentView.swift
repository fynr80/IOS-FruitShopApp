//
//  ContentView.swift
//  Client1
//
//  Created by ii on 06.06.23.
//
import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView{
            ProductList()
                .tabItem {
                    Label("Products", systemImage: "apple.logo")
                }
            Kategorieliste()
                .tabItem {
                    Label("Categories", systemImage: "folder")
                }
            Handlerliste()
                .tabItem {
                    Label("Vendors", systemImage: "person")
                }
            CardEntryView()
                .tabItem {
                    Label("Shopping card", systemImage: "cart")
                }
        }
        
    }
}
