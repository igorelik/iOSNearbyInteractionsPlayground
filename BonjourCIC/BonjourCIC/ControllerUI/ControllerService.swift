import Foundation
import Network

class ControllerService{
    static let instance = ControllerService()
    var availablePresentors = [NWBrowser.Result]()
    var controllerDelegate: ControllerProtocol!
    
    func startPolling(controllerDelegate: ControllerProtocol){
        self.controllerDelegate = controllerDelegate
        if sharedBrowser == nil {
            sharedBrowser = PeerBrowser(delegate: self)
        }
    }
    
    func getBrowserResult(by presentorName:String) -> NWBrowser.Result?{
        for result in availablePresentors {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                if name == presentorName{
                    return result
                }
            }
        }
        return nil
    }
    
    func join(to presentor:String, with passcode: String) {
        if let result = getBrowserResult(by: presentor){
            sharedConnection = PeerConnection(endpoint: result.endpoint,
                                              interface: result.interfaces.first,
                                              passcode: passcode,
                                              delegate: self)
        }
    }
    
    func send(text: String){
        sharedConnection?.sendText(text)
    }

}

extension ControllerService: PeerBrowserDelegate{
    func refreshResults(results: Set<NWBrowser.Result>) {
        availablePresentors = results.map({ res in
            res
        })
        var names = [String]()
        for result in results {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                names.append(name)
            }
        }
        controllerDelegate.updatePresenters(presenters: names)
    }
    
    func displayBrowseError(_ error: NWError) {
        
    }
    
    
}

extension ControllerService: PeerConnectionDelegate{
    func listenerReady() {
        
    }
    
    func connectionReady() {
        controllerDelegate.connectionReady()
    }
    
    func connectionFailed() {
        
    }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        
    }
    
    func displayAdvertiseError(_ error: NWError) {
        
    }
    
    
}
