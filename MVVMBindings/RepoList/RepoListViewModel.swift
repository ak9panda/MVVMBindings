//
//  RepoViewModel.swift
//  MVVMBindings
//
//  Created by admin on 26/09/2021.
//

import Foundation

struct RepoListViewModel {
    
    let repo: Observable<[Repo]> = Observable([])
    
    func fetchData() {
        guard let repoUrl = URL(string: "https://api.github.com/repositories") else { return }
        
        URLSession.shared.dataTask(with: repoUrl) { (data, urlResponse, error) in
            guard let result: (Result<[Repo], APIError>) = APIClient.shared.responseHandler(data: data, urlResponse: urlResponse, error: error) else {
                return
            }
            
            switch result {
            case .success(let repos):
                self.repo.value = repos.compactMap({
                    Repo(name: $0.name, owner: $0.owner)
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }.resume()
    }
}
