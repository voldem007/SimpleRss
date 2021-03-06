//
//  RatingView.swift
//  SimpleRss
//
//  Created by Voldem on 10/7/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import CoreGraphics

@IBDesignable class RatingView: UIControl {
    
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerChanged))
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerChanged))
    
    private lazy var stackView: UIStackView = {
        let stackView = setupStackView()
        stackView.addGestureRecognizer(panGestureRecognizer)
        stackView.addGestureRecognizer(tapGestureRecognizer)
        setupConstraints(stackView)
        return stackView
    }()
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = setupStackView()
        setupConstraints(stackView)
        return stackView
    }()
    
    @IBInspectable var count: Int = 5
    
    public var rating: CGFloat = 0 {
        didSet {
            if oldValue != rating {
                rating = min(CGFloat(integerLiteral: count), rating)
                sendActions(for: .valueChanged)
                
                if rating.rounded(.down) != oldValue.rounded(.down) {
                    updateView()
                } else if oldValue != rating {
                    updateLastView()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        updateView(animated: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    @objc private func gestureRecognizerChanged(_ recognizer: UIGestureRecognizer) {
        guard let recognizerView = recognizer.view else { return }
        
        let singlePart = recognizerView.bounds.width / CGFloat(integerLiteral: count)
        let location = recognizer.location(in: recognizerView)
        let count = location.x / singlePart
        let index = Int(count.rounded(.down))

        guard index >= 0 else { return }

        switch recognizer {
        case is UITapGestureRecognizer:
            rating = count.rounded(.awayFromZero)
        default:
            rating = count
        }
    }
    
    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        return stackView
    }
    
    private func setupConstraints(_ stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
    
    private func setupView() {
        backgroundStackView.removeAll()
        stackView.removeAll()
        
        for _ in 0 ..< count {
            let backgroundStar = StarView()
            backgroundStar.color = .gray
            backgroundStackView.addArrangedSubview(backgroundStar)
            
            let activeStar = StarView()
            activeStar.alpha = 0
            stackView.addArrangedSubview(activeStar)
        }
    }
    
    private func updateView(animated: Bool = true) {
        for subView in stackView.arrangedSubviews {
            subView.alpha = 0
        }
        
        if animated {
            for view in backgroundStackView.subviews {
                view.zoomingBoundAnimate()
            }
        }
        
        for index in 0 ..< Int(rating.rounded(.awayFromZero)) {
            guard let view = stackView.arrangedSubviews[index] as? StarView else { return }
            view.alpha = 1
            let percentage = rating - CGFloat(integerLiteral: index)
            view.percentage = percentage < 1.0 ? percentage : 1
            if animated {
                view.zoomingBoundAnimate()
            }
        }
    }
    
    private func updateLastView() {
        let index = Int(rating.rounded(.down))
        let percentage = rating - rating.rounded(.down)
        guard let view = stackView.arrangedSubviews[index] as? StarView else { return }
        view.percentage = CGFloat(percentage)
    }
}

public class StarView: UIView {
    var color: UIColor = .yellow
    
    var percentage: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func draw(_ rect: CGRect) {
        let height = min(bounds.width, bounds.height)
        let width = height
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width * percentage, height: height))

        let starPath = UIBezierPath()

        starPath.move(to: CGPoint(x: width / 2.0, y: 0.0))
        starPath.addLine(to: CGPoint(x: width / 4.0 * 3.0, y: height))
        starPath.addLine(to: CGPoint(x: 0, y: height / 2.0))
        starPath.addLine(to: CGPoint(x: width, y: height / 2.0))
        starPath.addLine(to: CGPoint(x: width / 4.0, y: height))
        starPath.addLine(to: CGPoint(x: width / 2.0, y: 0))
        starPath.close()
        
        color.setFill()
        starPath.fill()
     
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
}
