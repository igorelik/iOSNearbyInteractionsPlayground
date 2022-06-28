import Foundation

class PresentationMainViewModel: ObservableObject{
    @Published var passCode: String
    @Published var presentorName: String = "Meeting Room AppleTV"
    @Published var isReadyToConnect = false
    @Published var isConnected = false

    init() {
        passCode = PresentationMainViewModel.generatePasscode()
    }
    
    func startNewSession(){
       PresentorService.instance.startPresentorListener(name: presentorName, passCode: passCode, connectionDelegate: self)
    }
    
    static func generatePasscode() -> String {
        return String("\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))")
    }
}

extension PresentationMainViewModel: PresentorProtocol{
    func onControllerConnected() {
        DispatchQueue.main.async {
            self.isConnected = true
         }
    }
    
    func onListenerReady() {
        DispatchQueue.main.async {
            self.isReadyToConnect = true
         }
    }
    
    
}
