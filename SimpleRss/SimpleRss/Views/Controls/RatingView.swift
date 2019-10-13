//
//  RatingView.swift
//  SimpleRss
//
//  Created by Voldem on 10/7/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import CoreGraphics

@IBDesignable class RatingView: UIView {
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerChanged))
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerChanged))
        
        stackView.addGestureRecognizer(panGestureRecognizer)
        stackView.addGestureRecognizer(tapGestureRecognizer)
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var backgroungStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        addSubview(stackView)
        return stackView
    }()
    
    @IBInspectable var count: Int = 5
    
    @IBInspectable var rating: CGFloat = 0 {
        didSet {
            rating = min(CGFloat(integerLiteral: count), rating)
            
            if rating.rounded(.down) != oldValue.rounded(.down) {
                updateView()
            } else {
                if oldValue != rating {
                    updateLastView()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    @objc private func gestureRecognizerChanged(_ recognizer: UIGestureRecognizer) {
        guard let recognizerView = recognizer.view else { return }
        
        let singlePart = recognizerView.bounds.width / CGFloat(integerLiteral: count)
        let location = recognizer.location(in: recognizerView)
        let count = location.x / singlePart
        let index = Int(count.rounded(.down))

        guard index >= 0 else { return }

        rating = ((recognizer as? UITapGestureRecognizer) != nil) ? count.rounded(.awayFromZero) : count
    }
    
    private func setup() {
        backgroungStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroungStackView.topAnchor.constraint(equalTo: topAnchor),
            backgroungStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroungStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
        setupView()
    }
    
    private func setupView() {
        for view in backgroungStackView.arrangedSubviews {
            backgroungStackView.removeArrangedSubview(view)
        }

        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
        }
        
        for _ in 0 ..< count {
            let backgroundStar = StarView()
            backgroundStar.color = .gray
            backgroungStackView.addArrangedSubview(backgroundStar)
            
            let activeStar = StarView()
            activeStar.alpha = 0
            stackView.addArrangedSubview(activeStar)
        }
    }
    
    private func updateView() {
        for subView in stackView.arrangedSubviews {
            subView.alpha = 0
        }
        
        for view in backgroungStackView.subviews {
            view.zoomingBoundAnimate()
        }
        
        for index in 0 ..< Int(rating.rounded(.awayFromZero)) {
            guard let view = stackView.arrangedSubviews[index] as? StarView else { return }
            view.alpha = 1
            let percentage = rating - CGFloat(integerLiteral: index)
            view.percentage = percentage < 1.0 ? percentage : 1
            view.zoomingBoundAnimate()
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
    
    private var halfHeight: CGFloat {
        return height / 2.0
    }
    
    private var halfWidth: CGFloat {
        return width / 2.0
    }
    
    private var width: CGFloat {
        return min(bounds.width, bounds.height)
    }
    
    private var height: CGFloat {
        return min(bounds.width, bounds.height)
    }
    
    private var quarterWidth: CGFloat {
        return width / 4.0
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
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width * percentage, height: height))

        let starPath = UIBezierPath()

        starPath.move(to: CGPoint(x: halfWidth, y: 0.0))
        starPath.addLine(to: CGPoint(x: quarterWidth * 3.0, y: height))
        starPath.addLine(to: CGPoint(x: 0, y: halfHeight))
        starPath.addLine(to: CGPoint(x: width, y: halfHeight))
        starPath.addLine(to: CGPoint(x: quarterWidth, y: height))
        starPath.addLine(to: CGPoint(x: halfWidth, y: 0))
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
