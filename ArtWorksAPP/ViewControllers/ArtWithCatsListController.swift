//
//  ArtWithCatListController.swift
//  ArtWorksAPP
//
//  Created by Anastasya Maximova on 21.12.2024.
//

import UIKit

final class ArtWithCatsListController: UITableViewController {
    
    var department: Department!
    private let networkManager = NetworkManager.shared
    private var artsWithCats = [Int]()
    private var arts = [Art]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        navigationItem.title = department.displayName
        fetchArtsWithCats()
        fetchArt()
    }
}

extension ArtWithCatsListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "artWithCat") else {
            return UITableViewCell()
        }
        
        let art = arts[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = art.title
        content.secondaryText = art.artistDisplayName
        cell.contentConfiguration = content
        
        networkManager.fetchImage(from: art.primaryImageSmall) { result in
            switch result {
            case .success(let imageData):
                content.image = UIImage(data: imageData)
                cell.contentConfiguration = content
            case .failure(let error):
                
                //загрузить дефолтную картинку
                print(error)
            }
        }
        return cell
    }
}
//MARK: - Networking
extension ArtWithCatsListController {
    private func fetchArtsWithCats() {
        networkManager.fetchArtWithCats { [weak self] artWithCats in
            guard let self else {return}
            artsWithCats = artWithCats
            print(artsWithCats)
        }
    }
    
    private func fetchArt() {
        networkManager.fetchArt { [weak self] art in
            guard let self else {return}
            let art = art
            arts.append(art)
            print(arts)
            tableView.reloadData()
        }
    }
}

