//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by nexsoft on 8/12/25.
//

import Flutter
import UIKit
import MobileCoreServices

class ShareViewController: UIViewController {
    var channel: FlutterMethodChannel?

    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedData()
    }

    func handleSharedData() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
            showFlutter()
            return
        }

        var sharedData: [String: Any] = [:]
        let group = DispatchGroup()

        for item in items {
            for attachment in item.attachments ?? [] {
                group.enter()
                if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) { (text, error) in
                        if let sharedText = text as? String {
                            sharedData["text"] = sharedText
                        }
                        group.leave()
                    }
                } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) { (data, error) in
                        if let url = data as? URL, let imageData = try? Data(contentsOf: url) {
                            sharedData["image"] = imageData
                        } else if let imageData = data as? Data {
                            sharedData["image"] = imageData
                        }
                        group.leave()
                    }
                } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (url, error) in
                        if let sharedURL = url as? URL {
                            sharedData["url"] = sharedURL.absoluteString
                        }
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.showFlutter()
            self.channel?.invokeMethod("sharedData", arguments: sharedData)
        }
    }

    func showFlutter() {
        let flutterEngine = FlutterEngine(name: "ShareViewController")
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        channel = FlutterMethodChannel(name: "com.example.app/share", binaryMessenger: flutterViewController.binaryMessenger)
        
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds

        let dismissRecognizer = MyShareExtensionDismissControlRecognizer(strategy: .topRegion)
        flutterViewController.view.addGestureRecognizer(dismissRecognizer)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        extensionContext?.cancelRequest(
            withError: NSError(domain: Bundle.main.bundleIdentifier!, code: 0)
        )
    }
}
