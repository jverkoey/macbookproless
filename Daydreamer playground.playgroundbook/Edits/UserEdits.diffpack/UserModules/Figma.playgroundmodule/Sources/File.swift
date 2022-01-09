public final class File: Codable, CustomDebugStringConvertible {
    public let name: String
    public let lastModified: String
    public let thumbnailUrl: String
    public let schemaVersion: Int
    public let role: String
    public let version: String
    public let linkAccess: LinkAccess
    public let document: Document
    
    public enum LinkAccess: String, Codable {
        case inherit = "inherit"
        case view = "view"
        case edit = "edit"
        case orgView = "org_view"
        case orgEdit = "org_edit"
        // TODO: Handle unknown cases more gracefully.
    }
    
    public var debugDescription: String {
        return """
            <File
            - name: \(name)
            - lastModified: \(lastModified)
            - thumbnailUrl: \(thumbnailUrl)
            - schemaVersion: \(schemaVersion)
            - role: \(role)
            - version: \(version)
            - linkAccess: \(linkAccess)
            - document:
            \(document.debugDescription.indented(by: 2))
            >
            """
    }
}

extension String {
    func indented(by indent: Int) -> String {
        let indentString = String(repeating: " ", count: indent)
        return self.split(whereSeparator: \.isNewline).map {
            indentString + $0
        }.joined(separator: "\n")
    }
}
