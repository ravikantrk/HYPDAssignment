//
//  APIConstants.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 30/06/23.
//

import Foundation

struct APIConfiguration {
    static let baseURL = "https://catalogv2.getshitdone.in/api/"
    
    enum Endpoint {
        case getCollectionInfo(id: String,status: String)
        case getProductData
        case getSimilarProducts
        
        var path: String {
            switch self {
            case .getCollectionInfo(let id, let status):
                return "app/influencer/collection?id=\(id)&status=\(status)"
            case .getProductData:
                return "app/catalog/basic"
            case .getSimilarProducts:
                return "v3/app/catalog/similar"
            }
        }
    }
    
}

