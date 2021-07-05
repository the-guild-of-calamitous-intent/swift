//
//  ContentView.swift
//  PhotoManiac
//
//  Created by Kevin Walchko on 7/4/21.
//

import SwiftUI

/// ViewModel
/// Updates image when fetchNewImage() is called
class ViewModel: ObservableObject {
    /// update View when changed, starts off as nil
    @Published var image: Image?
    
    /// grabs new image when called
    func fetchNewImage(){
        // nil if failed getting url
        guard let url = URL(string: "https://random.imagecdn.app/500/500") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            // async go get image, nil if failed
            DispatchQueue.main.async {
                guard let uiImage = UIImage(data: data) else {
                    return
                }
                
                // if success, then set image
                self.image = Image(uiImage: uiImage)
            }
        }
        
        // what does this do???
        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        // NavigationView gives us the title "Photo Mania"
        NavigationView {
            VStack {
                
                Spacer()
                
                if let image = viewModel.image {
                    ZStack {
                        image
                            .resizable()
                            .foregroundColor(Color.pink)
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                    .frame(
                        width: UIScreen.main.bounds.width/1.2,
                        height: UIScreen.main.bounds.width/1.2)
                    .background(Color.green)
                    .cornerRadius(8)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(Color.pink)
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                Spacer()
                
                // button calls the viewModel to get image or render placeholder
                Button(action: {
                    viewModel.fetchNewImage()
                }, label: {
                    Text("New Image")
                        .bold()
                        .frame(width: 250, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                })
            }
            .navigationTitle("Photo Mania")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
