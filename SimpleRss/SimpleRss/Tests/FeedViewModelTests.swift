import XCTest
import RxSwift
import RxTest
import RxBlocking
import RxCocoa
@testable import SimpleRss

final class FeedViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var sut: FeedViewModelImplementation!
    
    var mockRssDataService: DataService!
    var mockNetworkService: NetworkService!
    var mockFeedViewModelDelegeate: FeedViewModelDelegeate!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        mockRssDataService = DefaultDataServiceMock()
        mockNetworkService = DefaultNetworkServiceMock()
        mockFeedViewModelDelegeate = DeafaultFeedViewModelDelegeateMock()
        
        sut = FeedViewModelImplementation(rssDataService: mockRssDataService,
                                          rssService: mockNetworkService,
                                          url: "",
                                          coordinator: mockFeedViewModelDelegeate)
    }

    func testContentStream() {
        // Given
        let content = scheduler.createObserver([FeedItemViewModel].self)
        
        sut.content
            .asDriver(onErrorJustReturn: [FeedItemViewModel]())
            .drive(content)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(10, ()),
                                        .next(20, ()),
                                        .next(30, ())])
            .bind(to: sut.updateFeed)
            .disposed(by: disposeBag)

        // When
        scheduler.start()

        // Then
        XCTAssertEqual(content.events, [
            .next(0, [FeedItemViewModel]()),
            .next(10, [FeedItemViewModel]()),
            .next(20, [FeedItemViewModel]()),
            .next(30, [FeedItemViewModel]())
        ])
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

