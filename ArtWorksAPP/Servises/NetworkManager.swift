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
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, AFError>)-> Void) {
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
    
//    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>)-> Void) {
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: url) else {
//                completion(.failure(.noData))
//                return
//            }
//            DispatchQueue.main.async {
//                completion(.success(imageData))
//            }
//        }
//    }
    
    func fetch<T:Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, NetworkError>)-> Void){
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print(error ?? "No error description")
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.sync {
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchDepartments (from url: URL, completion: @escaping (Result<Departments, AFError>)-> Void){
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
}
    
enum Link {
    case artDepartments
    case artWithCats(Int)
    case art(Int)
    case fotoOfCat
        
    var url: URL {
        switch self {
        case .artDepartments:
            return URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/departments")!
        case .artWithCats(let departmentId):
            return URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/search?departmentId=\(departmentId)&hasImages=true&q=cat")!
        case .art(let objectID):
            return URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(objectID)")!
        case .fotoOfCat:
            return URL(string: "https://images.metmuseum.org/CRDImages/eg/web-large/45.4.6_EGDP014408.jpg")!
        }
    }
}

