//
//  NASAPhotoCellModel.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 05.09.25.
//

struct NASAPhotoCellModel: Hashable {
    let id: Int
    let imageLink: String
    let title: String
    let subtitle: String
    
    init(
        id: Int,
        imageLink: String,
        title: String,
        subtitle: String
    ) {
        self.id = id
        self.imageLink = imageLink
        self.title = title
        self.subtitle = subtitle
    }
}
