import SwiftUI
import Combine

class CoinImageService {
    @Published var image: UIImage?
    private var imageSubscription: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    let session: URLSession
    
    init(coin: Coin, urlSession: URLSession = .shared) {
        self.session = urlSession
        self.coin = coin
        getCoinImage()
    }
    
    func getCoinImage(completion: ((UIImage?, String?) -> Void)? = nil) {
        guard let name = coin.id else {
            completion?(nil, "emptyID")
            return }
        if let savedImage = fileManager.getImage(imageName: name, folderName: .folderName) {
            image = savedImage
        } else {
            downloadCoinImage(saveByName: name) { image, string in
                completion?(image, string)
            }
        }
    }
    
    private func downloadCoinImage(saveByName: String, completion: @escaping (UIImage?, String?) -> Void) {
        guard let imageUrl = coin.image, let url = URL(string: imageUrl) else {
            completion(nil, "error")
            return }
        imageSubscription = NetworkManager.download(urlSession: session, url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink { receiveCompletion in
                NetworkManager.handleCompletion(receiveCompletion: receiveCompletion) { string in
                    completion(nil, string)
                }
            } receiveValue: { [weak self] image in
                guard let self = self, let image = image else { return }
                self.image = image
                self.fileManager.saveImage(image: image, imageName: saveByName, folderName: .folderName)
                completion(image, nil)
                self.imageSubscription?.cancel()
            }
    }
}
