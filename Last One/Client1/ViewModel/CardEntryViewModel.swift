//
//  CardEntryViewModel.swift
//  Client1
//
//  Created by ii on 18.06.23.
//

import Foundation

class CardEntryViewModel: ObservableObject{
    @Published var totalPrice: Double = 0
    
    func getTotalPrice(products: [DatabaseProduct])  -> Double {
        var sum: Double = 0
        products.forEach { product in
            sum += product.price * Double(product.amount)
        }
        return sum
    }
    
    func postOrder(products: [DatabaseProduct]) async -> String {
        var orders: Entries = Entries(entries: [])
        
        products.forEach{ product in
           //let order = Order(amount: 1, productID: product.productId)
            orders.entries.append(Order(amount: product.amount, productID: product.productId))
        }
        
        let url = URL(
        string: "http://127.0.0.1:8080/api/orders")!
        var request = URLRequest(url: url)
        let httpBody = try! JSONEncoder().encode(orders)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json",
        forHTTPHeaderField: "Content-Type")
        let (data, _) = try! await URLSession.shared.data(for: request)
        print("Added Orders to Server")
        let responseEntries = try! JSONDecoder().decode(
            ResponseEntries.self,
            from: data
        )
        return responseEntries.id
        /*
         if let s = String(data: data, encoding: String.Encoding.utf8)
                {
                    print(s)
                }
        */
    }
}
