import SwiftUI

struct ControllerConsoleView: View {
    @ObservedObject var viewModel: ControllerViewModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image = UIImage()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Connected to ") + Text(viewModel.selectedPresenter!).bold()
            Divider()
            TextField("Message", text: $viewModel.textToSend)
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            Button {
                viewModel.sendText()
            } label: {
                Text("Send text")
            }
            Divider()
            #if !os(tvOS)
            Button {
                showingImagePicker.toggle()
            } label: {
                Text("Select an image")
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            if inputImage != nil {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
            }
            Button {
                viewModel.sendImage(imageData: inputImage?.pngData())
            } label: {
                Text("Send an image")
            }
            #endif
            Button {
                viewModel.disconnect()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Disconnect")
            }
          Spacer()
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .padding()
        .navigationTitle(Text("Console"))
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = inputImage
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
