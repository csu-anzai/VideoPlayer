//
//  VideoCell.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/31.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit
import Cartography
import SDWebImage

class VideoCell: UICollectionViewCell {
    
    //
    // MARK: Subviews
    //
    
    /// Video title label.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .primaryTitleColor
        label.accessibilityIdentifier = "Title label"
        return label
    }()
    
    /// Video presenter name label.
    private let presenterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .secondaryTitleColor
        label.accessibilityIdentifier = "Presenter name"
        return label
    }()
    
    /// Video description label.
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .secondaryTitleColor
        label.accessibilityIdentifier = "Video description"
        return label
    }()
    
    /// Video thumbnail image view.
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = "Video thumbnail"
        return imageView
    }()
    
    private let videoDurationOverlay: EdgeInsettedLabel = {
        let view = EdgeInsettedLabel()
        view.label.font = .boldSystemFont(ofSize: 12)
        view.label.textAlignment = .center
        view.label.textColor = .white
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.accessibilityIdentifier = "Video duration"
        // Rounded corners
        view.edgeInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 8.0, bottom: 5.0, trailing: 8.0)
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        return view
    }()
    
    /// The main view containing all subviews of the cell.
    let cardView = RoundedDropShadowView()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(title: "", presenterName: "", videoDescription: "", videoDuration: "", thumbnailImageURL: nil)
    }
    
    private func commonInit() {
        backgroundColor = .white
        contentView.addSubview(cardView)
        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(presenterNameLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(videoDurationOverlay)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        // constraints
        constrain(contentView, cardView, thumbnailImageView, titleLabel, presenterNameLabel, descriptionLabel, videoDurationOverlay) { (contentView, cardView, thumbnailImageView, titleLabel, presenterNameLabel, descriptionLabel, videoDurationOverlay) in
            // cardView
            cardView.edges == contentView.edges.inseted(top: 0, leading: 16, bottom: 16, trailing: 16)
            // thumbnail
            thumbnailImageView.top == cardView.top
            thumbnailImageView.leading == cardView.leading
            thumbnailImageView.trailing == cardView.trailing
            thumbnailImageView.height == thumbnailImageView.width * 9/16 // aspect ratio
            
            // duration overlay
            videoDurationOverlay.bottom == thumbnailImageView.bottom - 8.0
            videoDurationOverlay.trailing == thumbnailImageView.trailing - 8.0
            
            // presenter name
            let sidePadding: CGFloat = 16.0
            presenterNameLabel.top == thumbnailImageView.bottom + sidePadding
            presenterNameLabel.leading == cardView.leading + sidePadding
            presenterNameLabel.trailing == cardView.trailing - sidePadding
            
            // title + descrpition
            align(leading: presenterNameLabel, titleLabel, descriptionLabel)
            align(trailing: presenterNameLabel, titleLabel, descriptionLabel)
            distribute(by: 4.0, vertically: [presenterNameLabel, titleLabel, descriptionLabel])
            descriptionLabel.bottom == cardView.bottom - sidePadding
        }
    }
    
    //
    // MARK: Setup
    //
    
    /// Configure the cell witht the provided data.
    ///
    /// - Parameters:
    ///   - title: Title of the video.
    ///   - presenterName: Video presenter name.
    ///   - thumbnailImage: thumbnail image of the video. If this is nil then
    func configure(title: String, presenterName: String, videoDescription: String, videoDuration: String, thumbnailImageURL url: URL?) {
        titleLabel.text = title
        presenterNameLabel.text = presenterName.uppercased()
        descriptionLabel.text = videoDescription
        videoDurationOverlay.label.text = videoDuration
        videoDurationOverlay.isHidden = videoDuration.isEmpty
        thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "nilImage")) // TODO: Add placeholder image.
    }
    
    /// Update the thumbnail image.
    ///
    /// - Parameter thumbnailImage: thumbnail image.
    func update(thumbnailImage: UIImage) {
        thumbnailImageView.image = thumbnailImage
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        // Ensure we keep preferred width as is, while adjusting the height to be dynamic.
        layoutAttributes.bounds.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
                                                               withHorizontalFittingPriority: .required,
                                                               verticalFittingPriority: .defaultLow)
        return layoutAttributes
    }
    
}

/// A view wrapping a UILabel
///
/// You can use this view insetead of a UILabel to add paddings around
/// the actual text. This is particularly useful in cases like the following:
///
///     // Normal way which results in an unexpected corner radius.
///     // with no padding around the actual text
///     let label = UILabel()
///     label.layer.cornerRadius = 8.0
///     label.clipsToBounds = true
///
///     // You could alternatively use this class as follows
///     let view = EdgeInsettedLabel()
///     view.layer.cornerRadius = 8.0
///     view.edgeInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 8.0, bottom: 5.0, trailing: 8.0)
///     view.layer.cornerRadius = 8.0
///     view.clipsToBounds = true
fileprivate class EdgeInsettedLabel: UIView {
    
    let label = UILabel()
    private var constraintGroup = ConstraintGroup()
    
    var edgeInsets: NSDirectionalEdgeInsets = .zero {
        didSet {
            setUpConstraints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        constrain(self, label, replace: constraintGroup) { view, label in
            label.edges == view.edges.inseted(top: edgeInsets.top,
                                              leading: edgeInsets.leading,
                                              bottom: edgeInsets.bottom,
                                              trailing: edgeInsets.trailing)
        }
    }
}
