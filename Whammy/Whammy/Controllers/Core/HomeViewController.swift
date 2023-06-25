//
//  HomeViewController.swift
//  Whammy
//
//  Created by Ahmet on 19.06.2023.
//

import UIKit

enum Sections: Int {
    case UpComingGuitars = 0
    case StratocasterGuitars = 1
    case TelecasterGuitars = 2
    case JaguarGuitars = 3
    case JazzmasterGuitars = 4
}

class HomeViewController: UIViewController {

    let sectionTitles: [String]  = ["Up comIng!" ,"Stratocasters" ,"Telecasters" ,"Jaguar", "Jazzmaster"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 600))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavbar() {
        let logoImageView = UIImageView(image: UIImage(named: "whammyLogo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        logoContainerView.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        navigationItem.titleView = logoContainerView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: nil)

        navigationController?.navigationBar.tintColor = .red
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section{
        case Sections.UpComingGuitars.rawValue:
            APICaller.shared.getUpComingGuitars{result in
                switch result {
                case .success(let guitars):
                    cell.configure(with: guitars)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.StratocasterGuitars.rawValue:
            APICaller.shared.getStratocasterGuitars{result in
                switch result {
                case .success(let guitars):
                    cell.configure(with: guitars)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TelecasterGuitars.rawValue:
            APICaller.shared.getTelecasterGuitars{result in
                switch result {
                case .success(let guitars):
                    cell.configure(with: guitars)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.JaguarGuitars.rawValue:
            APICaller.shared.getJaguarGuitars{result in
                switch result {
                case .success(let guitars):
                    cell.configure(with: guitars)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.JazzmasterGuitars.rawValue:
            APICaller.shared.getJazzmasterGuitars{result in
                switch result {
                case .success(let guitars):
                    cell.configure(with: guitars)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .systemRed
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset - 50
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: GuitarPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = GuitarPreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
            self?.homeFeedTable.setContentOffset(CGPoint(x: 0, y: -50), animated: true)
            
        }
    }
}
