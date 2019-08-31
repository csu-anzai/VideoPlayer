//
//  VideoCell.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/31.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit
import Cartography

class VideoCell: UICollectionViewCell {
    
    //
    // MARK: Subviews
    //
    
    /// Video title label.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .primaryTitleColor
        label.accessibilityIdentifier = "Title label"
        return label
    }()
    
    /// Video presenter name label.
    private let presenterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .secondaryTitleColor
        label.accessibilityIdentifier = "Presenter name"
        return label
    }()
    
    /// Video thumbnail image view.
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = "Video thumbnail"
        return imageView
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(title: "", presenterName: "", thumbnailImage: nil)
    }
    
    private func commonInit() {
        backgroundColor = .white
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(presenterNameLabel)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        // constraints
        constrain(contentView, thumbnailImageView, titleLabel, presenterNameLabel) { (contentView, thumbnailImageView, titleLabel, presenterNameLabel) in
            // thumbnail
            thumbnailImageView.top == contentView.top
            thumbnailImageView.leading == contentView.leading
            thumbnailImageView.trailing == contentView.trailing
            thumbnailImageView.height == thumbnailImageView.width * 9/16 // aspect ratio
            
            // title
            let sidePadding: CGFloat = 16.0
            titleLabel.top == thumbnailImageView.bottom + 8.0
            titleLabel.leading == contentView.leading + sidePadding
            titleLabel.trailing == contentView.trailing - sidePadding
            
            // presenter name
            align(leading: titleLabel, presenterNameLabel)
            align(trailing: titleLabel, presenterNameLabel)
            presenterNameLabel.top == titleLabel.bottom + 4.0
            presenterNameLabel.bottom == contentView.bottom
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
    func configure(title: String, presenterName: String, thumbnailImage: UIImage?) {
        titleLabel.text = title
        presenterNameLabel.text = presenterName
        if let image = thumbnailImage {
            thumbnailImageView.image = image
        } else { // use placeholder. Or, maybe loading indicator?
            thumbnailImageView.image = nil // placeholder
        }
    }
    
    /// Update the thumbnail image.
    ///
    /// - Parameter thumbnailImage: thumbnail image.
    func update(thumbnailImage: UIImage) {
        thumbnailImageView.image = thumbnailImage
    }
    
}
