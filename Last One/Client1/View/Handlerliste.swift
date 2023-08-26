//
//  Handlerliste.swift
//  Client1
//
//  Created by ii on 06.06.23.
//

import SwiftUI

struct Handlerliste: View {
    @StateObject private var viewModel = VandorViewModel()

    
    var body: some View {
        NavigationView{
            List{
                Section(""){
                    ForEach(viewModel.vandorsModel, id: \.self){ vandor in
                        NavigationLink(destination: VandorDetailView(vandorName: vandor.name ?? "Not Found")
                        ){
                            HStack{
                                VStack{
                                    if(viewModel.vandorsModel.last == vandor){
                                        Text(vandor.name ?? "Not Found")
                                            .onAppear{
                                                if(viewModel.startingCounter < viewModel.totalCounter){
                                                    Task {
                                                        viewModel.startingCounter+=5
                                                        let vandorData = await viewModel.getVandors()
                                                        viewModel.vandorsModel = vandorData.vList
                                                    }
                                                }
                                            }
                                    }
                                    else{
                                        Text(vandor.name ?? "Not Found")
                                    }
                                }
                            }
                        }
                    }
                }
            }.navigationTitle("Vendors")

        }
        .task {
            let vandorData = await viewModel.getVandors()
            viewModel.vandorsModel = vandorData.vList
            viewModel.totalCounter = vandorData.totalCount
        }
    }
}
