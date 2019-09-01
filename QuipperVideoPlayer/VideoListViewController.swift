//
//  VideoListViewController.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/28.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit
import Cartography

protocol VideoListViewControllerDelegate: class {
    /// This is called when the user selects a specific Video.
    ///
    /// - Parameters:
    ///   - videoInfo: The selected video information object.
    ///   - viewController: The view controller in which the selection happend in.
    func didSelect(_ videoInfo: VideoInfo, viewController: VideoListViewController)
}

class VideoListViewController: UIViewController {

    weak var delegate: VideoListViewControllerDelegate?
    
    private lazy var viewModel: VideoListViewModel = {
        let viewModel = VideoListViewModel()
        viewModel.dataChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        return viewModel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = TopAlignedCollectionViewFlowLayout()
        // ensure self sizing cells
        flowLayout.estimatedItemSize = CGSize(width: view.bounds.width, height: 100)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 20)
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Sample Videos"
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        // view setup
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        // register cells
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: String(describing: VideoCell.self))
        // constraints
        constrain(view, collectionView) { (view, collectionView) in
            collectionView.edges == view.edges
        }
        // dataSource & delegate
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

//
// MARK: - UICollectionViewDataSource
//
extension VideoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfVideos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoCell.self), for: indexPath) as? VideoCell else {
            return VideoCell()
        }
        let title = viewModel.videoTitle(at: indexPath)
        let presenterName = viewModel.videoPresenterName(at: indexPath)
        let url = viewModel.videoThumbnailURL(at: indexPath)
        let duration = viewModel.videoDuration(at: indexPath)
        let description = viewModel.videoDescription(at: indexPath)
        cell.configure(title: title, presenterName: presenterName, videoDescription: description, videoDuration: duration, thumbnailImageURL: url)
        
        return cell
    }
}

//
// MARK: - UICollectionViewDelegateFlowLayout
//
extension VideoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoInfo = viewModel.videoInfo(at: indexPath)
        delegate?.didSelect(videoInfo, viewController: self)
    }
}
