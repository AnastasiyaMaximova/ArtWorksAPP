//
//  ArtWorksTableViewController.swift
//  ArtWorksAPP
//
//  Created by Anastasya Maximova on 18.12.2024.
//

import UIKit

final class ArtDepartmentsTableViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var artDepartments = [Department]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDepartments()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let artWithCatVC = segue.destination as? ArtWithCatsListController
        artWithCatVC?.department = artDepartments[indexPath.row]
    }
}

extension ArtDepartmentsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        artDepartments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCell") else {
            return UITableViewCell()
        }
        let department = artDepartments[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(department.departmentId). \(department.displayName)"
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - Networking
extension ArtDepartmentsTableViewController {
    private func fetchDepartments () {
        networkManager.fetchDepartments { [weak self] departments in
            guard let self else {return}
            artDepartments = departments
            tableView.reloadData()
        }
    }
}


                                        
