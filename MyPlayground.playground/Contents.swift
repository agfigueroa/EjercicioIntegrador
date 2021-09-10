import UIKit

import UIKit

protocol Parkable {
    var plate: String { get }
    var type: vehicleType { get }
}

struct Parking {
    var vehicles: Set<Vehicle> = []
    let maxVehicles = 20
}

struct Vehicle: Parkable, Hashable {
    let type: vehicleType
    let plate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

enum vehicleType {
    case bus
    case car
    case miniBus
    case motorcycle
    
    var rate: Int {
        switch self {
        case .bus:
            return 30
        case .car:
            return 20
        case .motorcycle:
            return 15
        case .miniBus:
            return 25
        }
    }
}
