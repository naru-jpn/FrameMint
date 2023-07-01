import Foundation

public enum FrameMintError: Error {
    /// Failed to get pixel buffer pool
    case failedToGetPixelBufferPool
    /// Failed to create pixel buffer
    case failedToCreatePixelbuffer
    /// Failed to lock base address of pixel buffer
    case failedToLockPixelBufferBaseAddress
    /// Faield to get CGContext to draw view contents on pixel buffer.
    case faieldToGetContextToDrawContents
}
