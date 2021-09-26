//
//  RepoModels.swift
//  MVVMBindings
//
//  Created by admin on 26/09/2021.
//

import Foundation

struct Repo: Codable {
    let name: String
    let owner: Owner
}

struct Owner: Codable {
    let login: String
}

struct Branch: Codable {
    let name: String
}
