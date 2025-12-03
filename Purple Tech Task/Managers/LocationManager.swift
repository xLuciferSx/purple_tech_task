//
//  LocationManager.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import CoreLocation
import Foundation

protocol LocationManagerProtocol: Sendable {
  func currentLocation() async throws -> CLLocationCoordinate2D
}

enum LocationManagerError: Error, Equatable {
  case notAuthorized
  case unableToDetermineLocation
}

final class LocationManager: NSObject, LocationManagerProtocol, Sendable {
  static let shared = LocationManager()

  private let manager: CLLocationManager
  private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

  override init() {
    self.manager = CLLocationManager()
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
  }

  func currentLocation() async throws -> CLLocationCoordinate2D {
    if manager.authorizationStatus == .notDetermined {
      manager.requestWhenInUseAuthorization()
      return try await withCheckedThrowingContinuation { continuation in
        self.continuation = continuation
      }
    }

    guard manager.authorizationStatus == .authorizedAlways ||
      manager.authorizationStatus == .authorizedWhenInUse
    else {
      throw LocationManagerError.notAuthorized
    }

    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation
      manager.requestLocation()
    }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
      case .authorizedAlways, .authorizedWhenInUse:
        manager.requestLocation()
      case .denied, .restricted:
        continuation?.resume(throwing: LocationManagerError.notAuthorized)
        continuation = nil
      default:
        break
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard
      let continuation,
      let coordinate = locations.first?.coordinate
    else { return }

    continuation.resume(returning: coordinate)
    self.continuation = nil
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    continuation?.resume(throwing: LocationManagerError.unableToDetermineLocation)
    continuation = nil
  }
}
