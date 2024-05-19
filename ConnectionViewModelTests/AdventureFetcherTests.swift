import XCTest
@testable import HiJourney_1_2

class AttendedAdventuresViewModelTests: XCTestCase {
    
    var viewModel: AttendedAdventuresViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AttendedAdventuresViewModel()
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        viewModel = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }
    
    
    func testFetchAdventuresFailure() {
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: "TestErrorDomain", code: 404, userInfo: nil)
        }
        
        let expectation = self.expectation(description: "FetchAdventures")
        
        viewModel.fetchAdventures()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assert that adventures fetching fails
            XCTAssertEqual(self.viewModel.adventures.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}


class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
            let (response, data) = try handler(request)

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
    }
}
