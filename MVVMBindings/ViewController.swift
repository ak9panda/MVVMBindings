//
//  ViewController.swift
//  MVVMBindings
//
//  Created by admin on 19/09/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = RepoListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        viewModel.repos.bind { [weak self] data in
            DispatchQueue.main.async {
                self?.navigationItem.title = (data?.owner.login ?? "") + "/" + (data?.name ?? "")
            }
        }
        
        viewModel.branch.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        fetchData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.branch.value?.count ?? 0
        let rows = count < 10 ? count : 10
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.branch.value?[indexPath.row].name
        return cell
    }
    
    func fetchData() {
        guard let repoUrl = URL(string: "https://api.github.com/repositories") else { return }
        
        URLSession.shared.dataTask(with: repoUrl) { (data, _, _) in
            guard let data = data else { return }
            do {
                let repoModels = try JSONDecoder().decode([Repo].self, from: data)
                let randomNum = Int.random(in: 0...50)
                let repo = repoModels[randomNum]
                guard let branchUrl = URL(string: "https://api.github.com/repos/\(repo.owner.login)/\(repo.name)/branches") else { return }
                URLSession.shared.dataTask(with: branchUrl) { (data, _, _) in
                    guard let data = data, let decoded = try? JSONDecoder().decode([Branch].self, from: data) else {
                        return
                    }
                    
                    self.viewModel.repos.value = Repo(name: repo.name, owner: repo.owner)
                    self.viewModel.branch.value = decoded.compactMap({
                        Branch(name: $0.name)
                    })
                }.resume()
            }catch {
                
            }
        }.resume()
    }

}
