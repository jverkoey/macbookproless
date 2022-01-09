import Foundation

extension Figma {
public struct Node: Codable {
    public let id: String
    public let name: String
    public let type: String
    public let children: [Node]?
    public let data: JSON 
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case type
        case children
    }
    
    public init(from decoder: Decoder) throws {
        let keyedDecoder = try decoder.container(keyedBy: Self.CodingKeys)
        self.id = try keyedDecoder.decode(String.self, forKey: .id)
        self.name = try keyedDecoder.decode(String.self, forKey: .name)
        self.type = try keyedDecoder.decode(String.self, forKey: .type)
        self.children = try keyedDecoder.decodeIfPresent([Node].self, forKey: .children)
        data = try JSON(from: decoder, ignoredKeys: CodingKeys.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError("Not yet implemented")
    }
}
}
