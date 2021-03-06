import Foundation
import UIKit

class PresentorViewModel: ObservableObject{
    @Published var passCode: String
    @Published var presentorName: String = "Meeting Room AppleTV"
    @Published var isReadyToConnect = false
    @Published var isConnected = false
    @Published var isControllerConnected = false

    @Published var textReceived = ""
    @Published var imageDataReceived: Data?

    init() {
        passCode = PresentorViewModel.generatePasscode()
    }
    
    func startNewSession(){
        PresentorService.instance.startPresentorListener(name: presentorName, passCode: passCode, connectionDelegate: self)
    }
    
    static func generatePasscode() -> String {
        return String("\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))")
    }
}

extension PresentorViewModel: PresentorProtocol{
    func onImageReceived(imageData: Data) {
        imageDataReceived = imageData
    }
    
    func onTextReceived(text: String) {
        DispatchQueue.main.async {
            self.textReceived = text
         }

    }
    
    func onControllerConnected() {
        DispatchQueue.main.async {
            self.isConnected = true
            self.isControllerConnected = true
         }
    }
    
    func onListenerReady() {
        DispatchQueue.main.async {
            self.isReadyToConnect = true
         }
    }
    
    func onConnectionFailed() {
        DispatchQueue.main.async {
            self.isControllerConnected = false
            PresentorService.instance.resetPresentorListener(name: self.presentorName, passCode: self.passCode, connectionDelegate: self)
         }
    }
    
}
