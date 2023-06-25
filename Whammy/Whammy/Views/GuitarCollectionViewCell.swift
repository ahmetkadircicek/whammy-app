//
//  GuitarCollectionViewCell.swift
//  Whammy
//
//  Created by Ahmet on 20.06.2023.
//

import UIKit
import SDWebImage

class GuitarCollectionViewCell: UICollectionViewCell {
    static let identifier = "GuitarCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        
    }
    
    public func configure(with model: String){
        print(model)
        
        guard let url = URL(string: "http://localhost:3000/\(model)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
