

import UIKit

//MARK: -

struct Urls{
    let smallPhoto: String
    let thumbPhoto: String
    let regular: String
    
    enum CodingKeys: String, CodingKey{
        case smallPhoto = "small"
        case thumbPhoto = "thumb"
        case regular
    }
}

extension Urls: Codable{
    
    //For Decodable:
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        smallPhoto = try values.decode(String.self, forKey: .smallPhoto)
        thumbPhoto = try values.decode(String.self, forKey: .thumbPhoto)
        regular = try values.decode(String.self, forKey: .regular)

    }
    
    //For Encodable:
    func encode(to encoder: Encoder) throws {
        
        var vlaues = encoder.container(keyedBy: CodingKeys.self)
        
        try vlaues.encode(smallPhoto, forKey: .smallPhoto)
        try vlaues.encode(thumbPhoto, forKey: .thumbPhoto)
        try vlaues.encode(regular, forKey: .regular)

    }
}

//MARK: -

struct Results{
    let theId: String
    let createdAt: String?
    let width, height: Int
    //MARK: TODO: From HEXColor to UIColor: ✅
    let hexColor: UIColor
    let photoDescription: String?
    let altDescription: String?
    let urls: Urls?
    let likes: Int?
    let likedByUser: Bool
    let currentUserCollections: [String]?
    
    enum CodingKeys: String, CodingKey{
        case theId = "id"
        case width, height
        case hexColor = "color"
        case createdAt = "created_at"
        case photoDescription = "description"
        case altDescription = "alt_description"
        case urls
        case likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
    }
}

extension Results: Codable{
    
    //For Decodable:
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        theId = try values.decode(String.self, forKey: .theId)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        
        let stringColor = try values.decode(String.self, forKey: .hexColor)
        hexColor = UIColor(hexString: stringColor)
        
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        photoDescription = try values.decodeIfPresent(String.self, forKey: .photoDescription)
        altDescription = try values.decodeIfPresent(String.self, forKey: .altDescription)
        urls = try values.decodeIfPresent(Urls.self, forKey: .urls)
        likes = try values.decodeIfPresent(Int.self, forKey: .likes)
        likedByUser = try values.decode(Bool.self, forKey: .likedByUser)
        currentUserCollections = try values.decodeIfPresent([String].self, forKey: .currentUserCollections)
    }
    
    //For Encodable:
    func encode(to encoder: Encoder) throws {
        
        var vlaues = encoder.container(keyedBy: CodingKeys.self)
        
        try vlaues.encode(theId, forKey: .theId)
        try vlaues.encode(width, forKey: .width)
        try vlaues.encode(height, forKey: .height)

        let colorString = hexColor.rgbHexString
        try vlaues.encode(colorString, forKey: .hexColor)
        
        try vlaues.encodeIfPresent(createdAt, forKey: .createdAt)
        try vlaues.encodeIfPresent(photoDescription, forKey: .photoDescription)
        try vlaues.encodeIfPresent(altDescription, forKey: .altDescription)
        try vlaues.encodeIfPresent(urls, forKey: .urls)
        try vlaues.encodeIfPresent(likes, forKey: .likes)
        try vlaues.encode(likedByUser, forKey: .likedByUser)
        try vlaues.encodeIfPresent(currentUserCollections, forKey: .currentUserCollections)

    }
}

typealias ResultsResponse = [Results]

//MARK: -

struct PhotosResponse{
    let total: Int?
    let totalPages: Int?
    let results: [Results]?
    
    enum CodingKeys: String, CodingKey{
        case total
        case totalPages = "total_pages"
        case results
    }
    
}

extension PhotosResponse: Codable{
    
    //For Decodable:
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
    
    //For Encodable:
    func encode(to encoder: Encoder) throws {
        
        var vlaues = encoder.container(keyedBy: CodingKeys.self)
        
        try vlaues.encodeIfPresent(total, forKey: .total)
        try vlaues.encodeIfPresent(totalPages, forKey: .totalPages)
        try vlaues.encodeIfPresent(results, forKey: .results)

    }
}
