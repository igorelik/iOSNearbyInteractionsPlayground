import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewNearbyViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Devices")
            List(viewModel.devicesAvailable, id: \.self){ device in
                Text(device)
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
