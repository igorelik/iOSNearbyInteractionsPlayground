import Foundation
import Network

class ApplicationProtocol: NWProtocolFramerImplementation {
    enum AppMessageType: UInt32{
        case invalid = 0
        case displayText = 1
        case displayImage = 2
        case playMusic = 3
        case startTimer = 4
        case closeConnection = 5
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
        while true {
            // Try to read out a single header.
            var tempHeader: ApplicationProtocolHeader? = nil
            let headerSize = ApplicationProtocolHeader.encodedSize
            let parsed = framer.parseInput(minimumIncompleteLength: headerSize,
                                           maximumLength: headerSize) { (buffer, isComplete) -> Int in
                guard let buffer = buffer else {
                    return 0
                }
                if buffer.count < headerSize {
                    return 0
                }
                tempHeader = ApplicationProtocolHeader(buffer)
                return headerSize
            }

            // If you can't parse out a complete header, stop parsing and ask for headerSize more bytes.
            guard parsed, let header = tempHeader else {
                return headerSize
            }

            // Create an object to deliver the message.
            var messageType = ApplicationProtocol.AppMessageType.invalid
            if let parsedMessageType = ApplicationProtocol.AppMessageType(rawValue: header.type) {
                messageType = parsedMessageType
            }
            let message = NWProtocolFramer.Message(messageType: messageType)

            // Deliver the body of the message, along with the message object.
            if !framer.deliverInputNoCopy(length: Int(header.length), message: message, isComplete: true) {
                return 0
            }
        }
    }
    
    func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool) {
        // Extract the type of message.
        let type = message.messageType

        // Create a header using the type and length.
        let header = ApplicationProtocolHeader(type: type.rawValue, length: UInt32(messageLength))

        // Write the header.
        framer.writeOutput(data: header.encodedData)

        // Ask the connection to insert the content of the application message after your header.
        do {
            try framer.writeOutputNoCopy(length: messageLength)
        } catch let error {
            print("Hit error writing \(error)")
        }
    }
    
    func wakeup(framer: NWProtocolFramer.Instance) {
    }
    
    func stop(framer: NWProtocolFramer.Instance) -> Bool {
        true
    }
    
    func cleanup(framer: NWProtocolFramer.Instance) {
    }
}

extension NWProtocolFramer.Message {
    convenience init(messageType: ApplicationProtocol.AppMessageType) {
        self.init(definition: ApplicationProtocol.definition)
        self["AppMessageType"] = messageType
    }

    var messageType: ApplicationProtocol.AppMessageType {
        if let type = self["AppMessageType"] as? ApplicationProtocol.AppMessageType {
            return type
        } else {
            return .invalid
        }
    }
}

struct ApplicationProtocolHeader: Codable {
    let type: UInt32
    let length: UInt32

    init(type: UInt32, length: UInt32) {
        self.type = type
        self.length = length
    }

    init(_ buffer: UnsafeMutableRawBufferPointer) {
        var tempType: UInt32 = 0
        var tempLength: UInt32 = 0
        withUnsafeMutableBytes(of: &tempType) { typePtr in
            typePtr.copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!.advanced(by: 0),
                                                            count: MemoryLayout<UInt32>.size))
        }
        withUnsafeMutableBytes(of: &tempLength) { lengthPtr in
            lengthPtr.copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!.advanced(by: MemoryLayout<UInt32>.size),
                                                              count: MemoryLayout<UInt32>.size))
        }
        type = tempType
        length = tempLength
    }

    var encodedData: Data {
        var tempType = type
        var tempLength = length
        var data = Data(bytes: &tempType, count: MemoryLayout<UInt32>.size)
        data.append(Data(bytes: &tempLength, count: MemoryLayout<UInt32>.size))
        return data
    }

    static var encodedSize: Int {
        return MemoryLayout<UInt32>.size * 2
    }
}

