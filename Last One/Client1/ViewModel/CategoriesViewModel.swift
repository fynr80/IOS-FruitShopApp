//
//  CategoriesViewModel.swift
//  Client1
//
//  Created by ii on 11.06.23.
//

import Foundation

class CategoriesViewModel: ObservableObject {
    @Published var categoryModel: CategoryPreviewDto = CategoryPreviewDto()
    @Published var categoriesModel: [CategoryPreviewDto] = []
    @Published var startingCounter: Int = 5
    @Published var totalCounter: Int = 0
    
    func getCategories() async -> (totalCount: Int, cList: [CategoryPreviewDto]){
        // Aufbauen der URL
        var components = URLComponents(
            string: "http://127.0.0.1:8080"
        )!
        components.path = "/api/categories/"
        components.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per", value: String(startingCounter))
        ]
        
        let url = components.url!
        // Durchführen des GET HTTP Requests
        let (data, _) = try! await URLSession.shared.data(from: url)
        let categoryPreviews = try! JSONDecoder().decode(
            CategoryListDto.self,
            from: data
        )
        return (categoryPreviews.page.total, categoryPreviews.categories)
    }
    
    func getCategory(id: String) async -> CategoryPreviewDto{
        // Aufbauen der URL
        var components = URLComponents(
            string: "http://127.0.0.1:8080"
        )!
        components.path = "/api/categories/\(id)"
        
        let url = components.url!
        // Durchführen des GET HTTP Requests
        let (data, _) = try! await URLSession.shared.data(from: url)
        let categoryPreviews: CategoryPreviewDto = try! JSONDecoder().decode(
            CategoryPreviewDto.self,
            from: data
        )
        return categoryPreviews
    }
}
