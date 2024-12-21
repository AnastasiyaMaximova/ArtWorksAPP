//
//  ArtWorks.swift
//  ArtWorksAPP
//
//  Created by Anastasya Maximova on 18.12.2024.
//

import Foundation


struct Department: Decodable {
    let departmentId: Int
    let displayName: String
}

struct Art: Decodable {
    let objectID: Int
    let department: String
    let title: String
    let primaryImageSmall: URL
    let artistDisplayName: String
}

struct ArtsWithCats: Decodable {
    let objectIDs: [Int]
}

struct Departments: Decodable {
    let departments: [Department]
}
