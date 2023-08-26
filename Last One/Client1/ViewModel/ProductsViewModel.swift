//
//  ProductsStore.swift
//  Client1
//
//  Created by II on 10.06.23.
//

import Foundation
import UIKit


class ProductsViewModel: ObservableObject {
    
    @Published var productsModel: [ProductPreviewDto] = []
    @Published var productImages: [String: UIImage] = [:]
    @Published var startingFruitCounter: Int = 5
    var totalFruitCounter: Int = 0
    
    func getProducts() async -> [ProductPreviewDto]{
        // Aufbauen der URL
        var components = URLComponents(
            string: "http://127.0.0.1:8080"
        )!
        components.path = "/api/products/"
        components.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per", value: String(startingFruitCounter))
        ]
        
        let url = components.url!
        // Durchführen des GET HTTP Requests
        let (data, _) = try! await URLSession.shared.data(from: url)
        let productPreviews = try! JSONDecoder().decode(
            ProductListDto.self,
            from: data
        )
        totalFruitCounter = productPreviews.page.total
        return productPreviews.products
    }
    
    
    func getImage (id:String) async -> UIImage {
        
        let filename = "\(id).png"
        // Ob Image schon im temporären Verzeichnis gespeichert ist ?
        if let tempImage = UIImage(contentsOfFile: getFileURL(filename: filename)!.path) {
            print("from temp")
            return tempImage
        }

        
        var components = URLComponents(
            string: "http://127.0.0.1:8080"
        )!
        components.path = "/api/products/\(id)/photo"
        
        do {
               let url = components.url!
               let (data, _) = try await URLSession.shared.data(from: url)
               if let uiImage = UIImage(data: data) {
                   if let data = uiImage.pngData() {
                       if let fileURL = getFileURL(filename: filename) {
                                       try? data.write(to: fileURL)
                                   }
                      }
                   print("from API")
                   return uiImage
               }
           } catch {
               //print("Error fetching image: \(error)")
           }
        print("Empty Image")
        return UIImage(systemName: "car")!

    }
    
    func getFileURL(filename: String) -> URL? {
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)

        return tempDirectoryURL.appendingPathComponent(filename)
    }
    
}

















/*let response: (Data, URLResponse) = try! await URLSession.shared.data(from: url)
 // Response verarbeiten
 let statusCode = (response.1 as! HTTPURLResponse).statusCode
 print(statusCode)
 //Wir nehmen response.0(Data) als Objekt entgegen. In diesem Objekt suchen wir nach "name" und übergeben dies.
 
 let r = String(data: response.0, encoding: .utf8)!
 //print(r)
 let responseText = (response.0)*/


/*if let responseText = try! JSONSerialization.jsonObject(with: responseText, options: []) as? [String: Any] {
 let fruitName = responseText["name"] as? String
 let fruitPrice = responseText["price"] as? Double
 //return "\(fruitName!) \(String(fruitPrice!)) $"
 return "hallo"
 }
 return "Object not Found"*/
