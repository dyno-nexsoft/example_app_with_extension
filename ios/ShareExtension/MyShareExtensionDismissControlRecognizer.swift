//
//  MyShareExtensionDismissControlRecognizer.swift
//  MyShareExtension
//
//  Created by Huan Lin on 3/31/25.
//

import UIKit

final class MyShareExtensionDismissControlRecognizer: UIGestureRecognizer {
  
  enum DismissStrategy {
    case topRegion
    case prohibited
  }
  
  private let strategy: DismissStrategy
  
  private var beganLocation: CGPoint = .zero
  private var dismissRecognizer: UIGestureRecognizer? = nil
  
  init(strategy: DismissStrategy) {
    self.strategy = strategy
    super.init(target: nil, action: nil)
    
    delegate = self
  }
  
  private func setDismissRecognizerEnabled(location: CGPoint) {
    dismissRecognizer?.isEnabled = location.y <= 50
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else { return }
    beganLocation = touch.location(in: view)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    state = .failed
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    state = .cancelled
  }
}

extension MyShareExtensionDismissControlRecognizer: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
  
    if (dismissRecognizer == nil && otherGestureRecognizer.isBackgroundDismissRecognizer) {
      dismissRecognizer = otherGestureRecognizer
      
      switch strategy {
      case .topRegion:
        setDismissRecognizerEnabled(location: beganLocation)
      case .prohibited:
        dismissRecognizer?.isEnabled = false
      }
    }
    return false
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    switch strategy {
    case .topRegion:
      setDismissRecognizerEnabled(location: touch.location(in: touch.view))
    case .prohibited:
      break
    }
    return true
  }
}

fileprivate extension UIGestureRecognizer {
  var isBackgroundDismissRecognizer: Bool {
    return name?.hasSuffix("UISheetInteractionBackgroundDismissRecognizer") ?? false
  }
}
