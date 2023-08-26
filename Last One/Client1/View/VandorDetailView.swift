//
//  VandorDetailView.swift
//  Client1
//
//  Created by ii on 11.06.23.
//

import SwiftUI

struct VandorDetailView: View {
    let vandorName: String
    let vandorDetails: String = "Here are the Details for the Vendor"
    
    var body: some View {
        HStack{
            Text(vandorDetails)
        }
        .navigationBarTitle(vandorName)
    }
}

