//
//  ViewController.swift
//  MVVMBindings
//
//  Created by admin on 19/09/2021.
//

import UIKit

class RepoListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = RepoListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Github Public"
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.repo.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRepoDetail" {
            if let detail = segue.destination as? RepoDetailViewController {
                if let data = sender as? [String] {
                    detail.repoData = data
                }
            }
        }
    }
}

extension RepoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = viewModel.repo.value?.count ?? 0
//        let rows = count < 10 ? count : 10
        return viewModel.repo.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let repo = viewModel.repo.value?[indexPath.row]
        cell.textLabel?.text = repo!.name + "/" + repo!.owner.login
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data: [String] = []
        if let repo = viewModel.repo.value?[indexPath.row] {
            data.append(repo.name)
            data.append(repo.owner.login)
        }
        self.performSegue(withIdentifier: "toRepoDetail", sender: data)
    }
}
