import Foundation
import Network

class PresentorService {
    static let instance = PresentorService()
    var connectionDelegate: PresentorProtocol!
    
    
    func startPresentorListener(name: String, passCode: String, connectionDelegate: PresentorProtocol){
        self.connectionDelegate = connectionDelegate
        if let listener = sharedListener {
            // If your app is already listening, just update the name.
            listener.resetName(name)
        } else {
            // If your app is not yet listening, start a new listener.
            sharedListener = PeerListener(name: name, passcode: passCode, delegate: PresentorService.instance)
        }
    }
    
    func handleTextReceived(_ content: Data, _ message: NWProtocolFramer.Message){
        if let text = String(data: content, encoding: .unicode) {
            connectionDelegate.onTextReceived(text: text)
        }
    }
}

extension PresentorService: PeerConnectionDelegate{
    func listenerReady() {
        connectionDelegate.onListenerReady()
    }
    
    func connectionReady() {
        connectionDelegate.onControllerConnected()
    }
    
    func connectionFailed() {
        
    }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        guard let content = content else {
            return
        }
        switch message.messageType {
        case .invalid:
            print("Received invalid message")
        case .displayText:
            handleTextReceived(content, message)
        default:
            print("Cannot process \(message.messageType) yet")
        }
    }
    
    func displayAdvertiseError(_ error: NWError) {
        
    }
}

extension PresentorService: PeerBrowserDelegate {
    func refreshResults(results: Set<NWBrowser.Result>) {
        results.forEach { res in
            print("\(res.endpoint.interface?.name)")
        }
    }
    
    func displayBrowseError(_ error: NWError) {
        
    }
    
    
}
