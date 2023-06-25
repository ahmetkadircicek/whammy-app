//
//  HeroHeaderUIView.swift
//  Whammy
//
//  Created by Ahmet on 19.06.2023.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    private let addCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Cart!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.borderColor = UIColor(red: 27/255, green: 31/255, blue: 35/255, alpha: 0.10).cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private let shopNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Shop Now!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.borderColor = UIColor(red: 27/255, green: 31/255, blue: 35/255, alpha: 0.15).cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()




    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(shopNowButton)
        addSubview(addCartButton)
        applyConstraints()
    }
    	
    private func applyConstraints() {
        let shopNowButtonConstraints = [
            shopNowButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -70),
            shopNowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            shopNowButton.widthAnchor.constraint(equalToConstant: 120)

        ]
        
        let addCartButtonConstraints = [
            addCartButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: +70),
            addCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            addCartButton.widthAnchor.constraint(equalToConstant: 120)

        ]
        
        NSLayoutConstraint.activate(shopNowButtonConstraints)
        NSLayoutConstraint.activate(addCartButtonConstraints)
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
        heroImageView.contentMode = .scaleAspectFill
    }
    
    required init(coder: NSCoder) {
        fatalError()
        
    }

}
