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
        ControllerService.instance.send(text: textToSend)
    }
    
    func sendImage(imageData: Data?){
        if let data = imageData {
            ControllerService.instance.send(data: data)
        }
        
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
