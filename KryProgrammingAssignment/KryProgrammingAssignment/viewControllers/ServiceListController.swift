//
//  ViewController.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import UIKit

class ServiceListController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!

   
    // MARK: Private Properties

    private var serviceList: [Service] = [Service]()

    override func viewDidLoad() {
        super.viewDidLoad()

        ApiService.sharedInstance.getServiceCallback = { [weak self] in

            if let storedServices = ServiceStore.sharedInstance.storedServiceList {
                self?.serviceList = storedServices
                self?.tableView.reloadData()
            }
        }

        if let storedServices = ServiceStore.sharedInstance.storedServiceList {
            serviceList = storedServices
        }

        ApiService.sharedInstance.getAllServiceStatus() { (services, error) in

            if error == .generic {
                return
            }
            guard let services = services else {
                return
            }
            self.serviceList = services
            self.tableView.reloadData()
        }
    }


    @IBAction func addServiceAction(_ sender: Any) {
        performSegue(withIdentifier: "addServiceSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "addServiceSegue") {
            let destination = segue.destination as! AddServiceController
            destination.serviceAddedCallback = { [weak self] in

                if let storedServices = ServiceStore.sharedInstance.storedServiceList {
                    self?.serviceList = storedServices
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: UITableView Functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.serviceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell: ServiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ServiceCell else {
            return UITableViewCell()
        }
        cell.setData(service: self.serviceList[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == .delete) {

            serviceList.remove(at: indexPath.row)
            ServiceStore.sharedInstance.storedServiceList = serviceList
            self.tableView.reloadData()
        }
    }
}

