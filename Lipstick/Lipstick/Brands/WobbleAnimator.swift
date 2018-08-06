//
//  WobbleAnimator.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-08-15.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit
import CollectionKit
import YetAnotherAnimationLibrary


open class WobbleAnimator: Animator {
    
  public var sensitivity: CGPoint = CGPoint(x: 1, y: 2)

  func scrollVelocity(collectionView: CollectionView) -> CGPoint {
    guard collectionView.hasReloaded else {
      return .zero
    }
    let velocity = collectionView.bounds.origin - collectionView.lastLoadBounds.origin
    if collectionView.isReloading {
      return velocity - collectionView.contentOffsetChange
    } else {
      return velocity
    }
  }

  open override func shift(collectionView: CollectionView, delta: CGPoint, view: UIView, at: Int, frame: CGRect) {
    view.center = view.center + delta
    view.yaal.center.updateWithCurrentState()
  }

  open override func insert(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
    super.insert(collectionView: collectionView, view: view, at: at, frame: frame)
    let screenDragLocation = collectionView.absoluteLocation(for: collectionView.panGestureRecognizer.location(in: collectionView))
    let delta = scrollVelocity(collectionView: collectionView) * 8
    view.bounds.size = frame.bounds.size
    let cellDiff = frame.center - collectionView.contentOffset - screenDragLocation
    let resistance = (cellDiff * sensitivity).distance(.zero) / 1000
    let newCenterDiff = delta * resistance
    let constrainted = CGPoint(x: delta.x > 0 ? min(delta.x, newCenterDiff.x) : max(delta.x, newCenterDiff.x),
                               y: delta.y > 0 ? min(delta.y, newCenterDiff.y) : max(delta.y, newCenterDiff.y))
    view.center += constrainted
    view.yaal.center.updateWithCurrentState()
    view.yaal.center.animateTo(frame.center, stiffness: 250, damping: 30, threshold:0.5)
  }

  open override func update(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
    let screenDragLocation = collectionView.absoluteLocation(for: collectionView.panGestureRecognizer.location(in: collectionView))
    let delta = scrollVelocity(collectionView: collectionView)
    view.bounds.size = frame.bounds.size
    let cellDiff = frame.center - collectionView.contentOffset - screenDragLocation
    let resistance = (cellDiff * sensitivity).distance(.zero) / 1000
    let newCenterDiff = delta * resistance
    let constrainted = CGPoint(x: delta.x > 0 ? min(delta.x, newCenterDiff.x) : max(delta.x, newCenterDiff.x),
                               y: delta.y > 0 ? min(delta.y, newCenterDiff.y) : max(delta.y, newCenterDiff.y))
    view.center += constrainted
    view.yaal.center.updateWithCurrentState()
    view.yaal.center.animateTo(frame.center, stiffness: 250, damping: 30, threshold:0.5)
  }
}


import UIKit

extension Array {
    func get(_ index: Int) -> Element? {
        if (0..<count).contains(index) {
            return self[index]
        }
        return nil
    }
}

extension Collection {
    /// Finds such index N that predicate is true for all elements up to
    /// but not including the index N, and is false for all elements
    /// starting with index N.
    /// Behavior is undefined if there is no such N.
    func binarySearch(predicate: (Iterator.Element) -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high)/2)
            if predicate(self[mid]) {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
}

extension CGFloat {
    func clamp(_ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        return self < minValue ? minValue : (self > maxValue ? maxValue : self)
    }
}

extension CGPoint {
    func translate(_ dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x+dx, y: self.y+dy)
    }
    
    func transform(_ trans: CGAffineTransform) -> CGPoint {
        return self.applying(trans)
    }
    
    func distance(_ point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2)+pow(self.y - point.y, 2))
    }
    
    var transposed: CGPoint {
        return CGPoint(x: y, y: x)
    }
}

extension CGSize {
    func insets(by insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - insets.left - insets.right, height: height - insets.top - insets.bottom)
    }
    var transposed: CGSize {
        return CGSize(width: height, height: width)
    }
}

func abs(_ left: CGPoint) -> CGPoint {
    return CGPoint(x: abs(left.x), y: abs(left.y))
}
func min(_ left: CGPoint, _ right: CGPoint) -> CGPoint {
    return CGPoint(x: min(left.x, right.x), y: min(left.y, right.y))
}
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func += (left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}
func + (left: CGRect, right: CGPoint) -> CGRect {
    return CGRect(origin: left.origin + right, size: left.size)
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func - (left: CGRect, right: CGPoint) -> CGRect {
    return CGRect(origin: left.origin - right, size: left.size)
}
func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x/right, y: left.y/right)
}
func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x*right, y: left.y*right)
}
func * (left: CGFloat, right: CGPoint) -> CGPoint {
    return right * left
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x*right.x, y: left.y*right.y)
}
prefix func - (point: CGPoint) -> CGPoint {
    return CGPoint.zero - point
}
func / (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width/right, height: left.height/right)
}
func - (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x - right.width, y: left.y - right.height)
}

prefix func - (inset: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: -inset.top, left: -inset.left, bottom: -inset.bottom, right: -inset.right)
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
    init(center: CGPoint, size: CGSize) {
        self.init(origin: center - size / 2, size: size)
    }
    var transposed: CGRect {
        return CGRect(origin: origin.transposed, size: size.transposed)
    }
    func inset(by insets: UIEdgeInsets) -> CGRect {
        return UIEdgeInsetsInsetRect(self, insets)
    }
}

func delay(_ delay: Double, closure:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
