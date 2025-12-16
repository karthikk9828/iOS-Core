//
//  Router.swift
//  02_VIPER
//
//  Created by Karthik K on 15/11/25.
//

/**
 Router
 - Navigation logic within each module.
 - Contains module creation logic.
 - Will be defined using a protocol.
 - Entry point for the module.
 - Router will have reference to entry point
 */

import UIKit

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
  var entryPoint: EntryPoint? { get set }
  
  static func start() -> AnyRouter
}

class UserRouter: AnyRouter {
  
  var entryPoint: EntryPoint?
    
  static func start() -> AnyRouter {
    let router = UserRouter()
    
    var view: AnyView = UserViewController()
    var presenter: AnyPresenter = UserPresenter()
    var interactor: AnyInteractor = UserInteractor()
    
    view.presenter = presenter
    interactor.presenter = presenter
    
    presenter.interactor = interactor
    presenter.router = router
    presenter.view = view
    
    router.entryPoint = view as? EntryPoint
    
    return router
  }
}
