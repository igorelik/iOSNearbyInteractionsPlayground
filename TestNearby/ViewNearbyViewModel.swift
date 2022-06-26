import Foundation

class ViewNearbyViewModel: ObservableObject{
    let sessionManager = SessionManager()
    @Published var devicesAvailable: [String] = []
    @Published var logStream: [String] = []
    
    init(){
        sessionManager.prepareMySession(self)
    }
}

extension ViewNearbyViewModel: InteractionDataProtocol{
    func addLogEntry(_ entry: String) {
        DispatchQueue.main.async {
            self.logStream.append(entry)
        }
    }
    

    
}


