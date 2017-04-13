//
//  AppDelegate.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 24/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import CoreData
import Realm
import RealmSwift
import FBSDKCoreKit
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var maskBgView = UIView()
    var launchScreenImageView = UIImageView()
    var xCenterConstraint = NSLayoutConstraint()
    var yCenterConstraint = NSLayoutConstraint()
    var initialViewController: UIViewController? = nil
    var navigationController: UIViewController?
    var isGrantedNotificationAccess:Bool = false


    func getDifferenceDays (user: User) -> Int {
        
        let lastSessionDate = Date(timeIntervalSince1970: (user.lastSessionTimeInterval))
        let lastDateInDays = Date().days(from: lastSessionDate)
        
        return lastDateInDays
    }
    
    func launchScreenAnimation () {
        
        self.maskBgView.frame = navigationController!.view.frame
        self.maskBgView.backgroundColor = UIColor.colorWithHexString("1BDBAD")
        
        self.navigationController?.view.addSubview(self.maskBgView)
        
        self.launchScreenImageView = UIImageView(image: UIImage(named: "LaunchScreenFrames1.png"))
        
        self.launchScreenImageView.frame = CGRect(x: 0, y: 0, width: 153, height: 153);
     
        self.launchScreenImageView.center = maskBgView.center
        
        maskBgView.addSubview(self.launchScreenImageView)
        
        self.launchScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        
        var images = [CGImage]()
        
        for i in 1..<71 {
            
            images.append((UIImage(named: "LaunchScreenFrames\(i)")?.cgImage)!)
        }
        
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
        
        animation.calculationMode = kCAAnimationDiscrete
        animation.duration = 70/24
        animation.values = images
        animation.repeatCount = 1
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.xCenterConstraint = NSLayoutConstraint(item: self.launchScreenImageView, attribute: .centerX, relatedBy: .equal, toItem: self.maskBgView, attribute: .centerX, multiplier: 1, constant: 0)

        self.yCenterConstraint = NSLayoutConstraint(item: self.launchScreenImageView, attribute: .centerY, relatedBy: .equal, toItem: self.maskBgView, attribute: .centerY, multiplier: 0.32, constant: 0)
        
        self.launchScreenImageView.layer.add(animation, forKey: "animation")
        
    }
    
    func getInitialStoryBoard() -> UIStoryboard {
        
        let mainStoryboard: UIStoryboard?
        
        if ApplicationState.sharedInstance.isFirstTime() {
            
            mainStoryboard = UIStoryboard(name: "Onboard", bundle: nil)
            
            ApplicationState.sharedInstance.setAfterFirstTime()
            
        } else if ApplicationState.sharedInstance.currentUser?.token != nil {
            
            mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
        } else {
            
            mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
        }
        
        return mainStoryboard!
    }

    func setInitialViewController() {
        
        let mainStoryboard = getInitialStoryBoard()
        
        self.navigationController = mainStoryboard.instantiateViewController(withIdentifier: "navigation")
        
        self.window!.rootViewController = navigationController
        
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        self.setupBarsAppearance()
        self.setInitialViewController()
        
        self.launchScreenAnimation()

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }

    func setupBarsAppearance(){
        
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let button = UIBarButtonItem.appearance()
        
        // Color of placeholder
        UILabel.appearance(whenContainedInInstancesOf: [UITextField.self]).textColor = UIColor.readingBlueColor()
        
        // Color and font of navigation bar
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().tintColor = UIColor.blue
        
        //Title color of navigation bar
        UINavigationBar.appearance().titleTextAttributes =
            ([NSFontAttributeName: UIFont(name: "Quicksand-Bold", size: 20)!,
                NSForegroundColorAttributeName: UIColor.white])
        
        button.setTitleTextAttributes(([NSFontAttributeName: UIFont(name: "Quicksand-Bold", size: 14)!,
            NSForegroundColorAttributeName: UIColor.readingBlueColor()]), for: UIControlState())
 
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Lab262.LeituraDeBolso" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "LeituraDeBolso", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

extension AppDelegate: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.60, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(), animations: {
            
            NSLayoutConstraint.activate([self.xCenterConstraint, self.yCenterConstraint])
            
            self.maskBgView.layoutIfNeeded()

            }, completion: { (finished) in
                
                if finished {
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.maskBgView.alpha = 0.0
                        }, completion: { (finished) in
                            
                            if finished {
                                self.maskBgView.removeFromSuperview()
                            }
                    })
                    
                }
        })
        
    }
}

