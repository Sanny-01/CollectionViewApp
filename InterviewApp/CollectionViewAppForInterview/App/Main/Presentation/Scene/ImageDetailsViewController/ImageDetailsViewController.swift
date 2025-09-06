//
//  ImageDetailsViewController.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 06.09.25.
//

import UIKit

final class ImageDetailsViewController: UIViewController {
    // MARK: - Private properties
    
    private let imageLink: String
    private let rover: RoverEntity
    
    // MARK: - UI components
    
    private let imageView = UIImageView()
    private let infoLabel = UILabel()
    
    // MARK: - Init
    
    init(imageLink: String, rover: RoverEntity) {
        self.imageLink = imageLink
        self.rover = rover
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        configure()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configure() {
        imageView.kf.setImage(with: URL(string: imageLink))
        infoLabel.text = """
               Rover Name: \(rover.name)
               ID: \(rover.id)
               Landing Date: \(rover.landingDate)
               Launch Date: \(rover.launchDate)
               Status: \(rover.status)
               """
    }
}
