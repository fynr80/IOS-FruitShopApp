//
//  CategoryDetailView.swift
//  Client1
//
//  Created by ii on 11.06.23.
//

import SwiftUI

struct CategoryDetailView: View {
    let categoryName: String
    let categoryDetails: String = "Here are the Details for the Category"
    
    var body: some View {
        HStack{
            Text(categoryDetails)
        }
        .navigationBarTitle(categoryName)
    }
}
