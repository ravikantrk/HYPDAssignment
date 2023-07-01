//
//  ProductStoreViewModel.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 30/06/23.
//

import Foundation

class ProductStoreViewModel: ObservableObject {
    
    let apiService = APIService.shared
    @Published var collectionDataModel: Payload?
    @Published var productsDataModel: [ProductsPayload] = []
    @Published var similarProductDataModel: [ProductsPayload]?
    @Published var selectedProductDataModel: Set<String> = []
    @Published var isLoading = false
    @Published var isShowSelect = false
    
    private var allIds : [String] = []
    private let pageSize = 10
    private var remainingIds: [String] = []
    
    
    init() {
        getCollectionDataApi()
    }
    
}
extension ProductStoreViewModel {
    //MARK: load first 10 products data
    func loadFirstPage() {
        productsDataModel.removeAll()
        
        let firstPageIds = Array(allIds.prefix(pageSize))
        remainingIds = Array(allIds.dropFirst(pageSize))
        
        getAllProductsDataApi(ids: firstPageIds)
    }
    //MARK: load next 10 products data
    func fetchNextPage() {
        guard !isLoading else { return }
        
        let nextPageIds = Array(remainingIds.prefix(pageSize))
        remainingIds = Array(remainingIds.dropFirst(pageSize))
        
        getAllProductsDataApi(ids: nextPageIds)
    }
    
    //MARK: get collection data api
    func getCollectionDataApi()
    {
        isLoading = true
        apiService.get(endpoint: APIConfiguration.Endpoint.getCollectionInfo(id: "6475b6c7cbd697567cc42bda", status: "publish").path) { (result: Result<CollectionData, Error>) in
            switch result {
            case .success(let collection):
                self.collectionDataModel = collection.payload
                self.allIds = collection.payload?.catalogIDS ?? []
                self.loadFirstPage()
                self.getSimilarProductsDataApi()
                self.isLoading = false
                break
                
            case .failure(let error):
                // Handle error
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
        
    }
    //MARK: get product list api
    func getAllProductsDataApi(ids : [String])
    {
        isLoading = true
        let idsStr = ids.joined(separator: "&id=")
        let apiUrl = APIConfiguration.Endpoint.getProductData.path + "?id=" + idsStr
        
        apiService.get(endpoint: apiUrl) { (result: Result<ProductsData, Error>) in
            switch result {
            case .success(let products):
                self.productsDataModel.append(contentsOf: products.payload ?? []) 
                self.isLoading = false
                break
                
            case .failure(let error):
                // Handle error
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
        
    }
    //MARK: Similar products api
    func getSimilarProductsDataApi()
    {
        isLoading = true
        let para : [String:Any] = ["catalog_ids" : self.collectionDataModel?.catalogIDS ?? []]
        
        apiService.post(endpoint: APIConfiguration.Endpoint.getSimilarProducts.path, parameters: para) { (result: Result<SimilarProductData, Error>) in
            switch result {
            case .success(let products):
                self.similarProductDataModel = products.payload
                self.isLoading = false
                break
                
            case .failure(let error):
                // Handle error
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
        
    }
}
extension ProductStoreViewModel {
    //MARK: add all similar product
    func addAllSimilarProducts(){
        self.productsDataModel.insert(contentsOf: self.similarProductDataModel ?? [], at: 0)
        self.similarProductDataModel?.removeAll()
    }
    //MARK: add similar product
    func addProduct(product : ProductsPayload){
        self.productsDataModel.insert(product, at: 0)
        if let index = self.similarProductDataModel?.firstIndex(where: {$0.id == product.id}){
            self.similarProductDataModel?.remove(at: index)
        }
    }
    //MARK: selection of product
    func selectProduct(product : ProductsPayload){
        if self.selectedProductDataModel.contains(product.id ?? ""){
            self.selectedProductDataModel.remove(product.id ?? "")
        }else{
            self.selectedProductDataModel.insert(product.id ?? "")
        }
    }
    //MARK: check product selection
    func isSelected(_ product: ProductsPayload) -> Bool {
        return self.selectedProductDataModel.contains(product.id ?? "")
    }
    //MARK: clear selection
    func clearSelection() {
        self.selectedProductDataModel.removeAll()
    }
    
}
