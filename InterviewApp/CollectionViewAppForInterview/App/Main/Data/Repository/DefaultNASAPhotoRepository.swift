//
//  DefaultNASAPhotoRepository.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 06.09.25.
//

import Foundation

public struct DefaultNASAPhotoRepository: NASAImageRepository {
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    
    init(
        networkService: NetworkServiceProtocol
    ) {
        self.networkService = networkService
    }
    
    // MARK: - Public methods
    
    public func fetchImages(page: Int, sol: Int) async throws -> MarsPhotosResponse {
        guard let url = URL(string: Endpoint.fetchImages(page: page, sol: sol)) else {
            throw URLError(.badURL)
        }
        return try await networkService.get(url)
    }
}

// MARK: - Extension

extension DefaultNASAPhotoRepository {
    enum Endpoint {
        static func fetchImages(page: Int, sol: Int) -> String { "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=\(sol)&page=\(page)&api_key=\(Constants.apiKeyForMarsPhotos.rawValue)"
        }
    }
}
