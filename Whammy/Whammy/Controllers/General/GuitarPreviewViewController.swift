import UIKit
import SDWebImage

class GuitarPreviewViewController: UIViewController {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let guitarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let addCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.borderColor = UIColor(red: 27/255, green: 31/255, blue: 35/255, alpha: 0.10).cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(posterImageView)
        view.addSubview(guitarLabel)
        view.addSubview(overviewLabel)
        view.addSubview(addCartButton)
        
        applyConstraints()
    }
    
    func applyConstraints() {
        let constraints = [
            posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0.5*view.bounds.height),
            
            guitarLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            guitarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            overviewLabel.topAnchor.constraint(equalTo: guitarLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addCartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            addCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCartButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    public func configure(with model: GuitarPreviewViewModel) {
        guitarLabel.text = model.guitarName
        overviewLabel.text = model.guitarOverview
        
        guard let url = URL(string: "http://localhost:3000/\(model.imagePath)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
