//
//  Presenter.swift
//  02_VIPER
//
//  Created by Karthik K on 15/11/25.
//

/**
 Presenter
 - Contains communication between view and interactor.
 - Will be defined using a protocol.
 - Presenter will have a reference to the Interactor, Router and View.
 */

enum FetchError: Error {
  case failed
}

protocol AnyPresenter {
  var router: AnyRouter? { get set }
  var interactor: AnyInteractor? { get set }
  var view: AnyView? { get set }
  
  func interactorDidFetchUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
  var router: AnyRouter?

  var interactor: AnyInteractor? {
    didSet {
      interactor?.getUsers()
    }
  }

  var view: AnyView?

  func interactorDidFetchUsers(with result: Result<[User], any Error>) {
    switch result {
    case .success(let users):
      view?.update(with: users)
    case .failure(_):
      view?.update(with: "Something went wrong")
    }
  }

}
