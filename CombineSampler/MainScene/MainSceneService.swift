import Foundation
import OpenCombine
import OpenCombineDispatch
import OpenCombineFoundation

class MainSceneService {

    private let session: URLSession = .shared

    func fetchJoke() -> AnyPublisher<JokeDTO, MainSceneError>  {

        let path = "https://api.chucknorris.io/jokes/random"

        guard let url = URL(string: path) else {
            let error = MainSceneError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }

        return session
            .ocombine
            .dataTaskPublisher(for: URLRequest(url: url))
            .subscribe(on: DispatchQueue.global().ocombine)
            .receive(on: DispatchQueue.main.ocombine)
            .mapError { .network(description: $0.localizedDescription) }
            .flatMap { decode($0.data) }
            .eraseToAnyPublisher()
    }

    func fetchJoke(completion: (Result<JokeDTO, MainSceneError>) -> Void) {

        let path = "https://api.chucknorris.io/jokes/random"

        guard let url = URL(string: path) else {
            let error = MainSceneError.network(description: "Couldn't create URL")
            return completion(.failure(error))
        }

        session.dataTask(with: url) { _, response, _  in
            switch response {
            default:
                break
            }
        }.resume()
    }
}


func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, MainSceneError> {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { .parsing(description: $0.localizedDescription) }
        .eraseToAnyPublisher()
}

struct JokeDTO: Decodable {
    let iconUrl: String
    let id: String
    let url: String
    let value: String
}
