import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa
@testable import SimpleRss

final class DefaultNetworkServiceMock: NetworkService {
    var invokedGetFeed = false
    var invokedGetFeedCount = 0
    var invokedGetFeedParameters: (url: URL, Void)?
    var invokedGetFeedParametersList = [(url: URL, Void)]()
    var stubbedGetFeedResult: Single<[FeedModel]>!
    func getFeed(for url: URL) -> Single<[FeedModel]> {
        invokedGetFeed = true
        invokedGetFeedCount += 1
        invokedGetFeedParameters = (url, ())
        invokedGetFeedParametersList.append((url, ()))
        return stubbedGetFeedResult
    }
}
