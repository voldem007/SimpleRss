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
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        //TODO add binding 
        viewModel?.showRating.accept(Void())
    }
    
    fileprivate func setupUI() {
        let nib = UINib(nibName: DetailViewCell.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: DetailViewCell.cellIdentifier)
    }
    
    fileprivate func setupBinding() {
        viewModel?.title
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.description
            .asDriver(onErrorJustReturn: "")
            .drive(descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.pubDate
            .asDriver(onErrorJustReturn: "")
            .drive(pubDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.picUrls
            .bind(to: collectionView.rx.items(cellIdentifier: DetailViewCell.cellIdentifier)) { row, url, cell in
                guard let cell = cell as? DetailViewCell else { return }
                cell.setup(pictureUrl: url)
            }.disposed(by: disposeBag)
        
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
