import CoreData

class PortfolioDataService {
    
    @Published var savedEntities: [Portfolio] = []
    private let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: .containerName)
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                NSLog("Error loading Core Data: \(error.localizedDescription)")
            }
            self?.getPortfolio()
        }
    }

    // MARK: - Public section
    
    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }

    // MARK: - Private section

    private func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: .entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            NSLog("Error fetching Portfolio entities: \(error.localizedDescription)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: Portfolio, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            NSLog("Error saving to Core Data: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }

}
