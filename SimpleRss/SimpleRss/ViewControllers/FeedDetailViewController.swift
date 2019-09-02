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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
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
        
        viewModel?.picUrls.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: DetailViewCell.cellIdentifier)) { row, url, cell in
                guard let cell = cell as? DetailViewCell else { return }
                cell.setup(pictureUrl: url)
            }.disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension FeedDetailViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        let cellWidth = width
        return CGSize(width: cellWidth, height: height)
    }
}
