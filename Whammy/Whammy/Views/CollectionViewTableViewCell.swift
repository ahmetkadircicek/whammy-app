//
//  CollectionViewTableViewCell.swift
//  Whammy
//
//  Created by Ahmet on 19.06.2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: GuitarPreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var guitars: [Guitar] = [Guitar]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GuitarCollectionViewCell.self, forCellWithReuseIdentifier: GuitarCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with guitars: [Guitar]){
        self.guitars = guitars
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func addCartGuitar(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.addCartGuitarWith(model: guitars[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("added to Cart"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuitarCollectionViewCell.identifier, for: indexPath) as? GuitarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = guitars[indexPath.row].posterPath else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guitars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let guitar = guitars[indexPath.row]
        let guitarId = guitar.id

        APICaller.shared.getGuitar(with: guitarId) {[weak self] result in
            switch result {
            case .success(_):
                guard let strongSelf = self else {
                    return
                }
                let viewModel = GuitarPreviewViewModel(guitarName: self?.guitars[indexPath.row].model ?? "Unknown", guitarOverview: self?.guitars[indexPath.row].model ?? "Unknown", imagePath: self?.guitars[indexPath.row].posterPath ?? "Unknown")
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Add Cart", image: nil, identifier: nil,
                    discoverabilityTitle: nil, attributes: [], state: .off) { _ in
                    self?.addCartGuitar(indexPath: indexPath)
                }
            
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
}
