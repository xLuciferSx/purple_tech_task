//
//  NetworkManager.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Network

protocol NetworkManagerProtocol: Sendable {
  var isOnline: Bool { get }
}

final class NetworkManager: NetworkManagerProtocol, Sendable {
  static let shared = NetworkManager()

  private let monitor = NWPathMonitor()
  private var currentStatus = true

  init() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.currentStatus = path.status == .satisfied
    }
    let queue = DispatchQueue(label: "NetworkMonitorQueue")
    monitor.start(queue: queue)
  }

  var isOnline: Bool { currentStatus }
}
