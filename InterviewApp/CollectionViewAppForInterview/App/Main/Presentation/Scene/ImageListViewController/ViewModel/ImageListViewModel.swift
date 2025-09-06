//
//  ImageListViewModel.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 05.09.25.
//

import Foundation

@MainActor
final class ImageListViewModel {
    // MARK: - Error
    
    enum State: Equatable { case idle, loading, loaded, error(String) }
    
    // MARK: - Private properties
    
    private let imageUseCase: NASAImageUseCase
    private let coordinator: ImageListCoordinator
    
    // MARK: - Outputs
    
    private(set) var items: [Photo] = []
    private(set) var state: State = .idle
    private(set) var canLoadMore: Bool = true
    
    // MARK: - Pagination
    
    private var page = 1
    private let sol = 1000
    
    // MARK: - Init
    
    init(
        imageUseCase: NASAImageUseCase,
        coordinator: ImageListCoordinator
    ) {
        self.imageUseCase = imageUseCase
        self.coordinator = coordinator
    }
    
    // MARK: - Public methods
    
    func refresh() async {
        state = .loading
        page = 1
        canLoadMore = true
        do {
            let response = try await imageUseCase.fetchImages(page: page, sol: sol)
            items = response.photos ?? []
            state = .loaded
            canLoadMore = !(response.photos?.isEmpty ?? true)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadMoreIfNeeded(currentIndex: Int) async {
        guard canLoadMore, state != .loading else { return }
        let threshold = items.count - 6
        if currentIndex >= max(threshold, 0) {
            await loadNextPage()
        }
    }
    
//    func loadMoreIfPossible(currentIndex: Int) async {
//        guard canLoadMore, state != .loading else { return }
//        guard currentIndex => items.count - 5 else { return }
//        Task { await loadNextPage() }
//    }
    
    public func navigateToDetails(imageLink: String, rover: RoverEntity) {
        coordinator.navigateToDetails(imageLink: imageLink, rover: rover)
    }
    
    // MARK: - Private methods
    
    private func loadNextPage() async {
        state = .loading
        page += 1
        do {
            let response = try await imageUseCase.fetchImages(page: page, sol: sol)
            items.append(contentsOf: response.photos ?? [])
            state = .loaded
            canLoadMore = !(response.photos?.isEmpty ?? true)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
