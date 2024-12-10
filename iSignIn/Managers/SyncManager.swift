//
//  SyncManager.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-02-15.
//
import Foundation
import BackgroundTasks
import UIKit

class SyncManager {
    
    static let shared = SyncManager()
    
    private init () {
        registerForBackgroundTasks()
    }
    
    private let _backgroundTaskDelayTime: TimeInterval = 0
    
    
    private let bgTaskId = "com.truecharge.irc.backgroundSync"
    
    private lazy var _downsyncQueue: OperationQueue = {
        return _createNewDownSyncQueue()
    }()
    
    private func _createNewDownSyncQueue () -> OperationQueue {
        let queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }
    
    private lazy var _upsyncQueue: OperationQueue = {
        return _createNewUpSyncQueue()
    }()
    
    private func _createNewUpSyncQueue () -> OperationQueue {
        let queue = OperationQueue()
        queue.name = "Upload queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }
        
    private lazy var _backgroundSyncQueue: OperationQueue = {
        return createNewBackgroundQueue()
    }()
    
    private func createNewBackgroundQueue () -> OperationQueue {
        let queue = OperationQueue()
        queue.name = "Background Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }
    
    //MARK: - Interface methods
    
    
    func startSync () {

        _scheduleNextDownSyncOperation()
        _scheduleUpSyncOperation()
        
    }
    
    
    func notifyRequiresUpSync() {
        _scheduleUpSyncOperation()
    }
    
    //MARK: - Private methods
    
        
    //MARK: - DownSync
    
    private func _scheduleNextDownSyncOperation () {

        let downSyncOp = DownSyncOperation(backgroundTask: false)
        downSyncOp.qualityOfService = .background
        downSyncOp.completionBlock = { [weak self] in
            guard !downSyncOp.isCancelled else {
                return
            }
            guard let strongSlf = self else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: strongSlf._getNextDownSyncOperationTime()) {
                strongSlf._scheduleNextDownSyncOperation()
            }
        }
        _downsyncQueue.addOperation(downSyncOp)
    }
    
    private func _getNextDownSyncOperationTime () -> DispatchTime {
        return .now() + 10
    }
    
    
    private class DownSyncOperation: Operation {
        
        private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        
        private var _isBackgroundTask = false
        private var _isForcedSync = false
        
        init(backgroundTask: Bool, forced: Bool = false) {
            self._isBackgroundTask = backgroundTask
        }
        
        override func main() {
            
            guard APIManager.shared.currentUserState == .signedIn else {
                return
            }
            
            if isCancelled {
                return
            }
            
            let group = DispatchGroup()
            group.enter()
            APIManager.shared.syncProgramAnalytics { _ in
                APIManager.shared.syncRegistrationAnalytics { _ in
                    APIManager.shared.syncProgramRegistrationExpenses { _ in
                    APIManager.shared.syncExpensesAnalytics { _ in
                        APIManager.shared.syncProgramGlobalAnalytics{ _ in
                            APIManager.shared.syncRegistrationGlobalAnalytics{ _ in
                                APIManager.shared.syncPrograms { _ in
                                    APIManager.shared.syncCosts { _ in
                                        APIManager.shared.syncBrands { _ in
                                            APIManager.shared.syncTimezones { _ in
                                                APIManager.shared.syncDegrees { _ in
                                                    APIManager.shared.syncSpeciality { _ in
                                                        APIManager.shared.syncStates { _ in
                                                            group.leave()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                          }
                        }
                    }
                }
            }
            group.wait()
        }

    }
    
    //MARK: - UpSync
    
    
    private func _scheduleUpSyncOperation () {

        let upSyncOp = UpSyncOperation()
        upSyncOp.qualityOfService = .background
        upSyncOp.completionBlock = { [weak self] in
            guard !upSyncOp.isCancelled else {
                return
            }
            guard let strongSlf = self else {
                return
            }
            let attendeesToSubmit = RealmManager.shared.getAttendeesToSubmit(program: nil)
            if attendeesToSubmit.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    strongSlf._scheduleUpSyncOperation()
                }
            }
        }
        _upsyncQueue.addOperation(upSyncOp)
    }
    
    private class UpSyncOperation: Operation {
        
        override func main() {
            
            guard APIManager.shared.currentUserState == .signedIn else {
                return
            }
            
            if isCancelled {
                return
            }
            
            let group = DispatchGroup()
            group.enter()
            
//            APIManager.shared.uploadAttendees(program: nil, signatureImage: nil) { _ in
//                
//                group.leave()
//
//            }
            
            group.wait()
            print("UpSyncOperation finished")
            
        }

    }
    
    //MARK: - Background Tasks
    
    private func registerForBackgroundTasks () {
        if #available(iOS 13, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: bgTaskId, using: nil) { task in
                 self.handleAppRefresh(task: task as! BGProcessingTask)
            }
        }
    }
    
    @objc private func startBackgroundSync () {
        if #available(iOS 13, *) {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            scheduleAppRefresh()
        }
        print("breakpoint")
    }
    
    @available(iOS 13, *)
    private func handleAppRefresh(task: BGProcessingTask) {
        let operation = DownSyncOperation(backgroundTask: true)
           
        task.expirationHandler = {
            operation.cancel()
        }
        
        operation.completionBlock = { [weak self] in
            defer {
                task.setTaskCompleted(success: !operation.isCancelled)
            }
            guard !operation.isCancelled else {
                return
            }
            if let strongSlf = self {
                strongSlf.scheduleAppRefresh()
            }
            
            
        }

        _backgroundSyncQueue.addOperation(operation)
    }
    
    @available(iOS 13, *)
    func scheduleAppRefresh() {
        
        let request = BGProcessingTaskRequest(identifier: bgTaskId)
        request.earliestBeginDate = Date().addingTimeInterval(_backgroundTaskDelayTime)
            
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
