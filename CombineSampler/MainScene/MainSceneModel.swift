enum MainScene {

    struct Data {
        var title: String
        
    }

    struct Joke {
        let iconUrl: String
        let id: String
        let url: String
        let value: String
    }
}

enum MainSceneError: Error {
    case parsing(description: String)
    case network(description: String)
}
