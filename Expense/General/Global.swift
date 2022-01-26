//
//  Global.swift
//  Ensurance
//
//  Created by Tung Xuan on 1/16/20.
//  Copyright © 2020 mdc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation



struct Global {
    static var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    }
    
    static func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func showError(_ description: String) {
        dpMain {
            Global.window?.topViewController().showAlert(title: "Lỗi", message: description)
        }
    }
    
    // MARK: - Temp
    struct Temp {
        
    }
    
    // MARK: - Permissions
    struct Permission {
        static func checkCameraAccess() -> Int {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                Log.d("Denied, request permission from settings")
                return 0
            case .restricted:
                Log.d("Restricted, device owner must approve")
                return 0
            case .authorized:
                Log.d("Authorized, proceed")
                return 1
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        Log.d("Permission granted, proceed")
                    } else {
                        Log.d("Permission denied")
                    }
                }
                return 2
            @unknown default:
                break
            }
            
            return 0
        }
        
        static func checkMicroAccess() -> Int {
            switch AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) {
            case .denied:
                Log.d("Denied, request permission from settings")
                return 0
            case .restricted:
                Log.d("Restricted, device owner must approve")
                return 0
            case .authorized:
                Log.d("Authorized, proceed")
                return 1
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio) { success in
                    if success {
                        Log.d("Permission granted, proceed")
                    } else {
                        Log.d("Permission denied")
                    }
                }
                return 2
            @unknown default:
                break
            }
            return 0
        }
        
        static func presentSettings(from vc: UIViewController) {
            Log.d("Settings")
            let alertController = UIAlertController(title: "Error".localized(),
                                                    message: "Camera or Micro access is denied".localized(),
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .default))
            alertController.addAction(UIAlertAction(title: "Settings".localized(), style: .cancel) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        // Handle
                    })
                }
            })
            
            DispatchQueue.main.async {
                vc.present(alertController, animated: true)
            }
        }
    }
}
