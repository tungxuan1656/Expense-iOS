//
//  View+Helper.swift
//
//
//  Created by Tùng Xuân on 8/16/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import Foundation
import UIKit

// MARK: GradientView
@IBDesignable
class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor?.cgColor ?? UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: shadowOffset.width, height: shadowOffset.height)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor ?? UIColor.black.cgColor
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
    }
}

// MARK: Radian Gradient View
class TXRadianGradientView: UIView {
    var radianLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .systemPink {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var centerColor: UIColor = .systemRed {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var location: Float = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.radianLayer = self.layer as? CAGradientLayer
        radianLayer.type = .radial
        radianLayer.colors = [self.centerColor.withAlphaComponent(0), self.centerColor.withAlphaComponent(0), self.centerColor.cgColor, self.topColor.cgColor]
        let n = NSNumber.init(value: location)
        radianLayer.locations = [0, n, n, 1]
        radianLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        radianLayer.endPoint = CGPoint(x: 1, y: 1)
        radianLayer.cornerRadius = bounds.width / 2.0
    }
}

// MARK: Custom View
//@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
            self.updateShadow()
        }
        get {
            return layer.shadowOffset
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
            self.updateShadow()
        }
        get {
            return layer.shadowRadius
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
            self.updateShadow()
        }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    func updateShadow() {
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layoutSubviews()
    }
}

// MARK: Custom Corner View
class TXCornerView: UIView {
    @IBInspectable var topLeft: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var topRight: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var bottomRight: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var bottomLeft: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    override func layoutSubviews() {
        var corner: CACornerMask = []
        if topLeft { corner.insert(.layerMinXMinYCorner) }
        if topRight { corner.insert(.layerMaxXMinYCorner) }
        if bottomRight { corner.insert(.layerMaxXMaxYCorner) }
        if bottomLeft { corner.insert(.layerMinXMaxYCorner) }
        self.layer.maskedCorners = corner
    }
}

// MARK: Custom ProgressView
class TXCustomProgressView: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}


// MARK: CALayer Shadow
extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0,
        y: CGFloat = 10,
        blur: CGFloat = 15,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func applyCornerRadiusAndShadow(radius: CGFloat = 10,
                                    color: UIColor = .black,
                                    alpha: Float = 0.2,
                                    x: CGFloat = 0,
                                    y: CGFloat = 10,
                                    blur: CGFloat = 15,
                                    spread: CGFloat = 0) {
        cornerRadius = radius
        applySketchShadow(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread)
    }
}

// MARK: UIView loadNib
extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

// MARK: UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(rgb: Int, a: CGFloat) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: a
        )
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


extension UITextView {
    static func adjustUITextViewHeight(textView : UITextView, width: CGFloat = 0) -> CGFloat {
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = true
        var fixedWidth: CGFloat = 0
        if width != 0 {
            fixedWidth = width
        }
        else {
            fixedWidth = Constant.screenWidth - 40
        }
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = textView.frame
        let height = CGFloat(Int(newSize.height)) + 1
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        textView.frame = newFrame
        textView.isScrollEnabled = false
        return height
    }
    
    static func getFitHeight(textView : UITextView, width: CGFloat = 0) -> CGFloat {
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = true
        var fixedWidth: CGFloat = 0
        if width != 0 {
            fixedWidth = width
        }
        else {
            fixedWidth = Constant.screenWidth - 40
        }
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        let height = CGFloat(Int(newSize.height)) + 1
        textView.isScrollEnabled = false
        return height
    }
}

// MARK: - UIButton
extension UIButton {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesCancelled(touches, with: event)
    }
}

// MARK: - UILabel
extension UILabel {
    var optimalHeight : CGFloat {
        get {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.height
        }
    }
    
    var optimalWidth : CGFloat {
        get {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: self.frame.height))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.width
        }
    }
}

// MARK: - View Custom Border
extension UIView {
    enum ViewBorder: String {
        case left, right, top, bottom
    }
    
    func add(border: ViewBorder, color: UIColor? = .red, width: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color?.cgColor
        borderLayer.name = border.rawValue
        switch border {
        case .left:
            borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        case .top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .bottom:
            borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        }
        self.layer.addSublayer(borderLayer)
    }
    
    func remove(border: ViewBorder) {
        guard let sublayers = self.layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == border.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
}


// MARK: - Localize
extension UILabel {
    @IBInspectable var localizeText: String {
        set(value) {
            self.text = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UIButton {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.setTitle(NSLocalizedString(value, comment: ""), for: .normal)
        }
        get {
            return ""
        }
    }
}

extension UITextField {
    @IBInspectable var localizePlaceholder: String {
        set(value) {
            self.placeholder = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UITabBarItem {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.title = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UIBarButtonItem {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.title = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UINavigationItem {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.title = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}


// MARK: - Refresh Control
extension UIRefreshControl {
    func autoEndRefreshing(delay: TimeInterval = 3) {
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.endRefreshing()
        }
    }
}

// MARK: - Custom Slider
open class CustomSlider : UISlider {
    
    @IBInspectable open var trackHeight:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = trackHeight
        return newBounds
    }
}

class TXSegmented: UISegmentedControl {
    @IBInspectable var colorSelect: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var colorNormal: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let attSelect: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: colorSelect]
        let attNormal: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: colorNormal]
        
        self.setTitleTextAttributes(attSelect, for: .selected)
        self.setTitleTextAttributes(attNormal, for: .normal)
    }
}
