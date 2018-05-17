import Foundation
import Vapor
import Fluent

final class PostController {
    func index(_ req: Request) throws -> Future<[Post]> {
        return try Post.query(on: req).sort(\Post.posted, .descending).all()
    }
    
    func post(_ req: Request) throws -> Future<Post> {
        let postID = try req.parameters.next(Int.self)
        return try Post.query(on: req).filter(\Post.id == postID).first().unwrap(or: HTTPParserError.unknown)
    }
    
    func create(_ req: Request) throws -> Future<Post> {
        return try req.content.decode(Post.self).flatMap { (post) -> EventLoopFuture<Post> in
            post.posted = Date()
            post.updated = nil
            return post.save(on: req)
        }
    }
    
    func update(_ req: Request) throws -> Future<Post> {
        let updatedPost = try req.content.decode(Post.self)
        return updatedPost.flatMap(to: Post.self) { updatedPost -> EventLoopFuture<Post> in
            return try Post.query(on: req).filter(\Post.id == updatedPost.id).first().map(to: Post.self) { post in
                guard let post = post else {
                    throw Abort(.notFound)
                }
                return post
                }.flatMap { post -> EventLoopFuture<Post> in
                    post.author = updatedPost.author
                    post.content = updatedPost.content
                    post.title = updatedPost.title
                    post.updated = Date()
                    return post.update(on: req).map(to: Post.self) { _ in post }
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<Post> {
        let post = try req.parameters.next(Int.self)
        return try Post.query(on: req).filter(\Post.id == post).first().flatMap({ post -> EventLoopFuture<Post> in
            guard let post = post else {
                throw Abort(.notFound)
            }
            return post.delete(on: req).transform(to: post)
        })
    }
}
