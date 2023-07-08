import SwiftUI

struct ContentView: View {
    private var contents: [FrameContent] = [
        .helloWorld(title: "Hello, world!"),
        .notification(
            title: "Push Notification (iPhone14)",
            property: .iPhone14(
                title: "Rendered Push Notification",
                body: "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波",
                time: "今",
                icon: ImageResource(name: "default_icon", bundle: .main),
                background: ImageResource(name: "home001", bundle: .main)
            )
        )
    ]

    @State var selectedContent: FrameContent = .helloWorld(title: "Hello, world!")
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
