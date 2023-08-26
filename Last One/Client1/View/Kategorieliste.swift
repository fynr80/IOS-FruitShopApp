//
//  Kategorieliste.swift
//  Client1
//
//  Created by ii on 06.06.23.
//

import SwiftUI

struct Kategorieliste: View {
    @StateObject private var viewModel = CategoriesViewModel()
    
    
    var body: some View {
        NavigationView{
            List{
                Section(""){
                    ForEach(viewModel.categoriesModel, id: \.self){ category in
                        NavigationLink(destination: CategoryDetailView(categoryName: category.name ?? "Not Found")
                        ){
                            HStack{
                                VStack{
                                    if(viewModel.categoriesModel.last == category){
                                        Text(category.name ?? "Not Found")
                                            .onAppear{
                                                if(viewModel.startingCounter < viewModel.totalCounter){
                                                    Task {
                                                        viewModel.startingCounter+=5
                                                        let categoryData = await viewModel.getCategories()
                                                        viewModel.categoriesModel = categoryData.cList
                                                    }
                                                }
                                            }
                                    }
                                    else{
                                        Text(category.name ?? "Not Found")
                                    }
                                }
                            }
                        }
                    }
                }
            }.navigationTitle("Categories")
        }
        .task {
            let categoryData = await viewModel.getCategories()
            viewModel.categoriesModel = categoryData.cList
            viewModel.totalCounter = categoryData.totalCount
        }
    }
}

