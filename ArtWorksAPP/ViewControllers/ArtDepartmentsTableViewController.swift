//
//  ArtWorksTableViewController.swift
//  ArtWorksAPP
//
//  Created by Anastasya Maximova on 18.12.2024.
//

import UIKit

final class ArtDepartmentsTableViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var artDepartments: [Department] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        fetchDepartments()
        networkManager.fetchImage(from: Link.fotoOfCat.url) {[weak self] result in
            guard let self else {return}
            switch result {
            case .success(let data):
                view.backgroundColor = UIColor(patternImage: UIImage(data: data)!)
            case .failure(let error):
                print(error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let artWithCatVC = segue.destination as? ArtWithCatsListController
        let department = artDepartments[indexPath.row]
        artWithCatVC?.department = department
    }
}

extension ArtDepartmentsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return artDepartments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCell") else {
            return UITableViewCell()
        }
        let department = artDepartments[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = department.displayName
        //content.textProperties.color = .black
        content.textProperties.font = .boldSystemFont(ofSize: 18)
        cell.contentConfiguration = content
        return cell
    }
    
}

//MARK: - Networking
extension ArtDepartmentsTableViewController {
    private func fetchDepartments() {
        networkManager.fetch(Departments.self, from: Link.artDepartments.url ) {[unowned self] result in
            switch result {
            case .success(let departments):
                artDepartments = departments.departments
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}


                                        
