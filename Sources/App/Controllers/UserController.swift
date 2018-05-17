import Foundation
import Vapor
import FluentSQLite

final class UserController {
    func index(_ req: Request) throws -> Future<[User]> {
        return try User.query(on: req).sort(\User.name, .ascending).all()
    }
    
    func user(_ req: Request) throws -> Future<User> {
        let userID = try req.parameters.next(Int.self)
        return try User.query(on: req).filter(\User.id == userID).first().unwrap(or: HTTPParserError.unknown)
    }
    
    func update(_ req: Request) throws -> Future<User> {
        let updatedUser = try req.content.decode(User.self)
        return updatedUser.flatMap(to: User.self) { (updatedUser) -> EventLoopFuture<User> in
            try User.query(on: req).filter(\User.id == updatedUser.id).first().map(to: User.self, { (user) -> User in
                guard let user = user else {
                    throw Abort(.notFound)
                }
                return user
            }).flatMap(to: User.self,
                       { (user) -> EventLoopFuture<User> in
                        user.name = updatedUser.name
                        return user.update(on: req).map(to: User.self) { return $0 }
            })
        }
    }
    
    func create<T: User>(_ req: Request) throws -> Future<T> {
        return try req.content.decode(T.self).flatMap(to: T.self) { user -> EventLoopFuture<T> in
            return user.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<User> {
        let userID = try req.parameters.next(Int.self)
        return try User.query(on: req).filter(\User.id == userID).first().flatMap { user -> EventLoopFuture<User> in
            guard let user = user else {
                throw Abort(.notFound)
            }
            return user.delete(on: req).transform(to: user)
        }
    }
}
