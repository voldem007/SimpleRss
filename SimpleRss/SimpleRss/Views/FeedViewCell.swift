//
//  FeedViewCell.swift
//  SimpleRss
//
//  Created by Voldem on 11/19/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewCell: UITableViewCell {
    
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var pubDateLabel: UILabel!
    
    private var getOperation: GetImageOperation!
    private var disposeBag: DisposeBag? = DisposeBag()
    private weak var delegate: FeedCellDelegate?
    
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else { return }
            getOperation = ImageDownloadOrchestrator.shared.download(url: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.previewImageView.image = image
                }
            }
        }
    }
    
    func setup(_ feed: FeedItemViewModel, _ delegate: FeedCellDelegate) {
        guard let bag = disposeBag else {
            return
        }
        self.delegate = delegate
        feed.title
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: bag)
        
        feed.pubDate
            .asDriver()
            .drive(pubDateLabel.rx.text)
            .disposed(by: bag)
        
        feed.description
            .asDriver()
            .drive(descriptionLabel.rx.text)
            .disposed(by: bag)
        
        feed.picUrl
            .asDriver()
            .drive(rx.url)
            .disposed(by: bag)
        
        feed.isExpanded?
            .asDriver(onErrorJustReturn: false)
            .drive(rx.isExpanded)
            .disposed(by: bag)
    }
    
    override func prepareForReuse() {
        
        disposeBag = nil
        disposeBag = DisposeBag()
        
        previewImageView.image = nil
        ImageDownloadOrchestrator.shared.cancel(getOperation)
        expanding(isExpanded: false)
    }
    
    func expanding(isExpanded: Bool) {
        descriptionLabel.numberOfLines = isExpanded ? 0 : 1;
        descriptionLabel.lineBreakMode = isExpanded ? .byWordWrapping : .byTruncatingTail
    }
    
    func updateTableView() {
        delegate?.updateTableView()
    }
}

private extension Reactive where Base: FeedViewCell {
    
    var url: Binder<URL?> {
        return Binder(self.base) { view, url in
            view.imageUrl = url
        }
    }
    
    var isExpanded: Binder<Bool> {
        return Binder(self.base) { view, isExpanded in
            view.expanding(isExpanded: isExpanded)
            view.updateTableView()
        }
    }
}
