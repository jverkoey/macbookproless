public class Paint: Codable, CustomDebugStringConvertible {
    public let type: FigmaType
    public let visible: Bool = true
    public let opacity: Double = 1
    
    enum CodingKeys: String, CodingKey {
        case type
        case visible
        case opacity
    }
    
    static let typeMap: [FigmaType: Paint.Type] = [
        .solid: Solid.self,
    ]
    
    public enum FigmaType: String, Codable {
        case solid = "SOLID"
        case linearGradient = "GRADIENT_LINEAR"
        case radialGradient = "GRADIENT_RADIAL"
        case angularGradient = "GRADIENT_ANGULAR"
        case diamondGradient = "GRADIENT_DIAMOND"
        case image = "IMAGE"
        case emoji = "EMOJI"
    }
    
    public var debugDescription: String {
        return """
            <\(Swift.type(of: self))
            - type: \(type)
            - visible: \(visible)
            - opacity: \(opacity)
            \(contentDescription.isEmpty ? "" : "\n" + contentDescription)
            >
            """
    }
    
    var contentDescription: String {
        return ""
    }
}

extension Paint {
    public class Solid: Paint {
        public let color: Color
        
        private enum CodingKeys: String, CodingKey {
            case color
        }
        
        public required init(from decoder: Decoder) throws {
            let keyedDecoder = try decoder.container(keyedBy: Self.CodingKeys)
            
            self.color = try keyedDecoder.decode(Color.self, forKey: .color)
            
            try super.init(from: decoder)
        }
        
        override var contentDescription: String {
            return """
                - color: \(color)
                """
        }
    }
}
