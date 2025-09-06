//
//  ImageListCoordinator.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 06.09.25.
//

@MainActor
public protocol ImageListCoordinator {
    func start()
    func navigateToDetails(imageLink: String, rover: RoverEntity)
}
