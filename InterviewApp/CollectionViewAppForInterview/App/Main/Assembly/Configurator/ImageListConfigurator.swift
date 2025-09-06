//
//  ImageListConfigurator.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 06.09.25.
//

@MainActor
public enum ImageListConfigurator {
    static func configureImageList(coordinator: ImageListCoordinator) -> ImageListViewController {
        let networkService = NetworkService()
        let repository = DefaultNASAPhotoRepository(networkService: networkService)
        let useCase = DefaultNASAImageUseCase(repository: repository)
        let viewModel = ImageListViewModel(imageUseCase: useCase, coordinator: coordinator)
        let viewController = ImageListViewController(viewModel: viewModel)
        
        return viewController
    }
    
    static func configureDetails(imageLink: String, rover: RoverEntity) -> ImageDetailsViewController {
        let viewController = ImageDetailsViewController(imageLink: imageLink, rover: rover)
        
        return viewController
    }
}
