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
    private var artsWithCats: [Int] = []
    private var arts: [Art] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        navigationItem.title = department.displayName
        
        fetchArtsWithCats()
        loadArts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupActivityIndicator(in: view)
    }
    
    private func setupActivityIndicator(in view: UIView) {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    private func loadArts() {
        if arts.isEmpty{
            activityIndicator.startAnimating()
        }

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
        content.imageProperties.maximumSize.width = 200
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        
        networkManager.fetchImage(from: art.primaryImageSmall) {[weak self, weak cell] result in
            guard let self = self, let cell = cell else {return}
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    if self.tableView.indexPath(for: cell) == indexPath {
                        content.image = UIImage(data: imageData)
                        cell.contentConfiguration = content
                    }
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
}
//MARK: - Networking
extension ArtWithCatsListController {
    private func fetchArtsWithCats(){
        networkManager.fetchArtsWithCats(from: Link.artWithCats(department.departmentId).url) {[weak self] result in
            guard let self else {return}
            switch result{
            case .success(let artWithCats):
                artsWithCats = artWithCats.objectIDs
                tableView.reloadData()
                fetchArt()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchArt() {
        let dispatchGroup = DispatchGroup()
        var fetchedArts: [Art] = []
        
        for objectID in  artsWithCats {
            dispatchGroup.enter()
            networkManager.fetchArt(from: Link.art(objectID).url) {[weak self] result in
                defer {dispatchGroup.leave()}
                guard let self else {return}
                switch result{
                case .success(let art):
                    fetchedArts.append(art.self)
                    tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {[weak self] in
            guard let self else {return}
            arts = fetchedArts.filter { !$0.title.isEmpty}
            arts = fetchedArts.filter {!$0.primaryImageSmall.isEmpty}
            tableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
}

