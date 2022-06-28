import Foundation

class ControllerViewModel: ObservableObject{
    @Published var presenters = [String]()
    @Published var selectedPresenter: String?
    @Published var passCode = ""
    @Published var isConnected = false
    
    @Published var textToSend = ""
    
    init(){
        ControllerService.instance.startPolling(controllerDelegate: self)
    }
    
    func connect() {
        ControllerService.instance.join(to: selectedPresenter!, with: passCode)
    }
    
    func reset(){
        selectedPresenter = nil
        passCode = ""
    }
    
    func sendText(){
        
    }
}

extension ControllerViewModel: ControllerProtocol{
    func connectionReady() {
        isConnected = true
    }
    
    func updatePresenters(presenters: [String]) {
        DispatchQueue.main.async {
            self.presenters = presenters
        }
    }
}
