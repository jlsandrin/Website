import Foundation
import FluentSQLite
import Vapor

final class Post: Content, SQLiteModel, Migration {
    var id: Int?
    
    var title: String
    
    var content: String
    
    var author: Int
    
    var posted: Date?
    
    var updated: Date?
    
    init(id: Int?,
         title: String,
         content: String,
         author: Int,
         posted: Date?,
         updated: Date?) {
        self.id = id
        self.title = title
        self.content = content
        self.author = author
        self.posted = posted
        self.updated = updated
    }
}
