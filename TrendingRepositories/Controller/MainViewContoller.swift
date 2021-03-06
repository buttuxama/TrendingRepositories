//
//  MainViewController.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 04/06/2022.
//

import UIKit
import Lottie

class MainViewController: UIViewController {

    @IBOutlet weak var retryView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var tableView: UITableView!
    
    var repositoryArray: [Repository]?
    var selectedRow = 0
    var isRowExpanded = false
    var darkMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    //Main function responsible for making a call to downloadService singleton to retrieve data from the API.
    func fetchData() {
        RepositoryDownloadingService.shared.fetchTrendingRepositories { repositoriesArray, failure in
            if failure != true {
                self.repositoryArray = repositoriesArray
                self.tableView.reloadData()
            } else {
                self.retryViewLoader()
                print(failure)
            }
        }
    }
    
    //Animation support function for when the API is unreachable, another view is displayed to user.
    func retryViewLoader() {
        self.tableView.isHidden = true
        self.retryView.isHidden = false
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    //The top right Navigation Bar button is used to switch between Dark and Light mode. This function defines the mechanism.
    @IBAction func darkModeButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.windows.first
        if darkMode == false {
            appDelegate?.overrideUserInterfaceStyle = .dark
            darkMode = true
        } else {
            appDelegate?.overrideUserInterfaceStyle = .light
            darkMode = false
        }
    }
    
    //When retry button is pressed, this function is triggered to try calling the API again.
    @IBAction func retryButtonPressed(_ sender: Any) {
        retryView.isHidden = true
        tableView.isHidden = false
        fetchData()
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

