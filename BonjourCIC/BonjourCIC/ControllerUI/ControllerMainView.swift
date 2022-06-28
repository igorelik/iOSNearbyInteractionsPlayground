import SwiftUI

struct ControllerMainView: View {
    var body: some View {
        VStack{
            Text(Image(systemName: "iphone")) + Text("Controller mode")
        }
        .padding()
        .navigationTitle(Text("Controller"))
    }
}

struct ControllerMainView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerMainView()
    }
}
