# FrameMint 🌱
Library to make pixel buffer for video frame formatted 420YpCbCr8BiPlanarFullRange from UIKit/SwiftUI view or UIImage.

This library dose **NOT** written for real-time application.

## Installation

- [x] Swift Package Manager

## Usage

### 1. Create `Canvas`

[`Canvas`](./Sources/FrameMint/Canvas.swift) is a class to manage pixel buffer as a source of video frame.

```swift
let canvasFactory = FrameMint.CanvasFactory()
let canvas = try canvasFactory.makeCanvas(width: width, height: height, extent: extent)
```

### 2. Add/Draw contents on canvas

#### a. Draw SwiftUI contents

Example to add and draw SwiftUI contents on canvas.

```swift
// Add SwiftUI contents on canvas.
canvas.addSwiftUIContents {
  ZStack(alignment: .center) {
    Color.white
    Text("Hello, world!")
      .font(.system(size: 40, weight: .medium))
  }
}
// Draw current canvas  contents on pixel buffer managed by canvas.
canvas.drawContents()
```

#### b. Draw UIKit contents

Example to add and draw UIKit contents on canvas.

```swift
// Create drawn view (Here is a simple UILabel).
let label = UILabel(frame: canvas.content.bounds)
label.backgroundColor = .white
label.text = "Hello, world!"
label.font = .systemFont(ofSize: 40, weight: .medium)
label.textAlignment = .center
// Add drawn view on content view managed by canvas.
canvas.content.addSubview(label)
// Draw current canvas contents on pixel buffer managed by canvas.
canvas.drawContents()
```

#### c. Draw Resources (UIImage)

Example to draw UIImage resource on canvas.

```swift
// Prepare image to draw.
let image: UIImage = ...
// Draw image on pixel buffer managed by canvas in same rect of pixel buffer.
canvas.drawImage(image)
```

### 3. Make video frame pixel buffer from canvas

Example to make 420YpCbCr8BiPlanarFullRange format pixel buffer from canvas.

```swift
let pixelBufferFactory = FrameMint.PixelBufferFactory.default
let pixelBuffer = try pixelBufferFactory.make420YpCbCr8BiPlanarFullRangePixelBuffer(from: canvas)
```

### Clear canvas

Remove all SWiftUI/UIKit contents on canvas.

```swift
canvas.clearContents()
```

## Sample Application

Sample application `framemint_app` to check detail of usage of this library contained in [./App](./App) Directory.

| Home | An example of preview for video frame | 
|:---:|:---:|
| <kbd><img src="https://github.com/naru-jpn/FrameMint/assets/5572875/69ee030e-099b-432f-8953-e3761773042c" width="300"></kbd> | <kbd><img src="https://github.com/naru-jpn/FrameMint/assets/5572875/af708586-5aca-48c5-8065-bc5ff63ab2a7" width="300"></kbd> |

