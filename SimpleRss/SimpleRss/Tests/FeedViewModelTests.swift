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
    
    let url = "https://github.com/ReactiveX/RxSwift/issues/2072"
    var mockRssDataService: DefaultDataServiceMock!
    var mockNetworkService: DefaultNetworkServiceMock!
    var mockFeedViewModelDelegate: DefaultFeedViewModelDelegateMock!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        mockRssDataService = DefaultDataServiceMock()
        mockNetworkService = DefaultNetworkServiceMock()
        mockFeedViewModelDelegate = DefaultFeedViewModelDelegateMock()
    }
    
    func testContentShouldBeTakenFromNetworkAfterPullToRefresh() {
        // Given
        let content = scheduler.createObserver([FeedItemViewModel].self)
        let expectedItem = FeedItemViewModel(FeedModel())
        
        let expectedItemFromLocalStore = [FeedModel(), FeedModel(), FeedModel()]
        let expectedItemFromNetwork = [FeedModel(), FeedModel()]
        
        mockNetworkService.stubbedGetFeedResult = Single<[FeedModel]>.just(expectedItemFromNetwork)
        mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.just(expectedItemFromLocalStore)
        
        mockRssDataService.stubbedSaveFeedResult = Single.create { [weak self] single in
            guard let self = self else { return Disposables.create()}
            self.mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.create { maybe in
                maybe(.success(expectedItemFromNetwork))
                return Disposables.create()
            }
            
            single(.success(Void()))
            return Disposables.create()
        }
        
        sut = FeedViewModelImplementation(rssDataService: mockRssDataService,
                                          rssService: mockNetworkService,
                                          url: url,
                                          coordinator: mockFeedViewModelDelegate)

        // When
        sut.content
            .asDriver(onErrorJustReturn: [FeedItemViewModel]())
            .drive(content)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(100, ()),
                                        .next(200, ()),
                                        .next(300, ())])
            .bind(to: sut.updateFeed)
            .disposed(by: disposeBag)
        
        scheduler.start()

        // Then
        XCTAssertEqual(content.events, [
            .next(0, [expectedItem, expectedItem, expectedItem]),
            .next(100, [expectedItem, expectedItem]),
            .next(200, [expectedItem, expectedItem]),
            .next(300, [expectedItem, expectedItem])
        ])
    }
    
    func testContentShouldBeTakenFromNetworkIfLocalIsEmpty() {
        // Given
        let content = scheduler.createObserver([FeedItemViewModel].self)
        let expectedItem = FeedItemViewModel(FeedModel())
        
        let expectedItemFromLocalStore: [FeedModel] = []
        let expectedItemFromNetwork = [FeedModel(), FeedModel()]
        
        mockNetworkService.stubbedGetFeedResult = Single<[FeedModel]>.just(expectedItemFromNetwork)
        mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.just(expectedItemFromLocalStore)
        
        mockRssDataService.stubbedSaveFeedResult = Single.create { [weak self] single in
            guard let self = self else { return Disposables.create()}
            self.mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.create { maybe in
                maybe(.success(expectedItemFromNetwork))
                return Disposables.create()
            }
            
            single(.success(Void()))
            return Disposables.create()
        }
        
        sut = FeedViewModelImplementation(rssDataService: mockRssDataService,
                                          rssService: mockNetworkService,
                                          url: url,
                                          coordinator: mockFeedViewModelDelegate)

        // When
        sut.content
            .asDriver(onErrorJustReturn: [FeedItemViewModel]())
            .drive(content)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(content.events, [
            .next(0, [expectedItem, expectedItem])
        ])
    }
    
    func testContentShouldBeTakenFromLocalIfNotEmpty() {
        // Given
        let content = scheduler.createObserver([FeedItemViewModel].self)
        let expectedItem = FeedItemViewModel(FeedModel())
        
        let expectedItemFromLocalStore: [FeedModel] = [FeedModel(), FeedModel(), FeedModel(), FeedModel()]
        let expectedItemFromNetwork = [FeedModel(), FeedModel()]
        
        mockNetworkService.stubbedGetFeedResult = Single<[FeedModel]>.just(expectedItemFromNetwork)
        mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.just(expectedItemFromLocalStore)
        
        mockRssDataService.stubbedSaveFeedResult = Single.create { [weak self] single in
            guard let self = self else { return Disposables.create()}
            self.mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.create { maybe in
                maybe(.success(expectedItemFromNetwork))
                return Disposables.create()
            }
            
            single(.success(Void()))
            return Disposables.create()
        }
        
        sut = FeedViewModelImplementation(rssDataService: mockRssDataService,
                                          rssService: mockNetworkService,
                                          url: url,
                                          coordinator: mockFeedViewModelDelegate)

        // When
        sut.content
            .asDriver(onErrorJustReturn: [FeedItemViewModel]())
            .drive(content)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(content.events, [
            .next(0, [expectedItem, expectedItem, expectedItem, expectedItem])
        ])
    }
    
    func testIsBusyShouldChangStateDependOnContent() {
        // Given
        let content = scheduler.createObserver([FeedItemViewModel].self)
        let isBusy = scheduler.createObserver(Bool.self)

        let expectedItem = FeedItemViewModel(FeedModel())

        let expectedItemFromLocalStore: [FeedModel] = []
        let expectedItemFromNetwork = [FeedModel(), FeedModel()]
        
        mockNetworkService.stubbedGetFeedResult = Single<[FeedModel]>.just(expectedItemFromNetwork)
        mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.just(expectedItemFromLocalStore)
        
        mockRssDataService.stubbedSaveFeedResult = Single.create { [weak self] single in
            guard let self = self else { return Disposables.create()}
            self.mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.create { maybe in
                maybe(.success(expectedItemFromNetwork))
                return Disposables.create()
            }
            self.scheduler.sleep(100)
            single(.success(Void()))
            return Disposables.create()
        }
        
        sut = FeedViewModelImplementation(rssDataService: mockRssDataService,
                                          rssService: mockNetworkService,
                                          url: url,
                                          coordinator: mockFeedViewModelDelegate)

        // When
        sut.isBusy
            .asDriver(onErrorJustReturn: false)
            .drive(isBusy)
            .disposed(by: disposeBag)
        
        sut.content
            .asDriver(onErrorJustReturn: [FeedItemViewModel]())
            .drive(content)
            .disposed(by: disposeBag)

        // Then
        XCTAssertEqual(content.events, [
            .next(100, [expectedItem, expectedItem])
        ])
        
        XCTAssertEqual(isBusy.events, [
            .next(0, true),
            .next(100, false)
        ])
    }
    
    func testSelectedFeedShouldBeInvokedAfterTap() {
        // Given
        let content = scheduler.createObserver([FeedItemViewModel].self)
        let selectedFeed = scheduler.createObserver(FeedItemViewModel.self)
        
        let expectedItem0 = FeedItemViewModel(FeedModel(id: "0", picLinks: [String]()))
        let expectedItem1 = FeedItemViewModel(FeedModel(id: "1", picLinks: [String]()))
        let expectedItem2 = FeedItemViewModel(FeedModel(id: "2", picLinks: [String]()))
        
        let expectedItemFromLocalStore = [FeedModel(), FeedModel(), FeedModel()]
        let expectedItemFromNetwork = [FeedModel(), FeedModel()]
        
        mockNetworkService.stubbedGetFeedResult = Single<[FeedModel]>.just(expectedItemFromNetwork)
        mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.just(expectedItemFromLocalStore)
        
        mockRssDataService.stubbedSaveFeedResult = Single.create { [weak self] single in
            guard let self = self else { return Disposables.create()}
            self.mockRssDataService.stubbedGetFeedResult = Maybe<[FeedModel]>.create { maybe in
                maybe(.success(expectedItemFromNetwork))
                return Disposables.create()
            }
            
            single(.success(Void()))
            return Disposables.create()
        }
        
        sut = FeedViewModelImplementation(rssDataService: mockRssDataService,
                                          rssService: mockNetworkService,
                                          url: url,
                                          coordinator: mockFeedViewModelDelegate)

        // When
        sut.content
            .asDriver(onErrorJustReturn: [FeedItemViewModel]())
            .drive(content)
            .disposed(by: disposeBag)
        
        sut.selectedFeed
            .asDriver(onErrorJustReturn: FeedItemViewModel(FeedModel()))
            .drive(selectedFeed)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(100, expectedItem0),
                                        .next(200, expectedItem1),
                                        .next(300, expectedItem2)])
            .bind(to: sut.selectedFeed)
            .disposed(by: disposeBag)
        
        scheduler.start()

        // Then
        XCTAssertEqual(selectedFeed.events, [
            .next(100, expectedItem0),
            .next(200, expectedItem1),
            .next(300, expectedItem2)
        ])
        
        XCTAssertEqual(mockFeedViewModelDelegate.invokedUserDidSelectFeedCount, 3)
    }
}
