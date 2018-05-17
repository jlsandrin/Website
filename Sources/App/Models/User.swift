import Foundation
import FluentSQLite
import Vapor

final class User: Content, SQLiteModel, Migration {
    var id: Int?
    
    var name: String
    
    init(id: Int?,
         name: String) {
        self.id = id
        self.name = name
    }
}
