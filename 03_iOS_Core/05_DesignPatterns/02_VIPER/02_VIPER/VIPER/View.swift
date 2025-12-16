//
//  View.swift
//  02_VIPER
//
//  Created by Karthik K on 15/11/25.
//

/**
 View
  - Contains for the User Interface (UI).
  - Will be defined using a protocol.
  - Can have view controllers or views.
  - Presenter will have a reference to the View.
 */

import UIKit

protocol AnyView {
  var presenter: AnyPresenter? { get set }
  
  func update(with users: [User])
  func update(with error: String)
}

class UserViewController: UIViewController, AnyView {
  var presenter: AnyPresenter?
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    table.isHidden = true
    return table
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.isHidden = true
    return label
  }()
  
  var users: [User] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBlue
    view.addSubview(tableView)
    view.addSubview(label)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
    
    label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
    label.center = view.center
  }

  func update(with users: [User]) {
    DispatchQueue.main.async {
      self.users = users
      self.tableView.reloadData()
      self.tableView.isHidden = false
    }
  }

  func update(with error: String) {
    DispatchQueue.main.async {
      self.users = []
      self.tableView.isHidden = true
      self.label.text = error
      self.label.isHidden = false
    }
  }

}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
    
    cell.textLabel?.text = users[indexPath.row].name
    
    return cell
  }
}
