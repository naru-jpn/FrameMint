import SwiftUI

private struct ListContents {
    struct Section: Identifiable {
        let id = UUID().uuidString
        let title: String
        let contents: [FrameContent]
    }

    let sections: [Section]
}

private let listContents = ListContents(
    sections: [
        // SwiftUI
        ListContents.Section(
            title: "SwiftUI",
            contents: [
                .helloWorld(title: "Hello, world! (SwiftUI)", type: .swiftui),
                .notification(
                    title: "Push Notification (iPhone14)",
                    property: .iPhone14(
                        title: "Rendered Push Notification",
                        body: "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波",
                        time: "今",
                        icon: ImageResource(name: "default_icon", bundle: .main),
                        background: ImageResource(name: "home_iphone14", bundle: .main)
                    )
                ),
                .notification(
                    title: "Push Notification (iPad mini 6)",
                    property: .iPadMini6(
                        title: "Rendered Push Notification",
                        body: "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波",
                        time: "今",
                        icon: ImageResource(name: "default_icon", bundle: .main),
                        background: ImageResource(name: "home_ipadmini6", bundle: .main)
                    )
                )
            ]
        ),
        // UIKit
        ListContents.Section(
            title: "UIKit",
            contents: [
                .helloWorld(title: "Hello, world! (UIKit)", type: .uikit)
            ]
        ),
        // Resource (UIImage)
        ListContents.Section(
            title: "Resource (UIImage)",
            contents: [
                .resource(
                    title: "Screenshot (iPhone14)",
                    property: .init(
                        width: 1170,
                        height: 2532,
                        resource: ImageResource(name: "screenshot_iphone14", bundle: .main)
                    )
                ),
                .resource(
                    title: "Screenshot (iPad mini 6)",
                    property: .init(
                        width: 1488,
                        height: 2266,
                        resource: ImageResource(name: "screenshot_ipadmini6", bundle: .main)
                    )
                )
            ]
        )
    ]
)

struct ContentView: View {
    @State var selectedContent: FrameContent = .helloWorld(title: "Hello, world!", type: .swiftui)
    @State var previewImage: Image = .init("", bundle: nil)
    @State var canPreview: Bool = false
    @State var isProcessing: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(listContents.sections) { section in
                        Section(section.title) {
                            ForEach(section.contents) { content in
                                Text(content.title)
                                    .onTapGesture {
                                        handleTapContent(content)
                                    }
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

    private func handleTapContent(_ content: FrameContent) {
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

    @MainActor
    private func makePreviewImage(with content: FrameContent) async -> Image? {
        let pixelBuffer = FrameMaker.shared.makeFrame(content)
        if let uiImage = FrameMaker.shared.makeImage(from: pixelBuffer) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
