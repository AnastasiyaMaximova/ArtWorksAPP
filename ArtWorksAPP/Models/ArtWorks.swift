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
    let primaryImageSmall: String
    let artistDisplayName: String
    
    init(objectID: Int, department: String, title: String, primaryImageSmall: String, artistDisplayName: String) {
        self.objectID = objectID
        self.department = department
        self.title = title
        self.primaryImageSmall = primaryImageSmall
        self.artistDisplayName = artistDisplayName
    }
    
    init(value: [String: Any]){
        objectID = value["objectID"] as? Int ?? 0
        department = value["department"] as? String ?? ""
        title = value["title"] as? String ?? ""
        primaryImageSmall = value["primaryImageSmall"] as? String ?? ""
        artistDisplayName = value["artistDisplayName"] as? String ?? ""
    }
    
    static func getArt(value: Any)-> Art {
        guard let data = value as? [String: Any] else {
            return Art(objectID: 0, department: "", title: "", primaryImageSmall: "", artistDisplayName: "")
        }
        
        let art = Art(value: data)
        return art
    }
}

struct ArtsWithCats: Decodable {
    let objectIDs: [Int]
    
    init(objectIDs: [Int]) {
        self.objectIDs = objectIDs
    }
    
    init(value: [String: Any]){
        objectIDs = value["objectIDs"] as? [Int] ?? []
    }
    
    static func getArtsWithCats(value: Any)-> ArtsWithCats {
        guard let data = value as? [String: Any] else {
            return ArtsWithCats(objectIDs: [])
        }
        let artsWithCats = ArtsWithCats(value: data)
        return artsWithCats
    }
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
        guard let data = value as? [String: [[String: Any]]] else
        {
            return Departments(departments: [Department(departmentID: 0, displayName: "")])
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


