//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Alexey Kiparin on 05.01.2025.
//

import UIKit

protocol ReloadListViewDelegate: AnyObject {
	func reload()
}

final class TaskListViewController: UITableViewController {
	
	private var tasks: [UserTask] = []
	private let cellID = "tasks"
	private let dataManager = DataStorageManager.shared
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .white
		setupNavigationBar()
		fetchData()
	}
	
	@objc private func addTask() {
		let addTaskVC = NewTaskViewController()
		addTaskVC.delegate = self
		present(addTaskVC, animated: true)
	}
	
	private func fetchData() {
		let fetchRequest = UserTask.fetchRequest()
		do {
			tasks = try dataManager.persistentContainer.viewContext.fetch(fetchRequest)
		} catch {
			print(error)
		}
	}
}



//MARK: UITableViewDataSource
extension TaskListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tasks.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let taskToDo = tasks[indexPath.row]
		var content = cell.defaultContentConfiguration()
		content.text = taskToDo.title
		content.textProperties.font = .systemFont(ofSize: 20, weight: .semibold)
		content.textProperties.lineBreakMode = .byTruncatingTail
		content.textProperties.color = .black
		cell.contentConfiguration = content
		return cell
	}
}

//MARK: UpdateListViewProtocol
extension TaskListViewController: ReloadListViewDelegate {
	func reload() {
		fetchData()
		tableView.reloadData()
	}
}

//MARK: Setup UI
private extension TaskListViewController {
	func setupNavigationBar() {
		title = "Task List"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		navBarAppearance.backgroundColor = .milkGreen
		
		navBarAppearance.largeTitleTextAttributes = [
			.foregroundColor: UIColor.white
		]
		navBarAppearance.titleTextAttributes = [
			.foregroundColor: UIColor.white
		]
		
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addTask)
		)
		
		navigationController?.navigationBar.tintColor = .white
	}
	
	
}


