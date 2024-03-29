import Foundation
import Network

var sharedConnection: PeerConnection?

protocol PeerConnectionDelegate: AnyObject {
    func listenerReady()
    func connectionReady()
    func connectionFailed()
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message)
    func displayAdvertiseError(_ error: NWError)
}

class PeerConnection {

    weak var delegate: PeerConnectionDelegate?
    var connection: NWConnection?
    let initiatedConnection: Bool

    // Create an outbound connection when the user initiates a game.
    init(endpoint: NWEndpoint, interface: NWInterface?, passcode: String, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.initiatedConnection = true

        let connection = NWConnection(to: endpoint, using: NWParameters(passcode: passcode))
        self.connection = connection

        startConnection()
    }

    // Handle an inbound connection when the user receives a game request.
    init(connection: NWConnection, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.connection = connection
        self.initiatedConnection = false

        startConnection()
    }

    // Handle the user exiting the game.
    func cancel() {
        if let connection = self.connection {
            connection.cancel()
            self.connection = nil
        }
    }

    // Handle starting the peer-to-peer connection for both inbound and outbound connections.
    func startConnection() {
        guard let connection = connection else {
            return
        }

        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("\(connection) established")

                // When the connection is ready, start receiving messages.
                self.receiveNextMessage()

                // Notify your delegate that the connection is ready.
                if let delegate = self.delegate {
                    delegate.connectionReady()
                }
            case .failed(let error):
                print("\(connection) failed with \(error)")

                // Cancel the connection upon a failure.
                connection.forceCancel() // cancel()

                // Notify your delegate that the connection failed.
                if let delegate = self.delegate {
                    delegate.connectionFailed()
                }
            default:
                print("\(connection) new state is \(newState)")
                break
            }
        }

        connection.pathUpdateHandler = { newPath in
            print("path update: \(newPath)")
        }
        
        // Start the connection establishment.
        connection.start(queue: .main)
    }
    
    func receiveNextMessage() {
        guard let connection = connection else {
            return
        }

        connection.receiveMessage { (content, context, isComplete, error) in
            // Extract your message type from the received context.
            if let message = context?.protocolMetadata(definition: ApplicationProtocol.definition) as? NWProtocolFramer.Message {
                self.delegate?.receivedMessage(content: content, message: message)
            }
            if error == nil {
                // Continue to receive more messages until you receive and error.
                self.receiveNextMessage()
            }
        }
    }

    
    func sendText(_ text: String, completion: ((Bool) -> Void)? = nil) {
        guard let connection = connection else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(messageType: .displayText)
        let context = NWConnection.ContentContext(identifier: "Text",
                                                  metadata: [message])

        // Send the application content along with the message.
        if completion == nil{
            connection.send(content: text.data(using: .unicode), contentContext: context, isComplete: true, completion: .idempotent)
        }
        else{
            connection.send(content: text.data(using: .unicode), contentContext: context, isComplete: true, completion: .contentProcessed({ error in
                if let error = error {
                    print("send text <\(text)> error: \(error)")
                    completion!(false)
                    return
                }
                completion!(true)
            }))

        }
    }

    func sendText(_ text: String) async -> Bool {
        await withCheckedContinuation{ continuation in
            sendText(text){ isSuccess in
                continuation.resume(returning: isSuccess)
            }
        }
    }
    
    func sendImage(_ data: Data) {
        guard let connection = connection else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(messageType: .displayImage)
        let context = NWConnection.ContentContext(identifier: "Image",
                                                  metadata: [message])

        // Send the application content along with the message.
        connection.send(content: data, contentContext: context, isComplete: true, completion: .idempotent)
    }
    
    func sendDisconnect(){
        guard let connection = connection else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(messageType: .closeConnection)
        let context = NWConnection.ContentContext(identifier: "Disconnect",
                                                  metadata: [message])

        // Send the application content along with the message.
        connection.send(content: "".data(using: .unicode), contentContext: context, isComplete: true, completion: .contentProcessed({ error in
            if let error = error{
                print("Disconnect error: \(error)")
            }
            print("Disconnected.....")
            self.connection?.forceCancel()
        }))

    }
    
   // TODO: Process app protocol here
    /*
    // Handle sending a "select character" message.
    func selectCharacter(_ character: String) {
        guard let connection = connection else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(gameMessageType: .selectedCharacter)
        let context = NWConnection.ContentContext(identifier: "SelectCharacter",
                                                  metadata: [message])

        // Send the application content along with the message.
        connection.send(content: character.data(using: .unicode), contentContext: context, isComplete: true, completion: .idempotent)
    }

    // Handle sending a "move" message.
    func sendMove(_ move: String) {
        guard let connection = connection else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(gameMessageType: .move)
        let context = NWConnection.ContentContext(identifier: "Move",
                                                  metadata: [message])

        // Send the application content along with the message.
        connection.send(content: move.data(using: .unicode), contentContext: context, isComplete: true, completion: .idempotent)
    }

    // Receive a message, deliver it to your delegate, and continue receiving more messages.
    func receiveNextMessage() {
        guard let connection = connection else {
            return
        }

        connection.receiveMessage { (content, context, isComplete, error) in
            // Extract your message type from the received context.
            if let gameMessage = context?.protocolMetadata(definition: GameProtocol.definition) as? NWProtocolFramer.Message {
                self.delegate?.receivedMessage(content: content, message: gameMessage)
            }
            if error == nil {
                // Continue to receive more messages until you receive and error.
                self.receiveNextMessage()
            }
        }
    }
    */
}
