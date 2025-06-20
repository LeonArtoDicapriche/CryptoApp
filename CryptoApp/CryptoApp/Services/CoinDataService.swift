// swiftlint:disable foundation_using
import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [Coin] = []
    private var coinSubscription: AnyCancellable?
    let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
        getCoins()
    }
    
    func getCoins(url: String = .apiURL, completion: (([Coin]?, String?) -> Void)? = nil) {
        guard let url = URL(string: url) else {
            completion?(nil, nil)
            return
        }
        coinSubscription = NetworkManager.download(urlSession: session, url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { receiveCompletion in
                NetworkManager.handleCompletion(receiveCompletion: receiveCompletion) { string in
                    completion?(nil, string)
                }
            } receiveValue: { [weak self] coins in
                self?.allCoins = coins
                completion?(coins, nil)
                self?.coinSubscription?.cancel()
            }
    }
}
// swiftlint:disable foundation_using
