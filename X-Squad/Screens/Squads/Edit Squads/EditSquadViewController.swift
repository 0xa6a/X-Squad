//
//  EditSquadViewController.swift
//  X-Squad
//
//  Created by Avario on 13/02/2019.
//  Copyright © 2019 Avario. All rights reserved.
//
// This screen displays a squad (with the pilots stacked vertically) and allows the user to edit it.

import Foundation
import UIKit

class EditSquadViewController: SquadViewController {
	
	var memberViews: [EditMemberView] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let addPilotButton = SquadButton()
		addPilotButton.action = .add("Add Pilot")
		addPilotButton.addTarget(self, action: #selector(addPilot), for: .touchUpInside)
		
		stackView.addArrangedSubview(addPilotButton)
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateMemberViews), name: .squadStoreDidAddMemberToSquad, object: squad)
		NotificationCenter.default.addObserver(self, selector: #selector(updateMemberViews), name: .squadStoreDidRemoveMemberFromSquad, object: squad)
	}
	
	override func memberView(for member: Squad.Member) -> UIView {
		if let existingMemberView = memberViews.first(where: { $0.member.uuid == member.uuid }) {
			return existingMemberView
		} else {
			let squadMemberView = EditMemberView(member: member)
			squadMemberView.memberView.delegate = self
			memberViews.append(squadMemberView)
			
			return squadMemberView
		}
	}
	
	override func updateMemberViews() {
		// Remove any members that are no longer in the squad
		for memberView in memberViews {
			if !squad.members.contains(where: { $0.uuid == memberView.member.uuid }) {
				memberView.removeFromSuperview()
			}
		}
		memberViews = memberViews.filter({ $0.superview != nil })
		
		super.updateMemberViews()
	}
	
	@objc func addPilot() {
		let addPilotViewController = AddPilotViewController(squad: squad)
		present(addPilotViewController, animated: true, completion: nil)
	}
	
	func deleteSquad() {
		SquadStore.shared.delete(squad: squad)
		
		for cardView in CardView.all(in: view) {
			cardView.member = nil
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	func duplicateSquad() {
		let duplicateMembers = squad.members.map({ Squad.Member(ship: $0.ship, pilot: $0.pilot, upgrades: $0.upgrades) })
		let duplicateSquad = Squad(
			faction: squad.faction,
			members: duplicateMembers,
			name: squad.name,
			description: squad.description,
			obstacles: squad.obstacles,
			vendor: squad.vendor,
			isHyperspace: squad.isHyperspaceOnly)
		
		SquadStore.shared.add(squad: duplicateSquad)
		
		let tabViewController = self.presentingViewController!
		dismiss(animated: true) {
			let squadViewController = EditSquadViewController(for: duplicateSquad)
			tabViewController.present(squadViewController, animated: true, completion: nil)
		}
	}
	
	func toggleHyperspace(isHyperspaceOnly: Bool) {
		squad.isHyperspaceOnly.toggle()
		header.hyperspaceLabel.isHidden = !squad.isHyperspaceOnly
	}
	
	override func infoActions() -> [SquadInfoAction] {
		return [
			SquadInfoAction(
				title: "Hyperspace Only",
				image: UIImage(named: "Hyperspace Icon")!,
				type: .toggle(self.toggleHyperspace(isHyperspaceOnly:), isOn: squad.isHyperspaceOnly)
				)] +
			super.infoActions() + [
			SquadInfoAction(
				title: "Duplicate Squad",
				image: UIImage(named: "Duplicate Icon")!,
				type: .action(self.duplicateSquad, destructive: false)
			),
			SquadInfoAction(
				title: "Delete Squad",
				image: UIImage(named: "Delete Icon")!,
				type: .action(self.deleteSquad, destructive: true)
			)
		]
	}
	
}
