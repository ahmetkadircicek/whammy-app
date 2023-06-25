//
//  CartViewController.swift
//  Whammy
//
//  Created by Ahmet on 19.06.2023.
//

import UIKit

class CartViewController: UIViewController {
    
    private var guitars: [GuitarItem] = [GuitarItem]()
    
    private let addedToCartTable: UITableView = {
        let table = UITableView()
        table.register(GuitarTableViewCell.self, forCellReuseIdentifier: GuitarTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Your Cart!"
        view.addSubview(addedToCartTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemRed
        
        addedToCartTable.delegate = self
        addedToCartTable.dataSource = self
        fetchLocalStorageForCart()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("added to Cart"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForCart()
        }
    }
    
    private func fetchLocalStorageForCart(){
        DataPersistenceManager.shared.fetchingGuitarsFromDataBase { [weak self] result in
            switch result {
            case .success(let guitars):
                self?.guitars = guitars
                DispatchQueue.main.async {
                    self?.addedToCartTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addedToCartTable.frame = view.bounds
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guitars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuitarTableViewCell.identifier, for: indexPath) as? GuitarTableViewCell else {
            return UITableViewCell()
        }
        
        let guitar = guitars[indexPath.row]
        
        cell.configure(with: GuitarViewModel(guitarModel: guitar.model ?? "Unknown" , posterURL: guitar.posterPath ?? "Unknown"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteGuitarWith(model: guitars[indexPath.row]) {[weak self] result in
                switch result {
                case .success():
                    print("Deleted from the Database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.guitars.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let guitar = guitars[indexPath.row]
        let guitarId = guitar.id

        APICaller.shared.getGuitar(with: Int(guitarId)) {[weak self] result in
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
