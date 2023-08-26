//
//  Produktdetailseite.swift
//  Client1
//
//  Created by ii on 06.06.23.
//

import SwiftUI
import GRDB

struct ProductDetail: View {
    var title: String = "Added"
    @State var show: Bool = false

    @EnvironmentObject private var databaseService: DatabaseService

    @StateObject var vandorViewModel: VandorViewModel = VandorViewModel()
    @StateObject var categoryViewModel: CategoriesViewModel = CategoriesViewModel()
    let image : UIImage?
    let productName: String
    let productVendorId: String
    let productId: String
    let productPrice: Double
    let productDescription: String
    let productCategoryId: String

    

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    NavigationLink(destination:VandorDetailView(vandorName: vandorViewModel.vandorModel.name ??
                        "Default Vendor"))
                    {
                        Text(vandorViewModel.vandorModel.name ?? "Default Vendor")                                        .fontWeight(.semibold)
                    }
                    Spacer()
                    NavigationLink(destination:CategoryDetailView(categoryName: categoryViewModel.categoryModel.name ??
                        "Default Category"))
                    {
                        Text(categoryViewModel.categoryModel.name ??
                             "Default Category")                  .fontWeight(.semibold)
                    }
                    
                }
                
                if  (image !=  UIImage(systemName: "car"))
                {
                    
                    Image(uiImage: image!)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .cornerRadius(5)
                    
                }
                else{
                    Spacer().frame(height: 250)
                }
                Text("Description").fontWeight(.semibold).font(.system(size: 24))
                Text(productDescription)
                
                Button {
                    addToShoppingCard(
                        vendorId: productVendorId,
                        productId: productId,
                        categoryId: productCategoryId,
                        name: productName,
                        description: productDescription,
                        price: productPrice
                    )
                } label: {
                    Text("Add to card")
                }.buttonStyle(AddButton())
            }
        }
        .padding()
        .snackbar(isShowing: $show, title: title, text: "\(productName) was added", style: .custom(.blue), extraBottomPadding: 60)
        .navigationBarTitle(productName)
        .task {
            vandorViewModel.vandorModel = await vandorViewModel.getVandor(id: productVendorId)
            categoryViewModel.categoryModel =  await categoryViewModel.getCategory(id: productCategoryId)
        }
    }
    
    func addToShoppingCard(
        vendorId: String,
        productId: String,
        categoryId: String,
        name: String,
        description: String,
        price: Double
    ){
        
        var product : DatabaseProduct?
        
        try! databaseService.queue.write { db in
             product = try DatabaseProduct.filter(Column("productId") == productId).fetchOne(db)
            if(product != nil){
                product!.amount = product!.amount + 1;
                try! product!.save(db)
                show=true
                return
            }
        }
        
        if(product == nil){
                let databaseProduct :DatabaseProduct = DatabaseProduct(
                    id : nil,
                    vendorId : vendorId,
                    productId : productId,
                    categoryId : categoryId,
                    name : name,
                    description : description,
                    price : price,
                    amount: 1
                )
                        
                try! databaseService.queue.write { db in
                    try! databaseProduct.save(db)
                }
            show=true

        }

    }
    
    
}
