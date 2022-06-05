//
//  MainViewController.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 04/06/2022.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        RepositoryDownloadingService.shared.fetchTrendingRepositories { repositoriesArray, failure in
            print(repositoriesArray.count)
        }
    }
    
}

