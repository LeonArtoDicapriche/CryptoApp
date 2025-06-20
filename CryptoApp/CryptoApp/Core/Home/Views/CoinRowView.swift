import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coinMock, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coinMock, showHoldingsColumn: true)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol?.uppercased() ?? "")
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue?.asCurrencyWith2Decimals() ?? "")
                .bold()
            Text(coin.currentHoldings?.asNumberString() ?? "")
        }
        .foregroundColor(.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice?.asCurrencyWith6Decimals() ?? "")
                .bold()
                .foregroundColor(.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        .theme.green :
                        .theme.red
                )
        }
        .frame(width: .width35, alignment: .trailing)
    }
    
}
