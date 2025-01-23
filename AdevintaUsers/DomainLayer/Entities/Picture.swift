//
//  Picture.swift
//  RandomUser
//
//  Created by Franco Bellu on 22/1/25.
//


struct Picture {
    let large: String
}

extension Picture: Identifiable, Hashable {
    var id: String { large }
}
