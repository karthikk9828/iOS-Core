//
//  Interactor.swift
//  02_VIPER
//
//  Created by Karthik K on 15/11/25.
//

/**
 Interactor
 - Contains the business logic / API calls.
 - Will be defined using a protocol.
 - Once processing is done, it will inform the Presenter.
 - Interactor will have a reference to the Presenter.
 */

import Foundation

protocol AnyInteractor {
  var presenter: AnyPresenter? { get set }
  
  func getUsers()
}

class UserInteractor: AnyInteractor {
  var presenter: AnyPresenter?

  func getUsers() {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
    
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      guard let self else { return }
      
      guard let data, error == nil else {
        self.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
        return
      }
      
      do {
        let entities = try JSONDecoder().decode([User].self, from: data)
        // Inform presenter about entities
        self.presenter?.interactorDidFetchUsers(with: .success(entities))
      }
      catch {
        // Inform presenter about error
        self.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
      }
    }
    
    task.resume()
  }

}

