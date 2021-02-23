//
//  Coordinator.swift
//  Easybuy
//
//  Created by Yoav on 22/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var container: [UIViewController] { get set }

    func start()
    func presentController(controller: UIViewController, animated: Bool, style: UIModalPresentationStyle)
    func back()
}

extension Coordinator {    
    func presentController(controller: UIViewController,
                           animated: Bool,
                           style: UIModalPresentationStyle) {
        controller.modalPresentationStyle = style
        if container.last != nil {
            container.last?.present(controller, animated: animated, completion: nil)
        }
        navigationController.topViewController?.present(controller, animated: true, completion: nil)
        container.append(controller)
    }

    func back() {
        container.last?.dismiss(animated: true, completion: nil)
        container.removeLast()
    }
}
