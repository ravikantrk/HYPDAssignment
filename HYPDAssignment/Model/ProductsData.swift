//
//  ProductsData.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 30/06/23.
//

import Foundation

// MARK: - ProductsData
struct ProductsData: Codable {
    var success: Bool?
    var payload: [ProductsPayload]?
}

// MARK: - Payload
struct ProductsPayload: Codable {
    var id, name, brandID: String?
    var brandInfo: BrandInfo?
    var discountID: String?
    var featuredImage: FeaturedImage?
    var basePrice, retailPrice: Price?
    var inventoryStatus: String?
    var commissionRate: Int?
    var variants: [Variant]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case brandID = "brand_id"
        case brandInfo = "brand_info"
        case discountID = "discount_id"
        case featuredImage = "featured_image"
        case basePrice = "base_price"
        case retailPrice = "retail_price"
        case inventoryStatus = "inventory_status"
        case commissionRate = "commission_rate"
        case variants = "Variants"
    }
}

// MARK: - Price
struct Price: Codable {
    var iso: String?
    var value: Int?
}

// MARK: - BrandInfo
struct BrandInfo: Codable {
    var id, name, username: String?
    var logo: FeaturedImage?
    var isCodAvailable: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, username, logo
        case isCodAvailable = "is_cod_available"
    }
}

// MARK: - FeaturedImage
struct FeaturedImage: Codable {
    var src: String?
    var height, width: Int?
}


// MARK: - Variant
struct Variant: Codable {
    var id, attribute, inventoryID, sku: String?
    var isDeleted: Bool?
    var inventoryInfo: InventoryInfo?
    var easyecomVariantID, easyecomSku: String?

    enum CodingKeys: String, CodingKey {
        case id, attribute
        case inventoryID = "inventory_id"
        case sku
        case isDeleted = "is_deleted"
        case inventoryInfo = "inventory_info"
        case easyecomVariantID = "easyecom_variant_id"
        case easyecomSku = "easyecom_sku"
    }
}

// MARK: - InventoryInfo
struct InventoryInfo: Codable {
    var id: String?
    var catalogID: String?
    var variantID, sku: String?
    var status: Status?
    var unitInStock: Int?
    var createdAt: String?
//    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case catalogID = "catalog_id"
        case variantID = "variant_id"
        case sku, status
        case unitInStock = "unit_in_stock"
        case createdAt = "created_at"
        //case updatedAt = "updated_at"
    }
}

// MARK: - Status
struct Status: Codable {
    var value: Value?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case value
        case createdAt = "created_at"
    }
}

enum Value: String, Codable {
    case inStock = "in_stock"
    case outOfStock = "out_of_stock"
}
