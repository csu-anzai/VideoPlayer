//
//  CardView.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/09/01.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit
import Cartography

class RoundedDropShadowView: UIView {
    
    //
    // MARK: Properties
    //
    
    /// The radius to use when drawing rounded corners for the layer’s background.
    var cornerRadius: CGFloat = 16.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The blur radius (in points) used to render the layer’s shadow.
    ///
    /// You specify the radius The default value of this property is 13.0.
    var shadowRadius: CGFloat = 13.0 {
        didSet {
            shadowLayer.shadowRadius = shadowRadius
        }
    }
    
    /// The opacity of the layer’s shadow.
    ///
    /// The value in this property must be in the range 0.0 (transparent) to 1.0 (opaque). The default value of this property is 0.2.
    var shadowOpacity: Float = 0.2 {
        didSet {
            shadowLayer.shadowOpacity = shadowOpacity
        }
    }
    
    /// The offset (in points) of the layer’s shadow.
    ///
    /// The default value of this property is (0.0, 5.0).
    var shadowOffset: CGSize = CGSize(width: 0, height: 5) {
        didSet {
            shadowLayer.shadowOffset = shadowOffset
        }
    }
    
    private let maskLayer = CAShapeLayer()
    private let shadowLayer = CAShapeLayer()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    //
    // MARK: Lifecycle
    //
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.path = maskLayer.path
    }
    
    //
    // MARK: Setup
    //
    
    private func commonInit() {
        backgroundColor = .white
        super.addSubview(contentView) // we call super here to make sure we don't go in an infinte loop (since we overriden the addSubview method)
        contentView.layer.mask = maskLayer
        layer.insertSublayer(shadowLayer, at: 0)
        // setup shadow
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOffset = shadowOffset
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        constrain(self, contentView) { view, contentView in
            contentView.edges == view.edges
        }
    }
    
    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
    
    override var backgroundColor: UIColor? {
        get {
            return contentView.backgroundColor
        }
        set {
            contentView.backgroundColor = newValue
        }
    }
    
}
