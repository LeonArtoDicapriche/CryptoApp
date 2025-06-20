import SwiftUI

struct CircleButtonView: View {
    let iconName: String?
    
    var body: some View {
        Image(systemName: iconName ?? "")
            .font(.headline)
            .foregroundColor(.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.5),
                    radius: 10,
                    x: 0.0,
                    y: 0.0)
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CircleButtonView(iconName: "plus")
                .preferredColorScheme(.dark)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
