//
//  PictureDTO.swift
//  RandomUser
//
//  Created by Franco Bellu on 22/1/25.
//


import Foundation

struct PictureDTO: Codable {
    let large: String

    init(from picture: Picture) {
        self.large = picture.large
    }

    func toDomain() -> Picture {
        Picture(large: large)
    }
}