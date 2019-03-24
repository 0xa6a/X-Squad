//
//  CardImageView.swift
//  X-Squad
//
//  Created by Avario on 03/01/2019.
//  Copyright © 2019 Avario. All rights reserved.
//
// This is a simple view that diplays the image for a card.

import Foundation
import UIKit
import Kingfisher

class CardView: UIView {
	
	let cardContainer = UIView()
	private var imageView = UIImageView()
	
	// This is used for transitions (cards that aren't visibile shouldn't be transitioned).
	var isVisible = true
	
	// This is the proportion of the upgrade card hidden beneath it's adjacent card.
	static var upgradeHiddenRatio: CGFloat = 0.395
	
	// Card width to height ratio
	static var sizeRatio: CGFloat = 1.39
	static func heightMultiplier(for card: Card) -> CGFloat {
		switch card.orientation {
		case .portrait:
			return sizeRatio
		case .landscape:
			return 1/sizeRatio
		}
	}
	
	var card: Card? {
		didSet {
			side = .front
		}
	}
	
	enum Side {
		case front
		case back
	}
	
	var side: Side = .front {
		didSet {
			updateImage()
		}
	}
	
	func flip() {
		let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
		
		UIView.transition(with: self, duration: 0.4, options: transitionOptions, animations: {
			switch self.side {
			case.front:
				self.side = .back
			case .back:
				self.side = .front
			}
		})
	}
	
	// The member is used to distinguish cards that might be the same but attached to different pilots during transitions.
	var member: Squad.Member?
	
	init() {
		super.init(frame: .zero)
		
		addSubview(cardContainer)
		cardContainer.translatesAutoresizingMaskIntoConstraints = false
		cardContainer.clipsToBounds = true
		cardContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
		
		cardContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
		cardContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		cardContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		cardContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		
		cardContainer.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.kf.indicatorType = .activity
		if let activityIndicator = imageView.kf.indicator?.view as? UIActivityIndicatorView {
			activityIndicator.style = .white
			activityIndicator.alpha = 0.25
		}
		
		imageView.centerXAnchor.constraint(equalTo: cardContainer.centerXAnchor).isActive = true
		imageView.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor).isActive = true
		imageView.widthAnchor.constraint(equalTo: cardContainer.widthAnchor, multiplier: 1.008).isActive = true
		imageView.heightAnchor.constraint(equalTo: cardContainer.heightAnchor, multiplier: 1.008).isActive = true
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateImage), name: .dataStoreShowImagesDidChange, object: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	@objc func updateImage() {
		if DataStore.showImages {
			switch side {
			case.front:
				imageView.kf.setImage(with: card?.frontImage)
			case .back:
				imageView.kf.setImage(with: card?.backImage)
			}
		} else {
			imageView.image = card?.placeholderImage
		}
	}
	
	static func all(in view: UIView) -> [CardView] {
		var cardViews: [CardView] = []
		for subview in view.subviews {
			if let cardView = subview as? CardView, cardView.isVisible  {
				cardViews.append(cardView)
			}
			cardViews.append(contentsOf: CardView.all(in: subview))
		}
		return cardViews
	}
	
	// Used to identify matching cards for transitions
	func matches(_ cardView: CardView) -> Bool {
		guard let card = card,
			let cardToMatch = cardView.card,
			card.matches(cardToMatch) else {
			return false
		}
		
		guard member == cardView.member else {
			return false
		}
		
		return true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		cardContainer.layer.cornerRadius = bounds.width * 0.038
		cardContainer.layer.borderWidth = bounds.width * 0.0025
	}
	
}

