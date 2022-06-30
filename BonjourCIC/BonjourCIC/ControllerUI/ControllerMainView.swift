import SwiftUI

struct ControllerMainView: View {
    @StateObject var viewModel = ControllerViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            if viewModel.selectedPresenter == nil {
                Text(Image(systemName: "appletv")) + Text("Available presentation devices")
                ForEach(viewModel.presenters, id: \.self) { presenter in
                    Button {
                        viewModel.selectedPresenter = presenter
                    } label: {
                        Text(presenter)
                    }
                }
            }
            else {
                Text(Image(systemName: "appletv")) + Text("Selected device: ") + Text(viewModel.selectedPresenter!).bold()
                Text("Pass code:")
                    .padding(.top)
                TextField("Passcode", text: $viewModel.passCode)
                    .padding()
                    .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                Button {
                    viewModel.connect()
                } label: {
                    Text("Connect")
                }
                .padding(.vertical)
                Button {
                    viewModel.reset()
                } label: {
                    Text("Cancel")
                }
                
                NavigationLink(destination: ControllerConsoleView(viewModel: viewModel), isActive: $viewModel.isConnected) {
                    EmptyView()
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(Text("Controller"))
    }
}

struct ControllerMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{        ControllerMainView()
        }
    }
}
