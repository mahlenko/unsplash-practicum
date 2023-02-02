//
//  PhotoRequestTest.swift
//  Tests
//
//  Created by Сергей Махленко on 30.01.2023.
//  Copyright © 2023 ru.app-demo.unsplash. All rights reserved.
//
@testable import UnsplashPracticum
import XCTest

final class Tests: XCTestCase {
    func testFetchPhotos() {
        let service = PhotoRequest(urlSession: URLSession.shared)
        let expectation = self.expectation(description: "Wait for Notification")

        NotificationCenter.default.addObserver(
            forName: PhotoRequest.didChangeNotification,
            object: nil,
            queue: .main) { _ in
            expectation.fulfill()
        }

        service.fetchPhotoNextPage()

        wait(for: [expectation], timeout: 10)

        XCTAssertEqual(service.photos.count, 10)
    }
}
