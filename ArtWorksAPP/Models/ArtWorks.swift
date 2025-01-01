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
    
    init(departmentID: Int, displayName: String) {
        self.departmentId = departmentID
        self.displayName = displayName
    }
    
    init(value: [String: Any]){
        departmentId = value["departmentId"] as? Int ?? 0
        displayName = value["displayName"] as? String ?? ""
    }
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
    var departments: [Department]
    
    
    init (departments: [Department]){
        self.departments = departments
    }
    
    init(value: [String: Any]) {
        departments = value ["departments"] as? [Department] ?? []
    }
    
    static func getDepartments(value: Any) -> Departments {
        guard let data = value as? [String: [[String: Any]]] else {return Departments(departments: [Department(departmentID: 0, displayName: "thjt")])
        }
        var departments = Departments(departments: [])
        for value in data {
            value.value.forEach { value in
                let department = Department(value: value)
                departments.departments.append(department)
            }
        }
        return departments
    }
}


