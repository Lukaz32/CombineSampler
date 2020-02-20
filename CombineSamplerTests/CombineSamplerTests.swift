//
//  CombineSamplerTests.swift
//  CombineSamplerTests
//
//  Created by Lucas Magalhaes Pereira on 13.02.20.
//  Copyright © 2020 Lucas Magalhaes Pereira. All rights reserved.
//

import Quick
import Nimble
import Combine

@testable import CombineSampler

class CombineSamplerTests: QuickSpec {

    var cancellables = [AnyCancellable]()

    override func spec() {

        var sut: MainSceneViewModel!

        describe("MainSceneViewModel") {

            var isLoading = false
            var joke: MainScene.Joke?

            beforeEach {
                sut = MainSceneViewModel(service: MainSceneService())
                sut
                    .$isLoading
                    .sink {
                    if $0 { isLoading = $0 }
                }
                .store(in: &self.cancellables)

                sut
                    .$joke
                    .sink { joke = $0 }
                    .store(in: &self.cancellables)
            }

            context("On loading the scene") {

                beforeEach {
                    sut.sceneWasLoaded()
                }

                it("shows loading indicator") {
                    expect(isLoading).to(beTrue())
                }

                context("On receiving a success response") {

                    it("updates the model") {
                        expect(joke?.value).toEventuallyNot(beNil())
                    }
                }

                context("On receiving a failure response") {

                    beforeEach {

                    }

                    it("displays an error message") {
//                        expect(joke?.value).toEventuallyNot(beNil())
                    }
                }
            }
        }

    }

}
