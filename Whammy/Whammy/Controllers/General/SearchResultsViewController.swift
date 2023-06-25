//
//  SearchResultsViewController.swift
//  Whammy
//
//  Created by Ahmet on 21.06.2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: GuitarPreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var guitars: [Guitar] = [Guitar]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?

    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout ( )
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 5, height: 300)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GuitarCollectionViewCell.self, forCellWithReuseIdentifier: GuitarCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        searchResultsCollectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guitars.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuitarCollectionViewCell.identifier, for: indexPath) as? GuitarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let guitar = guitars[indexPath.row]
        

        cell.configure(with: guitar.posterPath ?? "Unknown")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let guitar = guitars[indexPath.row]
        let guitarId = guitar.id
        
        APICaller.shared.getGuitar(with: guitarId) {[weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.searchResultsViewControllerDidTapItem(GuitarPreviewViewModel(guitarName: self?.guitars[indexPath.row].model ?? "Unknown", guitarOverview: self?.guitars[indexPath.row].model ?? "Unknown", imagePath: self?.guitars[indexPath.row].posterPath ?? "Unknown"))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
