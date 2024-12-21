//
//  NetworkManager.swift
//  ArtWorksAPP
//
//  Created by Anastasya Maximova on 18.12.2024.
//

import Foundation
final class NetworkManager {
    static let shared = NetworkManager()
    private init () {}
    
    func fetchDepartments (completion: @escaping ([Department]) -> Void) {
        URLSession.shared.dataTask(with: Link.artDepartments.url) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "Not error description")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let departments = try decoder.decode(Departments.self, from: data)
                DispatchQueue.main.async {
                    completion(departments.departments)
                }
            } catch {
                print(error.localizedDescription)
            }
        } .resume()
    }
    
    func fetchArtWithCats (completion: @escaping ([Int]) -> Void) {
        URLSession.shared.dataTask(with: Link.artWithCats.url){ data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "Not error description")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let artWithCats = try decoder.decode(ArtsWithCats.self, from: data)
                DispatchQueue.main.async {
                    completion(artWithCats.objectIDs)
                }
            } catch {
                print(error.localizedDescription)
            }
        } .resume()
    }
    
    func fetchArt(completion: @escaping (Art) -> Void) {
        URLSession.shared.dataTask(with: Link.art.url){ data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "Not error description")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let art = try decoder.decode(Art.self, from: data)
                DispatchQueue.main.async {
                    completion(art.self)
                }
            } catch {
                print(error.localizedDescription)
            }
        } .resume()
    }
}

//MARK: - Link
extension NetworkManager {
    enum Link {
        case artDepartments
        case artWithCats
        case art
        
        var url: URL {
            switch self {
            case .artDepartments:
                return URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/departments")!
            case .artWithCats:
                return URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/search?departmentId=11&hasImages=true&q=cat")!
            case .art:
                return URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/435852")!
            }
        }
    }
}
