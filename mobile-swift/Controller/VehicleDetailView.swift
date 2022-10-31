//
//  DeviceDetailView.swift
//  Controller
//
//  Created by Felix Reichenbach on 13.05.22.
//

import SwiftUI
import RealmSwift


struct VehicleDetailView: View {
    @ObservedRealmObject var vehicle: Vehicle
    @State private var showingCommandView = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Attributes")) {
                    HStack {
                        Text("Vehicle ID")
                        Spacer()
                        Text(vehicle.vin)
                    }
                    HStack {
                        Text("Mixed Types")
                        Spacer()
                        Text(vehicle.mixedTypes.stringValue ?? "No String: \(type(of: vehicle.mixedTypes))")
                    }
                    List(Array(vehicle.flexibleData.keys), id: \.self) { key in
                        HStack {
                            Text(key)
                            Spacer()
                            Text(vehicle.flexibleData[key]?.stringValue ?? "No string but  \(type(of: vehicle.flexibleData[key]))")
                        }
                    }
                }
                Section(header: Text("CONTROLS")) {
                    Toggle(isOn: $vehicle.isOn) {
                        Text("Vehicle Status")
                    }
                }
                Section(header: Text("Sensors")) {
                    HStack {
                        Text("Voltage")
                        Spacer()
                        Text("\(vehicle.battery?.voltage ?? 0)")
                    }
                    HStack {
                        Text("Current")
                        Spacer()
                        Text("\(vehicle.battery?.current ?? 0)")
                    }
                }
                Section(header: Text("Components: \(vehicle.components.count)")) {
                    List {
                        ForEach(vehicle.components, id: \._id) { component in
                            HStack {
                                Text(component.name ?? "")
                            }
                        }
                    }
                }
                Button("Send Command", action: {showingCommandView = true})
            }
        }
        .navigationBarTitle(vehicle.name)
        .sheet(isPresented: $showingCommandView) {
            // show the add item view
            CommandView(vehicle: vehicle.thaw()!, isPresented: $showingCommandView)
        }
    }
}

struct CommandView: View {
    @ObservedObject var vehicle: Vehicle
    @Binding var isPresented: Bool
    @State var command: String = ""
    @State var key: String = ""
    @State var value: String = ""
    
    var body: some View {
        Text("Submit Command").font(.title)
        VStack() {
            HStack(){
                Text("Command")
                    .font(.title3)
                    .bold()
                Spacer()
            }.padding()
            HStack() {
                TextField("Enter Command", text: $command)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }.padding()
            HStack() {
                Text("Parameter")
                    .font(.title3)
                    .bold()
                Spacer()
            }.padding()
            HStack() {
                TextField("Enter Key", text: $key)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(":")
                TextField("Enter Value", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }.padding()
        Button("Send", action: sendCommand)
        Button("Dismiss", action: {isPresented = false})
    }
    
    func sendCommand(){
        $vehicle.commands.append(Command(value: [
            "device_id": vehicle.device_id,
            "command": command,
            "parameter": [key: value],
            "status": "submitted"]))
        isPresented = false
    }
}


struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailView(vehicle: Vehicle())
    }
}