//
//  TikTokTests.swift
//  TikTokTests
//
//  Created by Vladimir Kratinov on 2022-12-04.
//

import XCTest
@testable import TikTok

final class TikTokTests: XCTestCase {

    func testPostModelChildPath() {
        let id = UUID().uuidString
        let user = User(username: "billgates", profilePictureURL: nil, identifier: "billgates1337")
        var post = PostModel(identifier: id, user: user)
        XCTAssertTrue(post.caption.isEmpty)
        post.caption = "Hello!"
        XCTAssertFalse(post.caption.isEmpty)
        XCTAssertEqual(post.caption, "Hello!")
        XCTAssertEqual(post.videoChildPath, "videos/billgates/")
    }

}
