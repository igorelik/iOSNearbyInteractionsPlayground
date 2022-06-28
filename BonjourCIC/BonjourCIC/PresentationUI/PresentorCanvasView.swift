import SwiftUI

struct PresentorCanvasView: View {
    var body: some View {
        ScrollView(.vertical){
            Text("Ready to receive data")
        }
        .navigationTitle(Text("Apple TV"))
    }
}

struct PresentorCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PresentorCanvasView()
        }
    }
}
