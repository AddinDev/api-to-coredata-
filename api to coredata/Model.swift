//
//  Model.swift
//  api to coredata
//
//  Created by addin on 23/12/20.
//

import Foundation

//hadits
struct HaditsContainer: Codable {
    let data: Haditses
}

struct Haditses: Codable {
    let the1: Hadits

    enum CodingKeys: String, CodingKey {
        case the1 = "1"
    }
}

struct Hadits: Identifiable, Codable, Equatable {
    let id = UUID()
    let haditsId, nass, terjemah: String
    
    enum CodingKeys: String, CodingKey {
        case haditsId = "id"
        case nass
        case terjemah

    }
}
