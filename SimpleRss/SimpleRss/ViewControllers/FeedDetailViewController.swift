//
//  FeedDetailViewController.swift
//  SimpleRss
//
//  Created by Voldem on 8/25/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedDetailViewController: UIViewController {
    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var ratingView: RatingView!
    
    public var viewModel: FeedDetailViewModel?
    private let disposeBag = DisposeBag()
    private let transition = ModalTransition(height: 380)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = transition
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transitioningDelegate = transition
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        let nib = UINib(nibName: DetailViewCell.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: DetailViewCell.cellIdentifier)
    }
    
    private func setupBinding() {
        guard let viewModel = viewModel else { return }
        
        viewModel.title
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .asDriver(onErrorJustReturn: "")
            .drive(descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pubDate
            .asDriver(onErrorJustReturn: "")
            .drive(pubDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.picUrls
            .bind(to: collectionView.rx.items(cellIdentifier: DetailViewCell.cellIdentifier)) { row, url, cell in
                guard let cell = cell as? DetailViewCell else { return }
                cell.setup(pictureUrl: url)
            }.disposed(by: disposeBag)
        
        viewModel
            .rating
            .map { CGFloat($0) }
            .bind(to: ratingView.rx.rating)
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear.bind(to: viewModel.showRating)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: { _ in self.collectionView.collectionViewLayout.invalidateLayout() },
            completion: nil
        )
    }
}

extension FeedDetailViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

extension Reactive where Base: UIViewController {
    
    public var viewWillDisappear: ControlEvent<()> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { _ in () }
        return ControlEvent(events: source)
    }
}
