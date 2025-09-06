//
//  NASAImageRepository.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 06.09.25.
//

public protocol NASAImageRepository {
    func fetchImages(page: Int, sol: Int) async throws -> MarsPhotosResponse
}
