//  
//  MainSceneViewModel.swift
//  CombineSampler
//
//  Created by Lucas Magalhaes Pereira on 13.02.20.
//  Copyright © 2020 Lucas Magalhaes Pereira. All rights reserved.
//

import Foundation
import OpenCombine

final class MainSceneViewModel {

    // MARK: Public properties
    
    var userDidFinishWork: (VoidClosure)?
    @OpenCombine.Published var joke: MainScene.Joke? {
        didSet {
            if let joke = joke {
                jokes.append(joke)
            }
        }
    }
    @OpenCombine.Published var isLoading = false
    var jokes = [MainScene.Joke]()

    // MARK: Private properties

    private var service: MainSceneService?
     private var cancellables = Set<AnyCancellable>()

    // MARK: Init

    init(service: MainSceneService) {
        self.service = service
    }

    // MARK: Public methods

    func sceneWasLoaded() {
        fetchData()
    }

    func getJokeSelected() {
        fetchData()
    }

    // MARK: Private methods

    private func fetchData() {
        isLoading = true
        service?
            .fetchJoke()
            .sink(receiveCompletion: { completion in
            self.isLoading = false
            switch completion {
            case .failure(let error):
                // Handle error
                print(error)
                break
            default:
                break

            }
        }, receiveValue: { jokeDTO in
            self.joke = jokeDTO.asJokeModel
        })
        .store(in: &cancellables)
    }
}

private extension JokeDTO {
    var asJokeModel: MainScene.Joke {
        return .init(iconUrl: iconUrl,
                     id: id,
                     url: url,
                     value: value)
    }
}
