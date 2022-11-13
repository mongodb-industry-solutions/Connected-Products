//
//  DataModel.swift
//  Easy
//
//  Created by Felix Reichenbach on 03.06.21.
//

import Foundation
import RealmSwift

class Vehicle: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var battery: Battery?
    @Persisted var commands: List<Command>
    @Persisted var components: List<Component>
    @Persisted var current: Int?
    @Persisted var device_id: String = ""
    @Persisted var vin: String = ""
    @Persisted var isOn: Bool = false
    @Persisted var mixedTypes: AnyRealmValue
    @Persisted var name: String = ""
}

class Battery: EmbeddedObject {
    @Persisted var capacity: Int?
    @Persisted var current: Int?
    @Persisted var sn: String?
    @Persisted var voltage: Int?
    @Persisted var status: String?
}

class Component: Object {
    @Persisted(primaryKey: true) var _id: ObjectId?
    @Persisted var name: String?
    @Persisted var device_id: String = ""
}

class Command: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var device_id: String
    @Persisted var command: String
    @Persisted var parameter: Map<String, String>
    @Persisted var status: String

}
