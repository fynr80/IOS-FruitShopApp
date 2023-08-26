//
//  Produktliste.swift
//  Client1
//
//  Created by ii on 06.06.23.
//

import SwiftUI
import GRDB

struct ProductList: View {
    @ObservedObject private var viewModel=ProductsViewModel()
    
    var body: some View {
        NavigationView{
            List {
                Section("Fruits"){
                    ForEach(viewModel.productsModel, id: \.self) { product in
    
                        NavigationLink(destination: ProductDetail( image:viewModel.productImages[product.id] ?? nil, productName: product.name, productVendorId: product.vendorId , productId: product.id, productPrice: product.price, productDescription: product.description, productCategoryId: product.categoryId) )
                        {
                            if(viewModel.productsModel.last==product){
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("\(product.name)")
                                        .fontWeight(.semibold)
                                    Text("\(String(product.price))$")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                }.onAppear{
                                    if(viewModel.startingFruitCounter < viewModel.totalFruitCounter){
                                        Task {
                                            //try await Task.sleep(nanoseconds: 1_500_000_000)
                                            
                                            viewModel.startingFruitCounter+=5
                                            viewModel.productsModel = await viewModel.getProducts()
                                        }
                                    }
                                }
                            }
                            else{
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("\(product.name)")
                                        .fontWeight(.semibold)
                                    Text("\(String(product.price))$")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                }
                                
                            }
                            HStack{
                                Spacer()
                                if let image = viewModel.productImages[product.id] {
                                    if(image != UIImage(systemName: "car")) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                        }
                        .task {
                            if (viewModel.productImages[product.id] == nil) {
                                let image = await viewModel.getImage(id: product.id)
                                viewModel.productImages[product.id] = image
                                return
                            }
                        }
                    }
                }
            }.navigationTitle("My Products")
        }
        .task {
            viewModel.productsModel = await viewModel.getProducts()
        }
    }
    /*func getDocumentsDirectory() -> URL {
     let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     return paths[0]
     }*/
    
}


