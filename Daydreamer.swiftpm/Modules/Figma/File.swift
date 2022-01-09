import Foundation

extension Figma {
public struct File: Codable {
    public let name: String
    public let lastModified: String
    public let thumbnailUrl: String
    public let schemaVersion: Int
    public let role: String
    public let version: String
    public let linkAccess: LinkAccess
    public let document: Node
    
    public enum LinkAccess: String, Codable {
        case inherit = "inherit"
        case view = "view"
        case edit = "edit"
        case orgView = "org_view"
        case orgEdit = "org_edit"
        // TODO: Handle unknown cases more gracefully.
    }
}
}
