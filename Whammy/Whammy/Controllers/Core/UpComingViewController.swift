//
//  UpComingViewController.swift
//  Whammy
//
//  Created by Ahmet on 19.06.2023.
//

import UIKit

class UpComingViewController: UIViewController {
    
    private var guitars: [Guitar] = [Guitar]()

    private let upComingTable: UITableView = {
        let table = UITableView()
        table.register(GuitarTableViewCell.self, forCellReuseIdentifier: GuitarTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Up Coming!"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemRed
        
        view.addSubview(upComingTable)
        upComingTable.delegate = self
        upComingTable.dataSource = self
        fetchUpComing()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTable.frame = view.bounds
    }
    
    private func fetchUpComing(){
        APICaller.shared.getUpComingGuitars{[weak self] result in
            switch result {
            case .success(let guitars):
                self?.guitars = guitars
                DispatchQueue.main.async {
                    self?.upComingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpComingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guitars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuitarTableViewCell.identifier, for: indexPath) as? GuitarTableViewCell else {
            return UITableViewCell()
        }
        
        let guitar = guitars[indexPath.row]
        
        cell.configure(with: GuitarViewModel(guitarModel: guitar.model , posterURL: guitar.posterPath ?? "Unknown"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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


