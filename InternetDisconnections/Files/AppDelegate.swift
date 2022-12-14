//
//  AppDelegate.swift
//  InternetDisconnectionsApp
//
//  Created by Ofir Goren on 03/11/2022.
//

import UIKit
import BackgroundTasks
import OSLog
import Network
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let appRefreshTaskId = "internetDisconnectionsId"
    let sqlHandler = SQLiteHandler()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sqlHandler.createTable()
        Task {
           await sqlHandler.initRows()
        }
        sqlHandler.updateAccordingDisconnections()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: appRefreshTaskId, using: nil) { task in
            
               
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
            
            
        }
        return true
        
    }
    
    
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        print("FDssfd")
        sqlHandler.updateAccordingDisconnections()
        
        task.setTaskCompleted(success: true)
        
    }
    
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier:appRefreshTaskId)
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60) // Refresh after 2 minutes.
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh task \(error.localizedDescription)")
        }
    }
    
    
    
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("enter background")
      //  scheduleAppRefresh()
        
        
    }
  
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

