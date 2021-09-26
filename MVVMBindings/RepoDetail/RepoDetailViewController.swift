//
//  RepoDetailViewController.swift
//  MVVMBindings
//
//  Created by admin on 26/09/2021.
//

import UIKit

class RepoDetailViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var repoData: [String] = []
    var repoName: String = ""
    var ownerName: String = ""
    
    private var viewModel = RepoDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        if repoData.count > 0 {
            repoName = repoData[0]
            ownerName = repoData[1]
            navigationItem.title = repoName + "/" + ownerName
        }
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        viewModel.branch.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.fetchData(ownerName: ownerName, repoName: repoName)
    }

}

extension RepoDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.branch.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.branch.value?[indexPath.row].name
        return cell
    }
    
    
}
