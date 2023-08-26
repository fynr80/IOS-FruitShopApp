//
//  VandorsViewModel.swift
//  Client1
//
//  Created by ii on 11.06.23.
//

import Foundation

class VandorViewModel: ObservableObject {
    @Published var vandorModel: VandorPreviewDto = VandorPreviewDto()
    @Published var vandorsModel: [VandorPreviewDto] = []
    @Published var startingCounter: Int = 5
    @Published var totalCounter: Int = 0

    func getVandors() async -> (totalCount: Int, vList: [VandorPreviewDto]){
        // Aufbauen der URL
        var components = URLComponents(
            string: "http://127.0.0.1:8080"
        )!
        components.path = "/api/vendors/"
        components.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per", value: String(startingCounter))
        ]
        
        let url = components.url!
        // Durchführen des GET HTTP Requests
        let (data, _) = try! await URLSession.shared.data(from: url)
        let vandorPreviews = try! JSONDecoder().decode(
            VandorListDto.self,
            from: data
        )
        return (vandorPreviews.page.total, vandorPreviews.vendors)
    }
    
    
    
    
    func getVandor(id: String) async -> VandorPreviewDto{
        // Aufbauen der URL
        var components = URLComponents(
            string: "http://127.0.0.1:8080"
        )!
        components.path = "/api/vendors/\(id)"
        
        let url = components.url!
        // Durchführen des GET HTTP Requests
        let (data, _) = try! await URLSession.shared.data(from: url)
        let vandorPreviews = try! JSONDecoder().decode(
            VandorPreviewDto.self,
            from: data
        )
        return vandorPreviews
    }
}
