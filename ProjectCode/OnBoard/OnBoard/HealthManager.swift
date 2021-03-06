//
//  HealthManager.swift
//  OnBoard
//
//  Created by Louis Chan on 2015-12-05.
//  Copyright (c) 2015 Rainbow Riders. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    let HKStore : HKHealthStore = HKHealthStore()

    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!) {
        let HKTypesRead = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
            HKObjectType.workoutType()
            ]
    
        let HKTypesWritten = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned),
            HKObjectType.workoutType()
            ]
    
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.rainbowriders.onboard.ios", code: 343, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
    
        HKStore.requestAuthorizationToShareTypes(Set(HKTypesWritten), readTypes: Set(HKTypesRead)) { (success, error) -> Void in
        
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        }
    }

    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!) {
        let past = NSDate.distantPast() as! NSDate
        let present = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate: present, options: .None)
    
        let limit : Int = 1
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
    
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
            
                if let queryError = error {
                    completion(nil,error)
                    return;
                }
        let mostRecentSample = results.first as? HKQuantitySample
            if completion != nil {
                completion(mostRecentSample,nil)
            }
    }
    self.HKStore.executeQuery(sampleQuery)
}
    
    func saveSkiSession(startDate:NSDate, endDate:NSDate, distance:Double, distanceUnit:HKUnit, kiloCalories:Double,
        completion: ( (Bool, NSError!) -> Void)!) {
            let distanceQuantity = HKQuantity(unit: distanceUnit, doubleValue: distance)
            let calorieQuantity = HKQuantity(unit: HKUnit.calorieUnit(), doubleValue: kiloCalories)
            
            let workout = HKWorkout(activityType: HKWorkoutActivityType.SnowSports, startDate: startDate, endDate: endDate, duration: abs(endDate.timeIntervalSinceDate(startDate)), totalEnergyBurned: calorieQuantity, totalDistance: distanceQuantity, metadata: nil)
            HKStore.saveObject(workout, withCompletion: { (success, error) -> Void in
                if error != nil {
                    completion(success, error)
                }
                else {
                    completion(success, nil)
                }
            })
        
    }
}
