import SwiftUI

struct ControllerConsoleView: View {
    @ObservedObject var viewModel: ControllerViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Connected to ") + Text(viewModel.selectedPresenter!).bold()
            TextField("Message", text: $viewModel.textToSend)
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            Button {
                viewModel.sendText()
            } label: {
                Text("Send text")
            }

            Spacer()
        }
        .padding()
        .navigationTitle(Text("Console"))
    }
}

struct ControllerConsoleView_Previews: PreviewProvider {
    static func getViewModel() -> ControllerViewModel{
        let vm = ControllerViewModel()
        vm.selectedPresenter = "Apple TV"
        return vm
    }
    static var previews: some View {
        NavigationView{
            ControllerConsoleView(viewModel: getViewModel())
        }
    }
}
