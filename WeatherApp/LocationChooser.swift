//
//  LocationChooser.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import SwiftUI
import SwiftData

struct LocationChooser: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.modelContext) private var modelContext
    @Query private var locations: [Location]
    
    @State var locationAdderOpen = false
    
    let bottomColor = UIColor(red: 0, green: 0.7, blue: 1, alpha: 1)
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(locations) { location in
                    NavigationLink {
                        Text(location.name)
                            .font(.title)
                        Text("Country: \(location.country)")
                        HStack {
                            Text("Longitude: \(location.longitude)")
                            Text("Latitude: \(location.latitude)")
                        }
                    } label: {
                        Text(location.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .background(
                LinearGradient(colors: [.teal, Color(bottomColor)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        
        } detail: {
            Text("Select an item")
        }
        .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                            Text("Back")
                                .foregroundStyle(.white)
                        }
                        
                    }
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $locationAdderOpen) {
                LocationAdder()
            }
    }
    
//    ---------- Functions ----------
    
    
    private func addItem() {
        locationAdderOpen = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(locations[index])
            }
        }
    }
}
