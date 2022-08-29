import { ObjectId } from 'bson';
import Realm from 'realm';

/**
 * Realm object schema/class definition for a device object within typescript
 * https://github.com/realm/realm-js/releases
 * https://github.com/realm/realm-js/issues/1795 -> applied works
 */
export class Device {
  public _id?: ObjectId | null;
  public name: string;
  public device_id!: string;
  public isOn: boolean;
  //public sensor?: number | null;
  public voltage?: number | null;
  public current?: number | null;
  // Field type which supports multiple multiple data types
  public mixedTypes?: Realm.Mixed | null;
  // Lie because https://github.com/realm/realm-js/issues/2469
  public components = [] as any;
  // Dictionary which supports adding new key value pairs with support for the 'mixed' data types
  public flexibleData?: Realm.Dictionary<Realm.Mixed> | null;

  static schema: Realm.ObjectSchema = {
    name: 'Device',
    primaryKey: '_id',
    properties: {
      _id: 'objectId',
      name: 'string',
      device_id: 'string',
      isOn: 'bool',
      //sensor: 'int?',
      voltage: 'int?',
      current: 'int?',
      mixedTypes: 'mixed?',
      flexibleData: '{}',
      components: 'Component[]'
    }
  }

  constructor(name: string, device_id: string) {
    this._id = new ObjectId;
    this.name = name;
    this.device_id = device_id;
    this.isOn = true;
  }

}

/**
 * Realm object schema/class definition for a component object within typescript
 */
export class Component {
  public _id: ObjectId;
  public name?: string | null;
  public device_id!: string;

  static schema: Realm.ObjectSchema = {
    name: 'Component',
    primaryKey: '_id',
    properties: {
      _id: 'objectId',
      name: 'string?',
      device_id: 'string'
    }
  }

  constructor(name: string, device_id: string) {
    this._id = new ObjectId;
    this.name = name;
    this.device_id = device_id;
  }
}

/**
 * Realm object schema/class definition for a sensor measurement object within typescript
 */
export class Sensor {
  public _id!: ObjectId;
  public device_id!: string;
  public timestamp!: Date;
  public voltage!: number;
  public current!: number;

  static schema: Realm.ObjectSchema = {
    name: 'Sensor',
    asymmetric: true,
    primaryKey: '_id',
    properties: {
      _id: 'objectId',
      device_id: 'string',
      timestamp: 'date',
      voltage: 'int',
      current: 'int'
    }
  }

  constructor(device_id: string, voltage: number, current: number) {
    this._id = new ObjectId;
    this.device_id = device_id;
    this.timestamp = new Date();
    this.voltage = voltage;
    this.current = current;
  }
}