//
//  RepositoryTableViewCell.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 05/06/2022.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoUsernameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var repoStarLabel: UILabel!
    @IBOutlet weak var viewToBeHidden: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //This function configures the cell with data, called in tableView.
    func configureCell(repository: Repository, isExpand: Bool) {
        repoImageView.image = repository.userImage
        repoUsernameLabel.text = repository.username
        repoNameLabel.text = repository.name
        repoDescriptionLabel.text = repository.description
        repoLanguageLabel.text = repository.language
        repoStarLabel.text = String(describing: repository.stars)
        
        //This bool determines to view or hide the description, language and stars view.
        if isExpand {
            self.viewHeight.constant = 48
            self.viewToBeHidden.isHidden = false
        } else {
            self.viewHeight.constant = 0
            self.viewToBeHidden.isHidden = true
        }
    }
}
