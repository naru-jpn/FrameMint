import SwiftUI

struct FramePreviewView: View {
    let content: FrameContent
    let image: Image

    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFit()
                .shadow(color: .init(white: 0, opacity: 0.2), radius: 8)
                .padding(.all)
        }
        .navigationTitle(content.title)
    }
}
