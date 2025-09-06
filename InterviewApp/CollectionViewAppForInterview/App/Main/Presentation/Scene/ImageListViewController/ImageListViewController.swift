//
//  ImageListViewController.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 05.09.25.
//

import UIKit
import Kingfisher

class ImageListViewController: UIViewController {
    // MARK: - Private properties
    
    private let viewModel: ImageListViewModel
    private let collectionView: UICollectionView
    private var dataSource: UICollectionViewDiffableDataSource<Int, NASAPhotoCellModel>?
    private let refreshControl = UIRefreshControl()

    
    // MARK: - Init
    
    init(
        viewModel: ImageListViewModel
    ) {
        self.viewModel = viewModel
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.layout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mars Images"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupDataSource()
        setupRefresh()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Private methods
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, NASAPhotoCellModel>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as? PhotoCell
            cell?.configure(item)
            return cell
        }
    }
    
    private func setupRefresh() {
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Private methods
    
    private func loadData() {
        Task {
            await viewModel.refresh()
            applySnapshot()
        }
    }
    
    @objc private func onRefresh() {
        Task {
            await viewModel.refresh()
            refreshControl.endRefreshing()
        }
    }
    
    private func applySnapshot(animating: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NASAPhotoCellModel>()
        snapshot.appendSections([0])
        let mapped = viewModel.items.map {
            NASAPhotoCellModel(
                id: $0.id ?? 0,
                imageLink: $0.imgSrc ?? "",
                title: $0.camera?.fullName ?? "Unknown Camera",
                subtitle: $0.earthDate ?? ""
            )
        }
        snapshot.appendItems(mapped, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: animating)
    }

    
    private static func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(280)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(280)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 8, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.items[indexPath.item]
        
           let rover = RoverEntity(
               id: photo.rover?.id ?? 0,
               name: photo.rover?.name ?? "Unknown",
               landingDate: photo.rover?.landingDate ?? "",
               launchDate: photo.rover?.launchDate ?? "",
               status: photo.rover?.status ?? "unknown"
           )
        
        viewModel.navigateToDetails(imageLink: photo.imgSrc ?? "", rover: rover)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        let triggerThreshold = contentHeight * 0.8 - height
        if offsetY > triggerThreshold {
            guard let lastVisible = collectionView.indexPathsForVisibleItems.max()?.item else { return }
            Task {
                await viewModel.loadMoreIfNeeded(currentIndex: lastVisible)
                applySnapshot()
            }
        }
    }
}
