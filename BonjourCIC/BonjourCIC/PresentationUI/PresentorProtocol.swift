import Foundation
protocol PresentorProtocol {
    func onListenerReady()
    func onControllerConnected()
    func onTextReceived(text: String)
}
