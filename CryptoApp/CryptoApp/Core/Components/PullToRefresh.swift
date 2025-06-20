import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    @Binding var isLoading: Bool
    var onRefresh: () -> Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if geo.frame(in: .named(coordinateSpaceName)).midY > 50 {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if geo.frame(in: .named(coordinateSpaceName)).maxY < 10 {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh || isLoading {
                    ProgressView()
                }
                Spacer()
            }
        }
        .padding(.top, isLoading ? 0 : -50)
    }
}
