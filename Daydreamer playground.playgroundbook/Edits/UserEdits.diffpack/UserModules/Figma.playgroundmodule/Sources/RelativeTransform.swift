public struct RelativeTransform: Codable {
    public let row1: [Double]
    public let row2: [Double]
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        self.row1 = try container.decode([Double].self)
        self.row2 = try container.decode([Double].self)
    }
}
