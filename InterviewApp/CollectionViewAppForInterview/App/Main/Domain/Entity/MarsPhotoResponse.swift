//
//  MarsPhotosResponse.swift
//  CollectionViewAppForInterview
//
//  Created by sgiorgishvili on 06.09.25.
//

import Foundation

public struct MarsPhotosResponse: Decodable {
    let photos: [Photo]?
}

struct Photo: Decodable {
    let id: Int?
    let sol: Int?
    let camera: Camera?
    let imgSrc: String?
    let earthDate: String?
    let rover: Rover?

    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

struct Camera: Decodable {
    let id: Int?
    let name: String?
    let roverID: Int?
    let fullName: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case roverID = "rover_id"
        case fullName = "full_name"
    }
}

struct Rover: Decodable {
    let id: Int?
    let name: String?
    let landingDate: String?
    let launchDate: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case landingDate = "landing_date"
        case launchDate = "launch_date"
    }
}
