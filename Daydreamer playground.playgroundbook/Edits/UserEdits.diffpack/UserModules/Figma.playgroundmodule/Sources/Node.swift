public class Node: Codable, CustomDebugStringConvertible {
    public let id: String
    public let name: String
    public let type: FigmaType
    public let children: [Node]
    
    public enum FigmaType: String, Codable {
        case document = "DOCUMENT"
        case rectangle = "RECTANGLE"
        case canvas = "CANVAS"
        case text = "TEXT"
    }
    
    static let typeMap: [FigmaType: Node.Type] = [
        .document: Document.self,
        .canvas: Canvas.self,
        .rectangle: Rectangle.self,
        .text: Text.self
    ]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case children
    }
    
    public required init(from decoder: Decoder) throws {
        let keyedDecoder = try decoder.container(keyedBy: Self.CodingKeys)
        
        self.id = try keyedDecoder.decode(String.self, forKey: .id)
        self.name = try keyedDecoder.decode(String.self, forKey: .name)
        self.type = try keyedDecoder.decode(FigmaType.self, forKey: .type)
        
        guard keyedDecoder.contains(.children) else {
            self.children = []
            return
        }
        var childrenDecoder = try keyedDecoder.nestedUnkeyedContainer(forKey: .children)
        var children: [Node] = []
        // Note that we intentionally make a copy of the children decoder here because when we
        // "peek" at the child type, it will advance the decoder, effectively skipping the decoding
        // of the child. To solve this we use two decoders and advance them in tandem.
        var childrenTypeDecoder = childrenDecoder
        while !childrenDecoder.isAtEnd {
            let childTypeDecoder = try childrenTypeDecoder.nestedContainer(keyedBy: Self.CodingKeys)
            let childFigmaType = try childTypeDecoder.decode(FigmaType.self, forKey: .type)
            
            guard let childType = Node.typeMap[childFigmaType] else {
                throw DecodingError.typeMismatch(
                    Node.self,
                    DecodingError.Context(
                        codingPath: childrenDecoder.codingPath,
                        debugDescription: "Unknown child type: \(childFigmaType)"
                    )
                )
            }
            children.append(try childrenDecoder.decode(childType))
        }
        self.children = children
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError("Not yet implemented")
    }
    
    public var debugDescription: String {
        return """
            <\(Swift.type(of: self))
            - id: \(id)
            - name: \(name)
            - type: \(type)
            \(contentDescription.isEmpty ? "" : "\n" + contentDescription)
            children:
            \(children.debugDescription.indented(by: 2))
            >
            """
    }
    
    var contentDescription: String {
        return ""
    }
}
