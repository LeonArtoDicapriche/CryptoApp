import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map({ String($0) })
    @State private var showLoadingText = false
    @State private var counter = 0
    @State private var loops = 0
    @Binding var showLaunchView: Bool
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.launchTheme.background
                .ignoresSafeArea()
            Image(uiImage: R.image.logoTransparent() ?? UIImage())
                .resizable()
                .frame(width: 100, height: 100)
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(.launchTheme.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            showLaunchView.toggle()
//            withAnimation(.spring()) {
//                if counter == loadingText.count - 1 {
//                    counter = 0
//                    loops += 1
//                    if loops >= 2 {
//                        showLaunchView.toggle()
//                    }
//                } else {
//                    counter += 1
//                }
//            }
        })
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
