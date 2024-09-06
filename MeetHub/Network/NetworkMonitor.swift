//
//  NetworkMonitor.swift
//  MeetHub
//
//  Created by 이찬호 on 9/4/24.
//

import Foundation
import Network

final class NetworkMonitor {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    init() {
        monitor = NWPathMonitor()
//        dump(monitor)
//        print("----------")
        print("모니터 Init")
    }
    
    deinit {
        print("모니터 deinit")
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    statusUpdateHandler(path.status)
                }
            }
            monitor.start(queue: queue)
        }
        
        func stopMonitoring() {
            monitor.cancel()
        }
}
