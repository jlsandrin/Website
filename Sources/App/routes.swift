import Vapor
import FluentSQLite

public func routes(_ router: Router) throws {    
    let userController = UserController()
    router.get("users", use: userController.index)
    router.put("user", use: userController.update)
    router.delete("user", use: userController.delete)
    router.get("user", Int.parameter, use: userController.user)
    router.post("user", use: userController.create)
    
    
    let postController = PostController()
    router.get("posts", use: postController.index)
    router.put("post", use: postController.update)
    router.post("post", use: postController.create)
    router.delete("post", use: postController.delete)
    router.get("post", Int.parameter, use: postController.post)
    
    let blogContentController = BlogContentController()
    router.get("", use: blogContentController.view)
}
