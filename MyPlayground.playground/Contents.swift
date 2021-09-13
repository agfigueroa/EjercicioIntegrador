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
    var vehiclesPlates: Set<String> = []
//Declaramos el contador para acumular los autos y las ganancias
    var totals: (Int,Int) = (0,0)
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        guard vehicles.count < maxVehicles && vehicles.insert(vehicle).inserted else {
            return onFinish(false)
        }
        return onFinish(true)
    }
    //La funcion chekOut tambien debe declararse como mutating porque modifica una propiedad de la struct
    mutating func checkOutVehicle(_ plate: String, onSucces: ((Int) -> Void), onError: (() -> Void)) {
        //Creamos un sub-set de string para comparar con el metodo contains
        for plate in vehicles {
            vehiclesPlates.insert(plate.plate)
        }
        //Chequeamos que el sub-set contenga la patente que estamos por retirar
        guard vehiclesPlates.contains(plate) else {
            return onError()
        }
        //Retiramos los vehiculos con su respectivo fee
        var vehicleToRemove: Vehicle
        var fee = Int()
        for vehicle in vehicles {
            if vehicle.plate == plate {
                vehicleToRemove = vehicle
                fee = calculateFee(vehicle: vehicleToRemove)
                vehicles.remove(vehicleToRemove)
                vehiclesPlates.remove(vehicleToRemove.plate)
            }
        }
        totals.0 += 1
        totals.1 *= fee
        return onSucces(fee)
    }
    //funcion para el calculo del fee
    func calculateFee(vehicle: Vehicle) -> Int{
        var fee = Double(vehicle.type.rate)
        if(vehicle.parkedTime > 120) {
            let additional = ((fee - 120) / 15) * 5
                fee += additional
        }
        return Int(fee * (vehicle.discountCard != nil ? 0.85 : 1))
    }
    //funcion para mostrar los autos y las ganancias totales
    func showTotals() {
        print("The total vehicles that checked out is \(totals.0) and the total earnings are $\(totals.1)")
    }
    func showAllPlates() {
        for vehicle in vehicles {
            print(vehicle.plate)
        }
    }
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
/*
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
*/

let vehicles = [
    Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard:  "DISCOUNT_CARD_001"),
    Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002"),
    Vehicle(plate: "BB232AA", type: VehicleType.bus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "AA111BB", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003"),
    Vehicle(plate: "B222CCC", type: VehicleType.moto, checkInTime: Date(), discountCard: "DISCOUNT_CARD_004"),
    Vehicle(plate: "CC333DD", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444EE", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_005"),
    Vehicle(plate: "AA111CC", type: VehicleType.car, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "B222DDD", type: VehicleType.moto, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006"),
    Vehicle(plate: "CC333EE", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444GG", type: VehicleType.bus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "AA111DD", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007"),
    Vehicle(plate: "B222EEE", type: VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333FF", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "XX333EE", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "YY444GG", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_008"),
    Vehicle(plate: "AE147OD", type: VehicleType.moto, checkInTime: Date(), discountCard: "DISCOUNT_CARD_009"),
    Vehicle(plate: "AE770DD", type: VehicleType.moto, checkInTime: Date(), discountCard: "DISCOUNT_CARD_010"),
    Vehicle(plate: "JJ555HH", type: VehicleType.bus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "QC223GG", type: VehicleType.bus, checkInTime: Date(), discountCard: nil)
   ]

for vehicle in vehicles {
    alkeParking.checkInVehicle(vehicle) { result in
        print(result ? "Welcome to AlkeParking!" : "Sorry, the check-in failed")
    }
}

for vehicle in vehicles {
    alkeParking.checkOutVehicle(vehicle.plate) { fee in
        print("Your total ticket is $\(fee). Thanks for Your Visit")
    } onError: {
        print("Something went wrong")
    }

}

alkeParking.showTotals()
alkeParking.showAllPlates()
