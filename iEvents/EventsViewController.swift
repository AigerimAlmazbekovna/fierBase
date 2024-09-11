

import UIKit
import FirebaseAuth
import SnapKit

class EventsViewController: UIViewController {

    private var events = [Event]()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        
        
        StoreManager().getEvents { [weak self] events in
            guard let events, let self else {
                return
            }
            self.events = events
            self.tableView.reloadData()
        }
        
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.top.horizontalEdges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupButtons(auth: Auth.auth().currentUser != nil)
      

    }
    
    private func setupButtons(auth: Bool) {
        if auth {
            let leftBarItem = UIBarButtonItem(title: "log out", style: .plain, target: self, action: #selector(didTapLogOutButton))
            navigationItem.leftBarButtonItem = leftBarItem
            
            let rightBarItem = UIBarButtonItem(title: "Add event", style: .plain, target: self, action: #selector(didTapAddEventButton))
            navigationItem.rightBarButtonItem = rightBarItem
        } else {
            let leftBarItem = UIBarButtonItem(title: "log in", style: .plain, target: self, action: #selector(didTapLoginButton))
            navigationItem.leftBarButtonItem = leftBarItem
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    @objc private func didTapLogOutButton() {
        try? Auth.auth().signOut()
        setupButtons(auth: Auth.auth().currentUser != nil)
    }

    @objc private func didTapAddEventButton() {
        let vc = EventDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLoginButton() {
        let vc = AuthViewController()
        vc.dismissCompletion = { [weak self] in
            self?.setupButtons(auth: Auth.auth().currentUser != nil)
        }
        present(vc, animated: true)
    }

}

extension EventsViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let vc = EventDetailViewController(event: event)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EventsViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        
        configuration.text = events[indexPath.row].title
        configuration.secondaryText = events[indexPath.row].description
        cell.contentConfiguration = configuration
        return cell
    }
    
}
