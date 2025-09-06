//
//  NASAPhotosCell.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 05.09.25.
//


import UIKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {
    // MARK: - Reuse id
    
    static let reuseID = "PhotoCell"

    // MARK: - UI Elements
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(subtitleLabel)

        containerStack.addArrangedSubview(imageView)
        containerStack.addArrangedSubview(infoStack)
        contentView.addSubview(containerStack)

        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75)
        ])
    }

    // MARK: - Configure
    
    func configure(_ model: NASAPhotoCellModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle

        guard let url = URL(string: model.imageLink) else {
            imageView.image = nil
            return
        }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(DownsamplingImageProcessor(size: imageView.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage,
                .backgroundDecode
            ]
        )
    }
}
