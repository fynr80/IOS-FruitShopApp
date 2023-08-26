//
//  PayEntryViewModel.swift
//  Client1
//
//  Created by ii on 30.06.23.
//

import Foundation
class PayEntryViewModel: ObservableObject {
    
    func payOrder(entryID: String) async{
        let paypalTransaction: PaypalTransaction = PaypalTransaction(
            paypalTransactionId: UUID().uuidString)
        let httpBody = try! JSONEncoder().encode(paypalTransaction)
        let url = URL(string: "http://127.0.0.1:8080/api/orders/\(entryID)/pay")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, _) = try! await URLSession.shared.data(for: request)
        
    }
}
