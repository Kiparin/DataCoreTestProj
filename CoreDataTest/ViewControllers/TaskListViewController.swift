//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Alexey Kiparin on 05.01.2025.
//

import UIKit

final class TaskListViewController: UITableViewController {
	// MARK: - Fiels
	private var tasks: [UserTask] = []
	private let cellID = "tasks"
	private let dataManager = DataStorageManager.shared
	
	// MARK: - Life Circle
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .white
		setupNavigationBar()
		tasks = fetchUserTask()
	}
	
	@objc private func addTask() {
		showAlert(title: "Add task", message: "Enter task title",buttonTitle: "Create" ,task: nil, actionType: .insert)
	}
	
}

// MARK: - UITableViewDataSource
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
		content.textProperties.color = .gray
		cell.contentConfiguration = content
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let selectedUser = tasks[indexPath.row]
		
		showAlert(title: "Update task", message: "Want to update task",buttonTitle: "Update" , task: selectedUser, actionType: .update)
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let taskToDelete = tasks[indexPath.row]
			deleteUserTask(taskToDelete)
			tasks.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}

// MARK: - Setup UI
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

// MARK: - CRUD Operations
extension TaskListViewController {
	
	func createUserTask(_ title: String) {
		let userTask = UserTask(context: dataManager.persistentContainer.viewContext)
		userTask.id = UUID()
		userTask.title = title
		
		tasks.append(userTask)
		tableView.insertRows(at: [IndexPath(row: tasks.count - 1, section: 0)], with: .automatic)
		dataManager.saveContext()
	}
	
	func fetchUserTask() -> [UserTask] {
		let fetchRequest = UserTask.fetchRequest()
		do {
			return try dataManager.persistentContainer.viewContext.fetch(fetchRequest)
		} catch {
			print("Failed to fetch persons")
			return []
		}
	}
	
	func updateUserTask(updatedUserTask: UserTask, newTitle: String) {
		if dataManager.persistentContainer.viewContext.insertedObjects.contains(updatedUserTask) {
			print("Failed: object is not in context.")
			return
		}
		
		updatedUserTask.title = newTitle
		if let index = tasks.firstIndex(where: { $0.id == updatedUserTask.id}) {
			tasks[index] = updatedUserTask
			tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
			dataManager.saveContext()
		}
	}
	
	func deleteUserTask(_ userTask: UserTask) {
		dataManager.persistentContainer.viewContext.delete(userTask)
		dataManager.saveContext()
	}
}

// MARK: - Alert
extension TaskListViewController {
	func showAlert(title: String, message: String, buttonTitle: String, task: UserTask?, actionType: TypeAction) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let saveAction = UIAlertAction(title: buttonTitle, style: .default) { [unowned self] _ in
			guard let textTask = alert.textFields?.first?.text else { return }
			if actionType == .insert {
				createUserTask(textTask)
			}
			else{
				updateUserTask(updatedUserTask: task!, newTitle: textTask)
			}
		}
		alert.addAction(saveAction)
		alert.addTextField { textField in
			if actionType == .insert {
				textField.placeholder = "Enter task title"
			}
			else {
				textField.text = task?.title
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel",style: .destructive)
		alert.addAction(cancelAction)
		present(alert, animated: true)
	}
}
