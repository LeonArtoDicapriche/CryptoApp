// swiftlint:disable foundation_using
import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketData?
    private var marketSubscription: AnyCancellable?
    let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
        getMarketData()
    }
    
    func getMarketData(url: String = .apiMarketURL, completion: ((MarketData?, String?) -> Void)? = nil) {
        guard let url = URL(string: url) else { return }
        marketSubscription = NetworkManager.download(urlSession: session, url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { receiveCompletion in
                NetworkManager.handleCompletion(receiveCompletion: receiveCompletion) { string in
                    completion?(nil, string)
                }
            }, receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                completion?(globalData.data, nil)
                self?.marketSubscription?.cancel()
            })
    }
}

// swiftlint:enable foundation_using
