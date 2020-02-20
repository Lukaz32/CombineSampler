//  
//  MainSceneViewController.swift
//  CombineSampler
//
//  Created by Lucas Magalhaes Pereira on 13.02.20.
//  Copyright © 2020 Lucas Magalhaes Pereira. All rights reserved.
//

import UIKit

import OpenCombine

class MainSceneViewController: UIViewController {

    // MARK: Public properties

    private let activityIndicatorView = UIActivityIndicatorView()
    private let labelTitle = UILabel()
    private let buttonGetJoke = UIButton()
    private let imageViewIcon = UIImageView()

    // MARK: Private properties

    private let viewModel: MainSceneViewModel
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()

    // MARK: Init

    init(with viewModel: MainSceneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIView Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
        viewModel.sceneWasLoaded()
    }

    // MARK: Public functions

    // MARK: Private functions

    private func setupUI() {
        view.backgroundColor = .white

        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large

        labelTitle.numberOfLines = 0

        buttonGetJoke.setTitle("Get Joke", for: .normal)
        buttonGetJoke.setTitleColor(.red, for: .normal)
        buttonGetJoke.addTarget(self, action: #selector(buttonGetJokeTouched), for: .touchUpInside)

        tableView.dataSource = self

        view.addSubview(imageViewIcon)
        view.addSubview(activityIndicatorView)
        view.addSubview(labelTitle)
        view.addSubview(buttonGetJoke)
        view.addSubview(tableView)
    }

    @objc private func buttonGetJokeTouched() {
        viewModel.getJokeSelected()
    }

    private func setupConstraints() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        imageViewIcon.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
        imageViewIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.topAnchor.constraint(equalTo: imageViewIcon.safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
        labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        buttonGetJoke.translatesAutoresizingMaskIntoConstraints = false
        buttonGetJoke.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16).isActive = true
        buttonGetJoke.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: buttonGetJoke.bottomAnchor, constant: 16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func setupBindings() {

        viewModel
            .$joke
            .compactMap { $0?.value }
            .assign(to: \.text, on: labelTitle)
            .store(in: &cancellables)

        viewModel
            .$joke
            .compactMap { $0 }
            .sink { joke in
                let url = URL(string: joke.iconUrl)
                let data = try? Data(contentsOf: url!)
                self.imageViewIcon.image = UIImage(data: data!)
                self.labelTitle.text = joke.value
            }
            .store(in: &cancellables)

        viewModel
            .$isLoading
            .sink { isLoading in
                self.handleLoading(isLoading)
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func handleLoading(_ isLoading: Bool) {
        if isLoading {
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.stopAnimating()
        }
    }

}


// MARK: - UITableViewDataSource
extension MainSceneViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.jokes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let joke = viewModel.jokes[indexPath.row]
        cell.textLabel?.text = joke.value
        cell.detailTextLabel?.text = joke.iconUrl
        return cell
    }

}
