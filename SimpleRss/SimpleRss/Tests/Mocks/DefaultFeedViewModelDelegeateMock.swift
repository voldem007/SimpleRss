import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa
@testable import SimpleRss

final class DefaultFeedViewModelDelegateMock: FeedViewModelDelegate {
    var invokedUserDidSelectFeed = false
    var invokedUserDidSelectFeedCount = 0
    var invokedUserDidSelectFeedParameters: (feed: FeedItemViewModel, Void)?
    var invokedUserDidSelectFeedParametersList = [(feed: FeedItemViewModel, Void)]()
    func userDidSelectFeed(_ feed: FeedItemViewModel) {
        invokedUserDidSelectFeed = true
        invokedUserDidSelectFeedCount += 1
        invokedUserDidSelectFeedParameters = (feed, ())
        invokedUserDidSelectFeedParametersList.append((feed, ()))
    }
}
