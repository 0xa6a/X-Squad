//
//  EditSquadsViewController.swift
//  X-Squad
//
//  Created by Avario on 13/02/2019.
//  Copyright © 2019 Avario. All rights reserved.
//

import Foundation
import UIKit

class EditSquadsViewController: SquadsViewController {
	
	init() {
		super.init(emptyMessage: "You don't have any squads setup.\nUse the + button in the top right corner to create a new squad.")
		
		title = "Squads"
		tabBarItem = UITabBarItem(title: "Squads", image: UIImage(named: "Squads Tab"), selectedImage: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let addSquadButton = UIButton(type: .contactAdd)
		addSquadButton.addTarget(self, action: #selector(addSquad), for: .touchUpInside)
		addSquadButton.tintColor = UIColor.white.withAlphaComponent(0.5)
		
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64))
		headerView.addSubview(addSquadButton)
		
		addSquadButton.translatesAutoresizingMaskIntoConstraints = false
		
		addSquadButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
		addSquadButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
		addSquadButton.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
		addSquadButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		
		tableView.tableHeaderView = headerView
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let squad = squads[indexPath.row]
		tableView.deselectRow(at: indexPath, animated: true)

		let squadViewController = EditSquadViewController(for: squad)
		tabBarController!.present(squadViewController, animated: true, completion: nil)
	}
	
}
