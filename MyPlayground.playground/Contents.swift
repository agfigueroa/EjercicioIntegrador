import UIKit

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get set }
    //discountCard es opcional porque el vehiculo puede no tener una tarjeta de descuento
    var discountCard: String? { get set }
    var parkedTime: Int { get }
    
}

struct Parking {
    var vehicles: Set<Vehicle> = []
    let maxVehicles = 20
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    var checkInTime: Date
    var discountCard: String?
    
    // utilizamos la estructura calendar para obtener los minutos transcuridos desde checkInTime hasta el momento de la consulta
    var parkedTime: Int {
        return Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

enum VehicleType {
    case bus
    case car
    case miniBus
    case moto
    
    var rate: Int {
        switch self {
        case .bus:
            return 30
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
            return 25
        }
    }
}

//Agregamos algunos vehiculos para probar la funcionalidad
var alkeParking = Parking()

let car = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let moto = Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let miniBus = Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let bus = Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")

alkeParking.vehicles.insert(car)
alkeParking.vehicles.insert(moto)
alkeParking.vehicles.insert(miniBus)
alkeParking.vehicles.insert(bus)
 
//Comprobamos que no se agreguen vechiculos con patente repetida
let car2 = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")
print(alkeParking.vehicles.insert(car2).inserted)  // false

//Ahora probamos remover la moto del set de vechiculos
alkeParking.vehicles.remove(moto)
