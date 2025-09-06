//
//  DefaultImageListCoordinator.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 06.09.25.
//

import UIKit

final class DefaultImageListCoordinator: ImageListCoordinator {
    // MARK: - Public properties
    
    private let navigationController: UINavigationController
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    @MainActor
    func start() {
        let imageListViewController = ImageListConfigurator.configureImageList(coordinator: self)
        
        navigationController.pushViewController(imageListViewController, animated: true)
    }
    
    func navigateToDetails(imageLink: String, rover: RoverEntity) {
        let imageDetailsViewController = ImageListConfigurator.configureDetails(
            imageLink: imageLink,
            rover: rover
        )
        
        navigationController.pushViewController(imageDetailsViewController, animated: true)
    }
}
