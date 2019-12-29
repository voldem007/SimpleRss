//
//  RatingViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/8/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxBlocking

class RatingViewController: UIViewController {
    
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var ratingView: RatingView!
    @IBOutlet var sendButton: UIButton!
    
    public var viewModel: RatingViewModel?
    private let disposeBag = DisposeBag()
    private let transition = ModalTransition(height: 280)
    
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
        
        sendButton.layer.borderColor = UIColor.gray.cgColor
        setupBinding()
    }
    
    fileprivate func setupBinding() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel
            .rating
            .map { CGFloat($0) }
            .bind(to: ratingView.rx.rating)
            .disposed(by: disposeBag)
        
        ratingView.rx
            .rating
            .map { Double($0) }
            .bind(to: viewModel.rating)
            .disposed(by: disposeBag)
        
        sendButton.rx
            .tap
            .bind(to: viewModel.sendRating)
            .disposed(by: disposeBag)
        
        viewModel
            .comment
            .bind(to: commentTextView.rx.text)
            .disposed(by: disposeBag)
        
        commentTextView.rx
            .text
            .orEmpty
            .skip(1)
            .bind(to: viewModel.comment)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: RatingView {
    
    var rating: ControlProperty<CGFloat> {
        return base.rx.controlProperty(editingEvents: UIControl.Event.valueChanged,
                                       getter: { (customView: RatingView) in
                                        return customView.rating },
                                       setter: { (customView: RatingView, newValue) in
                                        customView.rating = newValue })
    }
    
}
