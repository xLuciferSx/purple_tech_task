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
  var updates: AsyncStream<Bool> { get }
}

final class NetworkManager: NetworkManagerProtocol, @unchecked Sendable {
  static let shared = NetworkManager()

  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkMonitor")

  private var continuation: AsyncStream<Bool>.Continuation?
  private(set) var isOnline = true

  let updates: AsyncStream<Bool>

  private init() {
    var tempContinuation: AsyncStream<Bool>.Continuation?

    self.updates = AsyncStream { continuation in
      tempContinuation = continuation
    }

    self.continuation = tempContinuation

    monitor.pathUpdateHandler = { [weak self] path in
      guard let self else { return }
      let online = (path.status == .satisfied)
      self.isOnline = online
      self.continuation?.yield(online)
    }

    monitor.start(queue: queue)
  }
}
