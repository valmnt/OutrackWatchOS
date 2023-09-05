//
//  HKStatistics+Extension.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 01/09/2023.
//

import Foundation
import HealthKit

protocol HKStatisticsProtocol: AnyObject {
    var type: HKQuantityType { get }
    func mostRecentHearthRate() -> Double
    func sumActiveEnergyBurned() -> Double
    func sumDistance() -> Double
    func averageRunningSpeed() -> Double
}

extension HKStatistics: HKStatisticsProtocol {
    var type: HKQuantityType {
        return quantityType
    }

    func mostRecentHearthRate() -> Double {
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        return self.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
    }

    func averageHearthRate() -> Double {
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        return self.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
    }

    func sumActiveEnergyBurned() -> Double {
        let energyUnit = HKUnit.kilocalorie()
        return self.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
    }

    func sumDistance() -> Double {
        let meterUnit = HKUnit.meter()
        return (self.sumQuantity()?.doubleValue(for: meterUnit) ?? 0) / 1000
    }

    func averageRunningSpeed() -> Double {
        let speedUnit = HKUnit.meter().unitDivided(by: .second())
        let speedInMetersPerSecond = self.averageQuantity()?.doubleValue(for: speedUnit) ?? 0
        return speedInMetersPerSecond * 3.6
    }
}
