import SwiftUI

struct PresentorCanvasView: View {
    @ObservedObject var viewModel: PresentorViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Ready to receive data")
            if viewModel.textReceived != "" {
                Text("Text: \(viewModel.textReceived)")
            }
            Spacer()
        }
        .navigationTitle(Text("Apple TV"))
    }
}

struct PresentorCanvasView_Previews: PreviewProvider {
    static func getViewModel() -> PresentorViewModel{
        let vm = PresentorViewModel()
        vm.presentorName = "Apple TV"
        vm.textReceived = "From controller"
        return vm
    }
    static var previews: some View {
        NavigationView{
            PresentorCanvasView(viewModel: getViewModel())
        }
    }
}
