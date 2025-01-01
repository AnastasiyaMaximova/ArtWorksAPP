//
//  NetworkManager.swift
//  ArtWorksAPP
//
//  Created by Anastasya Maximova on 18.12.2024.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init () {}
    
    func fetchImage(from url: String, completion: @escaping (Result<Data, AFError>)-> Void) {
        AF.request(url)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchDepartments(from url: String, completion: @escaping(Result<Departments, AFError>)-> Void){
        AF.request(url)
            .validate()
            .responseJSON { dataresponse in
                switch dataresponse.result {
                case .success(let value):
                    let departments = Departments.getDepartments(value: value)
                    completion(.success(departments))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchArt(from url: String, completion: @escaping(Result<Art,AFError>)-> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let art = Art.getArt(value: value)
                    completion(.success(art))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchArtsWithCats(from url: String, completion: @escaping(Result<ArtsWithCats,AFError>)-> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let artsWithCats = ArtsWithCats.getArtsWithCats(value: value)
                    completion(.success(artsWithCats))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
    
enum Link {
    case artDepartments
    case artWithCats(Int)
    case art(Int)
    case fotoOfCat
        
    var url: String {
        switch self {
        case .artDepartments:
            return "https://collectionapi.metmuseum.org/public/collection/v1/departments"
        case .artWithCats(let departmentId):
            return "https://collectionapi.metmuseum.org/public/collection/v1/search?departmentId=\(departmentId)&hasImages=true&q=cat"
        case .art(let objectID):
            return "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(objectID)"
        case .fotoOfCat:
            return "https://images.metmuseum.org/CRDImages/eg/web-large/45.4.6_EGDP014408.jpg"
        }
    }
}

