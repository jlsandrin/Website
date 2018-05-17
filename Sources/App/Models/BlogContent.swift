import Foundation
import Vapor

struct BlogContent: Content {
    var title: String
    var content: String
    var author: String
    var posted: Date
    var updated: Date?
}
