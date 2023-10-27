import { ObjectID } from 'bson';

// Provide the Realm App ID

export const appID = "YOUR-ATLAS-APP-ID-HERE"
export const baseUrl = "http://localhost:80";


// Provide the configured customer profile
export const realmUser = {
    username: "demo",
    password: "demopw"
}

export const vin = "5UXFE83578L342684"; // https://vingenerator.org/brand


export const vehicleConfig = {
    _id: vin,
    name: "My Car",
    device_id: "",
    mixedTypes: "Change Type",
    isOn: false,
    commands: [],
    battery: { sn: "123", capacity: 1000, voltage: 50, current: 50 }
  }

