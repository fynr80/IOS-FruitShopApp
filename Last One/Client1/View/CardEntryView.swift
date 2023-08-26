//
//  CardEntryView.swift
//  Client1
//
//  Created by ii on 13.06.23.
//

import SwiftUI
import GRDB
import Combine
import SwiftUISnackbar


struct CardEntryView: View {
    @ObservedObject private var viewModell=ProductsViewModel()
    @State var stepperValue: Int = 0
    
    
    @StateObject private var viewModel = CardEntryViewModel()
    @EnvironmentObject private var databaseService: DatabaseService
    @State private var productsSubscription: Cancellable? = nil
    @State private var DatabaseProducts: [DatabaseProduct] = []
    @State private var entryID: String = ""
    @State private var showAddSheet = false
    
    
    
    var body: some View {
        
        NavigationView{
            List{
                ForEach(DatabaseProducts, id: \.self) { product in
                    NavigationLink(destination: ProductDetail(image:viewModell.productImages[product.productId], productName: product.name, productVendorId: product.vendorId, productId: product.productId, productPrice: product.price, productDescription: product.description, productCategoryId: product.categoryId)
                    )
                    {
                        HStack{
                            
                            if let image = viewModell.productImages[product.productId] {
                                if(image != UIImage(systemName: "car")) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(5)
                                }
                                else {
                                    Spacer(minLength: 75)
                                }
   
                            }
                            VStack(alignment: .leading, spacing: 25){
                                Text(product.name)
                                    .fontWeight(.semibold)
                                Text("\(String(format: "%.2f",product.price * Double(product.amount) )) $")
                            }
                            Spacer()
                            HStack{
                                Button {
                                    handleAmount(increase: true, id: product.id!)
                                } label: {
                                    Image(systemName: "plus.circle")
                                }.buttonStyle(PlainButtonStyle())
                                    .padding(10)
                                
                                Text("\(String(product.amount))")
                                
                                Button {
                                    if(product.amount != 1){
                                        handleAmount(increase: false, id: product.id!)
                                        print("min button was tapped")
                                    }
                                    
                                    
                                } label: {
                                    Image(systemName: "minus.circle")
                                }.buttonStyle(PlainButtonStyle())
                                    .padding(10)
                            }
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .task {
                        if(viewModell.productImages[product.productId] == nil) {
                            let image = await viewModell.getImage(id: product.productId)
                            viewModell.productImages[product.productId] = image
                            return
                        }
                    }
                }
                .onDelete(perform: deleteItem)
                
                HStack{
                    Text("Sub total")
                    Spacer()
                    Text("\(String(format: "%.2f",viewModel.totalPrice)) $")                                        .fontWeight(.semibold)
                        .font(.system(size: 30))
                }
                if (viewModel.totalPrice > 0){
                    Button {
                        Task{
                            entryID = await viewModel.postOrder(products: DatabaseProducts)
                        }
                        showAddSheet = true
                    }label: {
                        Text("Kostenpflichtig Bestellen")
                        
                    }.buttonStyle(AddButton())
                }
                
                
                
            }.navigationTitle("Card Entry")
                .onAppear {
                    self.productsSubscription = ValueObservation
                        .tracking { (db: Database) -> [DatabaseProduct] in
                            try DatabaseProduct.fetchAll(db)
                        }
                        .publisher(in: databaseService.queue)
                        .assertNoFailure()
                        .sink { (DatabaseProducts: [DatabaseProduct]) -> Void in
                            withAnimation {
                                self.DatabaseProducts = DatabaseProducts
                                viewModel.totalPrice = viewModel.getTotalPrice(products: DatabaseProducts)
                            }
                        }
                }
                .onDisappear {
                    // Stop observation
                    productsSubscription?.cancel()
                    
                }
                .sheet(isPresented: $showAddSheet) {
                    PayEntryView(totalPrice: viewModel.totalPrice, entryID: entryID)
                }
        }
    }
    func deleteItem(at offsets: IndexSet){
        try! databaseService.queue.write { db in
            offsets.forEach { index in
                let contactToDelete = DatabaseProducts[index]
                try! contactToDelete.delete(db)
            }
        }
        print("Deleted")
    }
    
    
    func handleAmount(increase: Bool, id: Int){
        if(increase){
            try! databaseService.queue.write { db in
                if var product = try DatabaseProduct.fetchOne(db, id: id) {
                    product.amount = product.amount + 1
                    try product.update(db)
                }
            }
        }
        else{
            try! databaseService.queue.write { db in
                if var product = try DatabaseProduct.fetchOne(db, id: id) {
                    product.amount = product.amount - 1
                    try product.update(db)
                }
            }
        }
    }
    
    
    
}


