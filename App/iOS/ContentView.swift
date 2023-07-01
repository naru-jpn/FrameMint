import SwiftUI

struct ContentView: View {
    private var contents: [FrameContent] = [
        .helloWorld,
        .notification(property: .iPhone14)
    ]

    @State var selectedContent: FrameContent = .helloWorld
    @State var previewImage: Image = .init("", bundle: nil)
    @State var canPreview: Bool = false
    @State var isProcessing: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(contents) { content in
                        Text(content.title)
                            .onTapGesture {
                                selectedContent = content
                                isProcessing = true
                                Task {
                                    // Sleep to display loading indicator by main thread
                                    try? await Task.sleep(nanoseconds: 200_000_000)
                                    if let image = await makePreviewImage(with: content) {
                                        previewImage = image
                                        canPreview = true
                                    }
                                    isProcessing = false
                                }
                            }
                    }
                }
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .navigationTitle("Preview Contents")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $canPreview) {
                FramePreviewView(content: selectedContent, image: previewImage)
            }
        }
    }

    @MainActor
    private func makePreviewImage(with content: FrameContent) async -> Image? {
        let pixelBuffer = FrameMaker.shared.makeFrame(content)
        if let uiImage = FrameMaker.shared.makeImage(from: pixelBuffer) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
