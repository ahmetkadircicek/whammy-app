//
//  GuitarTableViewCell.swift
//  Whammy
//
//  Created by Ahmet on 21.06.2023.
//

import UIKit
import SDWebImage

class GuitarTableViewCell: UITableViewCell {

    private let shopNowButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "cart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        return button
    }()
    
    static let identifier = "GuitarTableViewCell"
    
    private let guitarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let guitarPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(guitarPosterUIImageView)
        contentView.addSubview(guitarLabel)
        contentView.addSubview(shopNowButton)
        
        applyConstraints()
    }
    
    private func applyConstraints(){
        let guitarPosterUIImageViewConstrains = [
            guitarPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            guitarPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            guitarPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            guitarPosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let guitarLabelConstrains = [
            guitarLabel.leadingAnchor.constraint(equalTo: guitarPosterUIImageView.trailingAnchor, constant: 40),
            guitarLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        let shopNowButtonConstrains = [
            shopNowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            shopNowButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(guitarPosterUIImageViewConstrains)
        NSLayoutConstraint.activate(guitarLabelConstrains)
        NSLayoutConstraint.activate(shopNowButtonConstrains)
    }
    
    public func configure(with model: GuitarViewModel) {
        guard let url = URL(string: "http://localhost:3000/\(model.posterURL)") else {
            return
        }
        guitarPosterUIImageView.sd_setImage(with: url, completed: nil)
        guitarLabel.text = model.guitarModel
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
