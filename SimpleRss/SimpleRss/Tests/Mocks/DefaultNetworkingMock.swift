@testable import SimpleRss

final class DefaultNetworkingMock: Network {
    var invokedDataTask = false
    var invokedDataTaskCount = 0
    var invokedDataTaskParameters: (url: URL, Void)?
    var invokedDataTaskParametersList = [(url: URL, Void)]()
    var stubbedDataTaskCompletionHandlerResult: (Data?, URLResponse?, Error?)?
    var stubbedDataTaskResult: URLSessionDataTask!
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        invokedDataTask = true
        invokedDataTaskCount += 1
        invokedDataTaskParameters = (url, ())
        invokedDataTaskParametersList.append((url, ()))
        if let result = stubbedDataTaskCompletionHandlerResult {
            completionHandler(result.0, result.1, result.2)
        }
        return stubbedDataTaskResult
    }
}
