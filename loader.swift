import UIKit

protocol FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void)
}

class RemoteFeedLoader : FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void) {
        // remote feedback
    }
}

class LocalFeedLoader : FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void) {
        // local feedback
    }
}

struct NetworkManager {
    enum State {
        case available
        case disable
    }

    static let shared = NetworkManager()
}

struct Reacheability {
    static let networkAvailable = false 

    func getStatus() {
        networkAvailable = checkForNetworkStatus()
    }

    private func checkForNetworkStatus() -> Bool {
        return NetworkManager.shared.state == .available ? true : false
    }
}

class RemoteWithLocalFallbackFeedLoader : FeedLoader {
    let remote: RemoteFeedLoader
    let local: LocalFeedLoader

    init(remote: RemoteFeedLoader, local: LocalFeedLoader) {
        self.remote = remote
        self.local = local
    }

    func loadFeed(completion: @escaping ([String]) -> Void) {
        let load = Reacheability.networkAvailable? remote.loadFeed : local.loadFeed
        load(completion) 
    }
}

class FeedViewController : UIViewController {
    var loader: FeedLoader!

    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadFeed { loadedItems in
            // Update UI
        }
    }
}