//
//  PayEntryView.swift
//  Client1
//
//  Created by ii on 30.06.23.
//

import SwiftUI

struct PayEntryView: View {
    @EnvironmentObject private var databaseService: DatabaseService
    @StateObject private var viewModel = PayEntryViewModel()
    @State private var showingAlert: Bool = false
    @Environment(\.dismiss) var dismiss: DismissAction
    let totalPrice: Double
    let entryID: String
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Jetzt aus den Bezahl Knopf drücken um ihre Bestellung zu bezahlen und abzuschließen")
                Text("Die Kosten betragen \(String(format: "%.2f", totalPrice)) $")
                Button {
                    Task{
                        await viewModel.payOrder(entryID:entryID)
                        showingAlert = true
                    }
                }label: {
                    Text("Bezahlen")
                }
                .buttonStyle(AddButton())
                .alert(isPresented: $showingAlert){
                    Alert(
                        title: Text("Bestellung Abgeschlossen"),
                        message: Text("Ihre Bestellung ist nun Abgeschlossen."),
                        dismissButton: .cancel(Text("Beenden")){
                            deletedb()
                            dismiss()
                        }
                    )
                }
            }
            .navigationTitle("Pay Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("Cancel"){
                    dismiss()
                }
            }
        }

    }
    func deletedb(){
        try! databaseService.queue.write { db in
            try! DatabaseProduct.deleteAll(db)
            return
        }
        
    }
    
}
