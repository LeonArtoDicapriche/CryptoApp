// swiftlint:disable foundation_using
import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetail?
    private var coinDetailSubscription: AnyCancellable?
    let coin: Coin
    let session: URLSession
    
    init(coin: Coin, urlSession: URLSession = .shared) {
        self.session = urlSession
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails(completion: ((CoinDetail?, String?) -> Void)? = nil) {
        guard let ident = coin.id else { return }
        guard let url = URL(string: "\(String.apiDetailURLFirst)\(ident)\(String.apiDetailURLSecond)") else { return }
        coinDetailSubscription = NetworkManager.download(urlSession: session, url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { receiveCompletion in
                NetworkManager.handleCompletion(receiveCompletion: receiveCompletion) { string in
                    completion?(nil, string)
                }
            } receiveValue: { [weak self] coinDetails in
                self?.coinDetails = coinDetails
                completion?(coinDetails, nil)
                self?.coinDetailSubscription?.cancel()
            }
    }
}
// swiftlint:disable foundation_using
