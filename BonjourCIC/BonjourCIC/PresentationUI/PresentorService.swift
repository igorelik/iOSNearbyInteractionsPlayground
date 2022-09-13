import Foundation
import Network

class PresentorService {
    static let instance = PresentorService()
    var connectionDelegate: PresentorProtocol!
    var latestConnectionName = ""
    var latestConnectionPassCode = ""
    
    func resetPresentorListener(){
        assert(connectionDelegate != nil)
        resetPresentorListener(name: latestConnectionName, passCode: latestConnectionPassCode, connectionDelegate: connectionDelegate)
    }
    
    func resetPresentorListener(name: String, passCode: String, connectionDelegate: PresentorProtocol){
        if let listener = sharedListener{
            listener.listener?.cancel()
        }
        latestConnectionName = name
        latestConnectionPassCode = passCode
        sharedListener = nil
        sharedConnection?.cancel()
        sharedConnection = nil
        startPresentorListener(name: name, passCode: passCode, connectionDelegate: connectionDelegate)
    }
    
    func startPresentorListener(name: String, passCode: String, connectionDelegate: PresentorProtocol){
        latestConnectionName = name
        latestConnectionPassCode = passCode
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
    
    func handleImageReceived(_ content: Data, _ message: NWProtocolFramer.Message){
        connectionDelegate.onImageReceived(imageData: content)
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
        connectionDelegate.onConnectionFailed()
    }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        print("Received message: \(message.messageType)")
        guard let content = content else {
            return
        }
        switch message.messageType {
        case .invalid:
            print("Received invalid message")
        case .displayText:
            handleTextReceived(content, message)
        case .displayImage:
            handleImageReceived(content, message)
        case .closeConnection:
            connectionDelegate.onConnectionFailed()
            resetPresentorListener()
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
            print("\(String(describing: res.endpoint.interface?.name))")
        }
    }
    
    func displayBrowseError(_ error: NWError) {
        
    }
    
    
}
