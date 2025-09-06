//
//  NASAImageUseCase.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 05.09.25.
//

public protocol NASAImageUseCase {
    func fetchImages(page: Int, sol: Int) async throws -> MarsPhotosResponse
}

public struct DefaultNASAImageUseCase: NASAImageUseCase {
    // MARK: - Fields
    
    private var repository: NASAImageRepository
    
    // MARK: - Init
    
    public init(repository: NASAImageRepository) {
        self.repository = repository
    }
    
    // MARK: - Public methods
    
    public func fetchImages(page: Int, sol: Int) async throws -> MarsPhotosResponse {
        try await repository.fetchImages(page: page, sol: sol)
    }
}
