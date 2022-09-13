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
    
    func connectAsync() async -> Bool {
        await withCheckedContinuation{ continuation in
            ControllerService.instance.join(to: selectedPresenter!, with: passCode){ isSuccess in
                continuation.resume(returning: isSuccess)
            }
        }
    }
    
    func sendMessageAsSessionAsync( message: String) async -> Bool {
        let isConnected = await connectAsync()
        if !isConnected {
            print("sendMessageAsSessionAsync: connect failed")
            return false
        }
        if !(await ControllerService.instance.send(text: message)){
            print("sendMessageAsSessionAsync: send(\(message) failed")
            return false
        }
        disconnect()
        return true
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
    
    func disconnect(){
        ControllerService.instance.disconnect()
    }
}

extension ControllerViewModel: ControllerProtocol{
    func connectionReady() {
   //     isConnected = true
    }
    
    func updatePresenters(presenters: [String]) {
        DispatchQueue.main.async {
            self.presenters = presenters
        }
    }
}
