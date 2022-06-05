//
//  Repository.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 05/06/2022.
//

import Foundation
import UIKit

struct Repository {
    public private(set) var name: String
    public private(set) var username: String
    public private(set) var description: String
    public private(set) var language: String
    public private(set) var stars: Int
    public private(set) var userImage: UIImage
    
    
    init(repoName: String, repoUsername: String, repoDescription: String, repoLanguage: String, repoStars: Int, repoImage: UIImage) {
        self.name = repoName
        self.username = repoUsername
        self.description = repoDescription
        self.language = repoLanguage
        self.stars = repoStars
        self.userImage = repoImage
    }
    
}
