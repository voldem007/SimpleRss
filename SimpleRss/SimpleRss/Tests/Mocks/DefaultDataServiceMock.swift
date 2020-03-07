import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa
@testable import SimpleRss

final class DefaultDataServiceMock: DataService {
    var invokedGetTopics = false
    var invokedGetTopicsCount = 0
    var stubbedGetTopicsResult: Single<[TopicModel]>!
    func getTopics() -> Single<[TopicModel]> {
        invokedGetTopics = true
        invokedGetTopicsCount += 1
        return stubbedGetTopicsResult
    }
    var invokedGetFeed = false
    var invokedGetFeedCount = 0
    var invokedGetFeedParameters: (feedUrl: String, Void)?
    var invokedGetFeedParametersList = [(feedUrl: String, Void)]()
    var stubbedGetFeedResult: Maybe<[FeedModel]>!
    func getFeed(by feedUrl: String) -> Maybe<[FeedModel]> {
        invokedGetFeed = true
        invokedGetFeedCount += 1
        invokedGetFeedParameters = (feedUrl, ())
        invokedGetFeedParametersList.append((feedUrl, ()))
        return stubbedGetFeedResult
    }
    var invokedSaveFeed = false
    var invokedSaveFeedCount = 0
    var invokedSaveFeedParameters: (feedList: [FeedModel], url: String)?
    var invokedSaveFeedParametersList = [(feedList: [FeedModel], url: String)]()
    var stubbedSaveFeedResult: Single<Void>!
    func saveFeed(feedList: [FeedModel], for url: String) -> Single<Void> {
        invokedSaveFeed = true
        invokedSaveFeedCount += 1
        invokedSaveFeedParameters = (feedList, url)
        invokedSaveFeedParametersList.append((feedList, url))
        return stubbedSaveFeedResult
    }
    var invokedAddComment = false
    var invokedAddCommentCount = 0
    var invokedAddCommentParameters: (feedId: String, rating: Double, comment: String)?
    var invokedAddCommentParametersList = [(feedId: String, rating: Double, comment: String)]()
    var stubbedAddCommentResult: Single<Void>!
    func addComment(feedId: String, rating: Double, comment: String) -> Single<Void> {
        invokedAddComment = true
        invokedAddCommentCount += 1
        invokedAddCommentParameters = (feedId, rating, comment)
        invokedAddCommentParametersList.append((feedId, rating, comment))
        return stubbedAddCommentResult
    }
}
