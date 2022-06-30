import SwiftUI

struct ModeSelectionView: View {
    var body: some View {
        VStack(alignment: .leading){
            NavigationLink(destination: PresentationMainView()){
                Text(Image(systemName: "appletv")) + Text("Presentation mode")
            }
            NavigationLink(destination: ControllerMainView()){
                Text(Image(systemName: "iphone")) + Text("Controller mode")
            }
        }
    }
}

struct ModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectionView()
    }
}
