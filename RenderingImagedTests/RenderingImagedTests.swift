//
//  RenderingImagedTests.swift
//  RenderingImagedTests
//
//  Created by Maktumhusen on 08/03/24.
//

import UIKit
import XCTest
@testable import RenderingImaged

final class RenderingImagedTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDownloadData() {
        // Given
        let downloader = DataDownloader()
        let mockSession = MockURLSession()
        downloader.urlSession = mockSession

        let url = URL(string: "https://example.com/data.json")!

        // Set up mock data
        let jsonData = """
        {
            "id": "1",
            "email" = 5,
            "first_name" = "AWQQWEQWEQWEQWEQEWQWEQWEQWEQWEQWEQWEQWEQWEQWEQWEQWEQWEQWE"
            "last_name" = 20.0
            "imageUrl": "123-https://example.com/image.jpg"
        }
        """.data(using: .utf8)
        mockSession.data = jsonData

        var capturedData: [User]?
        let expectation = self.expectation(description: "Download completion called")

        // download content from the URL
        downloader.getUserData(url: url, completion: { result in
            switch result {
            case .success(let data):
                capturedData = data
            case .failure(let error):
                XCTFail("Error downloading data: \(error.localizedDescription)")
            }
            expectation.fulfill()
        })

        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(capturedData, "Data should not be nil")
    }

}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let data = self.data
        let error = self.error
        return MockURLSessionDataTask {
            completionHandler(data, nil, error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}


