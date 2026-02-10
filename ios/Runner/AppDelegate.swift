import UIKit
import Flutter
import FirebaseCore
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase эхлүүлэх
    FirebaseApp.configure()
    
    // Google Maps API key
    GMSServices.provideAPIKey("AIzaSyATQ04t09yCNRhs19ITI3mUXyq3SMR1NFM")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
