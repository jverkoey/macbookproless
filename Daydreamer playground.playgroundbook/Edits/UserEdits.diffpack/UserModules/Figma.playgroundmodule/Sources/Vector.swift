public class Vector: Node {
    public let absoluteBoundingBox: Rect
    public let relativeTransform: RelativeTransform
    public let size: Size
    public let fills: [Paint]
    
    private enum CodingKeys: String, CodingKey {
        case absoluteBoundingBox
        case relativeTransform
        case size
        case fills
    }
    
    public required init(from decoder: Decoder) throws {
        let keyedDecoder = try decoder.container(keyedBy: Self.CodingKeys)
        
        self.absoluteBoundingBox = try keyedDecoder.decode(Rect.self, forKey: .absoluteBoundingBox)
        self.relativeTransform = try keyedDecoder.decode(RelativeTransform.self, forKey: .relativeTransform)
        self.size = try keyedDecoder.decode(Size.self, forKey: .size)
        
        if keyedDecoder.contains(.fills) {
            var fillsDecoder = try keyedDecoder.nestedUnkeyedContainer(forKey: .fills)
            var fills: [Paint] = []
            var fillTypeDecoder = fillsDecoder
            while !fillsDecoder.isAtEnd {
                let fillTypeDecoder = try fillTypeDecoder.nestedContainer(keyedBy: Paint.CodingKeys.self)
                let fillFigmaType = try fillTypeDecoder.decode(Paint.FigmaType.self, forKey: .type)
                
                guard let fillType = Paint.typeMap[fillFigmaType] else {
                    throw DecodingError.typeMismatch(
                        Node.self,
                        DecodingError.Context(
                            codingPath: fillsDecoder.codingPath,
                            debugDescription: "Unknown fill type: \(fillFigmaType)"
                        )
                    )
                }
                fills.append(try fillsDecoder.decode(fillType))
            }
            self.fills = fills
        } else {
            self.fills = []
        }
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        fatalError("Not yet implemented")
    }
    
    override var contentDescription: String {
        return """
            - absoluteBoundingBox: \(absoluteBoundingBox)
            - relativeTransform: \(relativeTransform)
            - size: \(size)
            - fills:
            \(fills.debugDescription.indented(by: 2))
            """
    }
}
