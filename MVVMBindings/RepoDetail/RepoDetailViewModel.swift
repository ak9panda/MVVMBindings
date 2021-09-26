//
//  RepoDetailViewModel.swift
//  MVVMBindings
//
//  Created by admin on 26/09/2021.
//

import Foundation

struct RepoDetailViewModel {
    
    let branch: Observable<[Branch]> = Observable([])
    
    func fetchData(ownerName: String, repoName: String) {
        guard let branchUrl = URL(string: "https://api.github.com/repos/\(ownerName)/\(repoName)/branches") else { return }
        URLSession.shared.dataTask(with: branchUrl) { (data, urlResponse, error) in
            guard let result: (Result<[Branch], APIError>) = APIClient.shared.responseHandler(data: data, urlResponse: urlResponse, error: error) else {
                return
            }
            
            switch result {
            case.success(let branches):
                self.branch.value = branches.compactMap({
                    Branch(name: $0.name)
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }.resume()
    }
}
