import SwiftUI

struct PresentationMainView: View {
    
    @StateObject var viewModel = PresentationMainViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            Text(Image(systemName: "appletv")) + Text("Device name")
            TextField("Device name", text: $viewModel.presentorName)
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            if viewModel.isConnectionReady {
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
