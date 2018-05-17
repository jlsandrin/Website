import Foundation
import Vapor
import FluentSQLite
import Leaf

final class BlogContentController {
    func index(_ req: Request) throws -> Future<[BlogContent]> {
        return try Post.query(on: req).join(field: \User.id, to: \Post.author).alsoDecode(User.self).all().flatMap(to: [BlogContent].self, { (result) -> EventLoopFuture<[BlogContent]> in
            var blogContent: [BlogContent] = []
            for (post, user) in result {
                blogContent.append(BlogContent(title: post.title,
                                               content: post.content,
                                               author: user.name,
                                               posted: post.posted!,
                                               updated: post.updated))
            }
            return req.eventLoop.newSucceededFuture(result: blogContent)
        })
    }
    
    func view(_ req: Request) throws -> Future<View> {
        return try index(req).flatMap(to: View.self) { (content) -> EventLoopFuture<View> in
            let context = ["blogContent" : content]
            return try req.view().render("blog", context)
        }
    }
}
