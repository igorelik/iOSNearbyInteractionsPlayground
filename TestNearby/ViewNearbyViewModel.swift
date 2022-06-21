import Foundation

class ViewNearbyViewModel: ObservableObject{
    let sessionManager = SessionManager()
    @Published var devicesAvailable: [String] = []
    
    init(){
        sessionManager.prepareMySession(self)
    }
}

extension ViewNearbyViewModel: InteractionDataProtocol{

    
}


