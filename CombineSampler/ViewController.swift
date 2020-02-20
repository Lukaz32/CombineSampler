//
//  ViewController.swift
//  CombineSampler
//
//  Created by Lucas Magalhaes Pereira on 13.02.20.
//  Copyright © 2020 Lucas Magalhaes Pereira. All rights reserved.
//

import UIKit
import OpenCombine

typealias VoidClosure = () -> Void

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let viewController = MainSceneViewController(with: .init(service: MainSceneService()))
        navigationController?.pushViewController(viewController, animated: true)
    }

}

public protocol Coordinator: AnyObject {
    var weakNavigationController: UINavigationController? { get set }

    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }

    func start()
    func startChild(_ coordinator: Coordinator)
    func childDidFinish(_ coordinator: Coordinator)
    func removeChildren()
}

public extension Coordinator {
    var navigationController: UINavigationController {
        guard let navigationController = weakNavigationController else {
            fatalError("NavigationController not set in coordinator.")
        }
        return navigationController
    }

    func start() {
        fatalError("Function must be overriden")
    }

    func startChild(_ coordinator: Coordinator) {
        children += [coordinator]
        coordinator.parent = self
        coordinator.start()
    }

    func removeChildren() {
        children.forEach { $0.removeChildren() }
        children.removeAll()
    }

    func childDidFinish(_ coordinator: Coordinator) {
        if let index = self.children.firstIndex(where: { $0 === coordinator }) {
            children.remove(at: index)
        }
    }
}
