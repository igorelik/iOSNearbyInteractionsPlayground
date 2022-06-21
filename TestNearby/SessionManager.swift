import Foundation
import NearbyInteraction
import MultipeerConnectivity

protocol NearbyInteractionManagerDelegate: AnyObject {
    func didUpdateNearbyObjects(objects: [NINearbyObject])
}

class SessionManager: NSObject {
    var mySession: NISession?
    weak var delegate: NearbyInteractionManagerDelegate?
    var dataExchange: InteractionDataProtocol?

    func prepareMySession(_ data: InteractionDataProtocol) {
      // Verify hardware support.
        guard NISession.isSupported else {
            print("Nearby Interaction is not available on this device.")
            return
        }

        mySession = NISession()
        mySession?.delegate = self
        MultipeerConnectivityManager.instance.delegate = self
        MultipeerConnectivityManager.instance.startBrowsingForPeers()
        dataExchange = data
        
    }
    
    private var discoveryTokenData: Data {
        guard let token = mySession?.discoveryToken,
              let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("can't convert token to data")
        }
        
        return data
    }
}

extension SessionManager: MultipeerConnectivityManagerDelegate {
    func connectedDevicesChanged(devices: [String]) {
        print("connected devices changed \(devices)")
        DispatchQueue.main.async {
            self.dataExchange?.devicesAvailable = devices
        }
    }
    
    func connectedToDevice() {
        print("connected to device")
        MultipeerConnectivityManager.instance.shareDiscoveryToken(data: discoveryTokenData)
    }
    
    func receivedDiscoveryToken(data: Data) {
        print("data received")
        guard let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        let configuration = NINearbyPeerConfiguration(peerToken: token)
        mySession?.run(configuration)
    }
}

// MARK: - NISessionDelegate
extension SessionManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        delegate?.didUpdateNearbyObjects(objects: nearbyObjects)
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {}
    func sessionWasSuspended(_ session: NISession) {}
    func sessionSuspensionEnded(_ session: NISession) {}
    func session(_ session: NISession, didInvalidateWith error: Error) {}
}
