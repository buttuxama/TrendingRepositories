//
//  RepositoryDownloadingService.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 05/06/2022.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class RepositoryDownloadingService {
    
    static let shared = RepositoryDownloadingService()
    
    private init() {}
    
    //Since the data returned from API is JSON and it contains dictionaries of all of the repositories, this function fetches the dictionaries and appends it an array of those dictionaries.
    func downloadTrendingReposAsArrayOfDictionary(completion: @escaping (_ dictArrayRepos: [Dictionary<String, Any>], _ failure: Bool) -> ()) {
        var reposDictArray = [Dictionary<String, Any>]()
        AF.request(URL).responseDecodable(of: JSON.self) { (response) in
            switch response.result {
            case .success(let json):
                let jsonData = JSON(json).dictionaryObject              //Fetch the dictionary from the api.
                guard let repoDictionaryArray = jsonData?["items"] as? [Dictionary<String, Any>] else { return } //getting different repositories as array of dictionaries from object captured from API.
                for dict in repoDictionaryArray {           //getting only those repositiories which have all the information that we need.
                    guard let repoName = dict["name"] as? String,
                          let repoDescription = dict["description"] as? String,
                          let repoLanguage = dict["language"] as? String,
                          let repoStars = dict["stargazers_count"] as? Int,
                          let ownerDict = dict["owner"] as? Dictionary<String, Any>,
                          let repoUsername = ownerDict["login"] as? String,
                          let repoAvatarUrl = ownerDict["avatar_url"] as? String else { continue }
                    //1.
                    let repoDictionary: Dictionary<String, Any> = ["name": repoName, "login": repoUsername, "description": repoDescription, "language": repoLanguage, "stargazers_count": repoStars, "avatar_url": repoAvatarUrl]
                    reposDictArray.append(repoDictionary)
                }
                completion(reposDictArray, false)
                
            case .failure(let error):
                print(error.localizedDescription, "The array of dictionary of repositories could be created.") //sending the error in case if we can't reach the API in the first place.
                completion([], true)
            }
        }
    }
    
    func downloadImage(for avatarUrl: String, completion: @escaping (_ image: UIImage, _ failure: Bool) -> ()) {
        AF.request(avatarUrl).responseImage { response in           //Downloading the image from the avatar_url property.
            if case .success(let image) = response.result {
                completion(image, false)
            } else {
                print("image could not be loaded.")
                completion(UIImage(), true)                         // propagating the error if the image cannot be downloaded for any reason.
            }
        }
    }
    //This function creates the model for repository from the dictionary provided in the downloadTrendingReposAsArrayOfDictionary function. 1.
    func getTrendingRepository(from dictionary: Dictionary<String, Any>, completion: @escaping (_ repository: Repository?, _ failure: Bool) -> ()) {
        let repoName = dictionary["name"] as! String
        let repoUsername = dictionary["login"] as! String
        let repoDescription = dictionary["description"] as! String
        let repoLanguage = dictionary["language"] as! String
        let repoStars = dictionary["stargazers_count"] as! Int
        let repoAvatarUrl = dictionary["avatar_url"] as! String
        
        downloadImage(for: repoAvatarUrl) { image, failure in
            if !failure {
                let repo = Repository(repoName: repoName, repoUsername: repoUsername, repoDescription: repoDescription, repoLanguage: repoLanguage, repoStars: repoStars, repoImage: image)
                completion(repo, false)
            } else {
                print("Repo could not be created because of image.")
                completion(nil, true)       //The error sent from downloadImage function is captured here and propagated again.
            }
        }
    }
    //This function is called to create the array of repositories, it first dwonloads the repositories using downloadTrendingReposAsArrayOfDictionary function and then getTrendingRepositories to append the repos in the array and return it.
    func fetchTrendingRepositories(completion: @escaping (_ repositoriesArray: [Repository], _ failure: Bool) -> ()) {
        var repositoriesArray = [Repository]()
        downloadTrendingReposAsArrayOfDictionary { dictArrayRepos, failure in
            if !failure {
                for dictionary in dictArrayRepos {
                    self.getTrendingRepository(from: dictionary) { repository, failure in
                        if repositoriesArray.count < dictArrayRepos.count - 1 {
                            guard let repo = repository else { return }
                            repositoriesArray.append(repo)
                        } else {
                            completion(repositoriesArray, false)
                        }
                    }
                }
            } else {
                print("The repositories could not be fetched.")
                completion([], false)                               //The error is sent from here to controller which comes from either of the functions above.
            }
        }
    }
    
}
