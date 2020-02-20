//  
//  MainSceneCoordinator.swift
//  CombineSampler
//
//  Created by Lucas Magalhaes Pereira on 13.02.20.
//  Copyright © 2020 Lucas Magalhaes Pereira. All rights reserved.
//

import UIKit

class MainSceneCoordinator: Coordinator {

    var weakNavigationController: UINavigationController?

    var parent: Coordinator?

    var children = [Coordinator]()

    func start() {

        // service creation should be tackled by Factory injected from the parent coordinator
        let service = MainSceneService()

        let viewModel = MainSceneViewModel(service: service)
        let viewController = MainSceneViewController(with: viewModel)

        viewModel.userDidFinishWork = { [unowned self] in
            self.weakNavigationController?.popViewController(animated: true)
            self.parent?.childDidFinish(self)
        }

        weakNavigationController?.pushViewController(viewController, animated: true)
    }

}
