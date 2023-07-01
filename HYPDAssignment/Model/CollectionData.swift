////
////  CollectionData.swift
////  HYPDAssignment
////
////  Created by Ravi kant Tiwari on 30/06/23.
////
//
//import Foundation
//
// MARK: - CollectionData
struct CollectionData: Codable {
    var success: Bool?
    var payload: Payload?
}

// MARK: - Payload
struct Payload: Codable {
    var id, influencerID, duplicateID: String?
    var influencerInfo: InfluencerInfo?
    var name, slug: String?
    var image: JSONNull?
    var catalogIDS: [String]?
    var status: String?
    var order: Int?
    var createdAt, updatedAt: String?
    var defaultImage: [ProductImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case influencerID = "influencer_id"
        case duplicateID = "duplicate_id"
        case influencerInfo = "influencer_info"
        case name, slug, image
        case catalogIDS = "catalog_ids"
        case status, order
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case defaultImage = "default_image"
    }
}


// MARK: - Image
struct ProductImage: Codable {
    var src: String?
    var height, width: Int?
}


// MARK: - InfluencerInfo
struct InfluencerInfo: Codable {
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
