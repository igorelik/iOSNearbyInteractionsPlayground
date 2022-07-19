import Foundation
protocol PresentorProtocol {
    func onListenerReady()
    func onControllerConnected()
    func onTextReceived(text: String)
    func onImageReceived(imageData: Data)
    func onConnectionFailed()
}
