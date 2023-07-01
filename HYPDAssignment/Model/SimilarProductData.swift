//
//  SimilarProductData.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 30/06/23.
//

import Foundation

// MARK: - SimilarProductData
struct SimilarProductData: Codable {
    var success: Bool?
    var payload: [ProductsPayload]?
}

// MARK: - Payload
struct SimilarProductPayload: Codable {
    var id, brandID: String?
    var categoryPath: [String]?
    var categoryLvl1: [String]?
    var categoryLvl2, categoryLvl3: [String]?
    var name, lname, slug, description: String?
    var brandInfo: BrandInfo?
    var keywords: [String]?
    var featuredImage: FeaturedImage?
    var specs: [Spec]?
    var variantType: String?
    var variants: [Variant]?
    var eta: Eta?
    var status: Status?
    var statusHistory: [Status]?
    var hsnCode: String?
    var basePrice, retailPrice, transferPrice: Price?
    var tax: Tax?
    var catalogContent: [String]?
    var commissionRate: Int?
    var inventoryStatus: String?
    var createdAt, updatedAt: String?
    var brandCommissionRate: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brand_id"
        case categoryPath = "category_path"
        case categoryLvl1 = "category_lvl1"
        case categoryLvl2 = "category_lvl2"
        case categoryLvl3 = "category_lvl3"
        case name, lname, slug, description
        case brandInfo = "brand_info"
        case keywords
        case featuredImage = "featured_image"
        case specs
        case variantType = "variant_type"
        case variants, eta, status
        case statusHistory = "status_history"
        case hsnCode = "hsn_code"
        case basePrice = "base_price"
        case retailPrice = "retail_price"
        case transferPrice = "transfer_price"
        case tax
        case catalogContent = "catalog_content"
        case commissionRate = "commission_rate"
        case inventoryStatus = "inventory_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandCommissionRate = "brand_commission_rate"
    }
}

// MARK: - Spec
struct Spec: Codable {
    var name, value: String?
}

// MARK: - Eta
struct Eta: Codable {
    var min, max: Int?
    var unit: String?
}

// MARK: - Tax
struct Tax: Codable {
    var type: String?
    var rate: Int?
}
