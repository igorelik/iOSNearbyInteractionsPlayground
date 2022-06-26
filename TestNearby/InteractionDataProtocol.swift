
protocol InteractionDataProtocol {
    var devicesAvailable: [String] { get set }
    
    func addLogEntry(_ entry: String)
}
