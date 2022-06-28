import Foundation
import Network

class ApplicationProtocol: NWProtocolFramerImplementation {
    enum AppMessageType: UInt32{
        case invalid = 0
        case displayText = 1
        case displayImage = 2
        case playMusic = 3
        case startTimer = 4
    }

    static var label: String { "BonjourCIC" }
    static var bonjourId: String { "_\(label.lowercased())._tcp" }
    static let definition = NWProtocolFramer.Definition(implementation: ApplicationProtocol.self)

    required init(framer: NWProtocolFramer.Instance) {
    }
    
    func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult {
        .ready
    }
    
    func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        // TODO: implement handleInput
        return 0
    }
    
    func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool) {
        // TODO: implement handleOutput
    }
    
    func wakeup(framer: NWProtocolFramer.Instance) {
    }
    
    func stop(framer: NWProtocolFramer.Instance) -> Bool {
        true
    }
    
    func cleanup(framer: NWProtocolFramer.Instance) {
    }
}
