import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: Coin?
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                        .accessibilityIdentifier("SearchCoinForPortfolio")
                    coinList
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarItem
                }
            })
            .onChange(of: viewModel.searchText, perform: { value in
                if value.isEmpty {
                    removeSelection()
                }
            })
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var coinList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.portfolioCoins : viewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 70)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?
                                            Color.theme.green :
                                            Color.clear,
                                        lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.vertical, 4)
            .padding(.leading)
        })
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol?.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice?.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("ChangeCoin")
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
    }
    
    private var trailingNavBarItem: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1 : 0)
                .foregroundColor(.theme.accent)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("SAVE")
            })
            .accessibilityIdentifier("SaveButton")
            .opacity(
                selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0
            )
        }
    }
    
    private func getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    
    private func saveButtonPressed() {
        guard  let coin = selectedCoin,
               let amount = Double(quantityText)
        else { return }
        viewModel.updatePortfolio(coin: coin, amount: amount)
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelection()
        }
        UIApplication.shared.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                self.showCheckMark = false
            }
        }
    }
    
    private func removeSelection() {
        selectedCoin = nil
        viewModel.searchText = ""
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = String(amount)
        } else {
            quantityText = ""
        }
    }
}
