import XCTest
@testable import SimpleRss

final class RssParserTests: XCTestCase {
    var sut: RssParser!
    var mockNetworking: DefaultNetworkingMock!

    override func setUp() {
        mockNetworking = DefaultNetworkingMock()
        sut = RssParser(network: mockNetworking)
    }
    
    func testParseIfError() {
        // Given
        var expectedError: MockError = MockError.mock
        mockNetworking.stubbedDataTaskResult = URLSession.shared.dataTask(with: URL(string: "123")!)
        mockNetworking.stubbedDataTaskCompletionHandlerResult = (nil, nil, expectedError)
        let parseReady = expectation(description: "parse is ready")
        var expectedData: [(String, Any)]? = []

        // When
        sut.parse(URL(string: "123")!) { (data, error) in
            expectedError = error as! MockError
            expectedData = data
            parseReady.fulfill()
        }
        
        // Then
        wait(for: [parseReady], timeout: 1)
        XCTAssertEqual(expectedError, .mock)
        XCTAssertTrue(expectedData?.isEmpty ?? true)
    }
    
    func testParseIfDataRetieveButError() {
        // Given
        let url = Bundle.main.url(forResource: "Data85Rows", withExtension: nil)!
        let data = try? Data(contentsOf: url)
        
        var expectedError: MockError = MockError.mock
        mockNetworking.stubbedDataTaskResult = URLSession.shared.dataTask(with: URL(string: "123")!)
        mockNetworking.stubbedDataTaskCompletionHandlerResult = (data, nil, expectedError)
        let parseReady = expectation(description: "parse is ready")
        var expectedData: [(String, Any)]? = []

        // When
        sut.parse(URL(string: "123")!) { (data, error) in
            expectedError = error as! MockError
            expectedData = data
            parseReady.fulfill()
        }
        
        // Then
        wait(for: [parseReady], timeout: 1)
        XCTAssertEqual(expectedError, .mock)
        XCTAssertTrue(expectedData?.isEmpty ?? true)
    }
    
    func testParseIfDataDone() {
        // Given
        let url = Bundle.main.url(forResource: "Data85Rows", withExtension: nil)!
        let data = try? Data(contentsOf: url)
        
        var expectedError: MockError? = nil
        mockNetworking.stubbedDataTaskResult = URLSession.shared.dataTask(with: URL(string: "123")!)
        mockNetworking.stubbedDataTaskCompletionHandlerResult = (data, nil, expectedError)
        let parseReady = expectation(description: "parse is ready")
        var expectedData: [(String, Any)]? = []

        // When
        sut.parse(URL(string: "123")!) { (data, error) in
            expectedError = error as? MockError
            expectedData = data
            parseReady.fulfill()
        }
        
        // Then
        wait(for: [parseReady], timeout: 1)
        XCTAssertEqual(expectedError, nil)
        XCTAssertEqual(expectedData?.count, 85)
    }
}

private enum MockError: Error {
    case mock
}
