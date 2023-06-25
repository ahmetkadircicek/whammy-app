//
//  SearchViewController.swift
//  Whammy
//
//  Created by Ahmet on 19.06.2023.
//

import UIKit

class SearchViewController: UIViewController {

    private var guitars: [Guitar] = [Guitar]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(GuitarTableViewCell.self, forCellReuseIdentifier: GuitarTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a guitar"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .systemRed
        
        fetchDiscoverGuitars()
        
        searchController.searchResultsUpdater = self
    }
    
    private func fetchDiscoverGuitars(){
        APICaller.shared.getDiscoverGuitars { [weak self] result in
            switch result {
            case .success(let guitars):
                self?.guitars = guitars
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        discoverTable.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guitars.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuitarTableViewCell.identifier, for: indexPath) as? GuitarTableViewCell else {
            return UITableViewCell()
        }
        
        let guitar = guitars[indexPath.row]
        let model = GuitarViewModel(guitarModel: guitar.model, posterURL: guitar.posterPath ?? "Unknown")
        cell.configure(with: model)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let guitar = guitars[indexPath.row]
        let guitarId = guitar.id

        APICaller.shared.getGuitar(with: guitarId) {[weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let vc = GuitarPreviewViewController()
                    vc.configure(with: GuitarPreviewViewModel(guitarName: self?.guitars[indexPath.row].model ?? "Unknown", guitarOverview: self?.guitars[indexPath.row].model ?? "Unknown", imagePath: self?.guitars[indexPath.row].posterPath ?? "Unknown"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 2,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                return
              }
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let guitars):
                    resultsController.guitars = guitars
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: GuitarPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = GuitarPreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
