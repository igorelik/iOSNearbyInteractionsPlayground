import SwiftUI

struct PresentationMainView: View {
    
    @StateObject var viewModel = PresentorViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            Text(Image(systemName: "appletv")) + Text("Device name")
            TextField("Device name", text: $viewModel.presentorName)
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            if viewModel.isReadyToConnect {
                HStack{
                    Spacer()
                    Text("Pass Code:")
                    Text(viewModel.passCode)
                        .font(.largeTitle)
                    Spacer()
                }
                .padding()
            }
            Button {
                viewModel.startNewSession()
            } label: {
                Text("Start new session")
            }
            .padding()
            NavigationLink(destination: PresentorCanvasView(viewModel: viewModel), isActive: $viewModel.isConnected) {
                EmptyView()
            }

            Spacer()
        }
        .padding()
        .navigationTitle(Text("Apple TV"))
             
    }
}

struct PresentationMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PresentationMainView()
        }
    }
}
