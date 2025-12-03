//
//  NetworkManager.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Network
import Foundation

protocol NetworkManagerProtocol: Sendable {
  var isOnline: Bool { get }
  func networkPublisher() -> AsyncStream<Bool>
}

final class NetworkManager: NetworkManagerProtocol, @unchecked Sendable {
  static let shared = NetworkManager()

  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkMonitor")

  private var currentStatus: Bool = true

  var isOnline: Bool {
    currentStatus
  }

  private init() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.currentStatus = path.status == .satisfied
    }
    monitor.start(queue: queue)
  }

  func networkPublisher() -> AsyncStream<Bool> {
    AsyncStream { continuation in
      monitor.pathUpdateHandler = { [weak self] path in
        let isConnected = path.status == .satisfied
        self?.currentStatus = isConnected
        continuation.yield(isConnected)
      }
    }
  }
}
