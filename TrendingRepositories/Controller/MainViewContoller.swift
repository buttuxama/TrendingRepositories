//
//  MainViewController.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 04/06/2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var repositoryArray: [Repository]?
    var selectedRow = 0
    var isRowExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    func fetchData() {
        RepositoryDownloadingService.shared.fetchTrendingRepositories { repositoriesArray, failure in
            if !failure {
                self.repositoryArray = repositoriesArray
                self.tableView.reloadData()
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoCellIdentifier, for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
        
        if repositoryArray != nil {
            cell.hideShimmerEffect()            //hides the shimmer effect.
            if indexPath.row == selectedRow {
                isRowExpanded = true
            } else {
                isRowExpanded = false
            }
            cell.configureCell(repository: repositoryArray![indexPath.row], isExpand: isRowExpanded)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositoryArray?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.reloadData()
    }
    
}

