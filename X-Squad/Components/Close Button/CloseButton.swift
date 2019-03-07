//
//  CloseButton.swift
//  X-Squad
//
//  Created by Avario on 30/01/2019.
//  Copyright © 2019 Avario. All rights reserved.
//
// The "Close" button shown on many of the screens.

import Foundation
import UIKit

class CloseButton: UIButton {
	
	static let circleSize: CGFloat = 28
	
	let circleView = UIView()
	
	private let color = UIColor.white.withAlphaComponent(0.5)
	private let highlightColor = UIColor.white
	
	init() {
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(circleView)
		circleView.translatesAutoresizingMaskIntoConstraints = false
		circleView.isUserInteractionEnabled = false
		
		circleView.layer.cornerRadius = CloseButton.circleSize/2
		circleView.layer.borderColor = color.withAlphaComponent(0.2).cgColor
		circleView.layer.borderWidth = 1
		
		circleView.heightAnchor.constraint(equalToConstant: CloseButton.circleSize).isActive = true
		circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		circleView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		circleView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		
		titleLabel?.font = UIFont.systemFont(ofSize: 14)
		setTitleColor(color, for: .normal)
		setTitleColor(highlightColor, for: .highlighted)
		setTitle("Close", for: .normal)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	override open var isHighlighted: Bool {
		didSet {
			circleView.layer.borderColor = isHighlighted ? highlightColor.cgColor : color.withAlphaComponent(0.2).cgColor
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: 58, height: CloseButton.circleSize)
	}
}

