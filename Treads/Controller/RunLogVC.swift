//
//  SecondViewController.swift
//  Treads
//
//  Created by Ahmed on 7/25/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class RunLogVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


}

extension RunLogVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunLogCell") as! RunLogCell
        guard let run = Run.getAllRuns()? [indexPath.row] else{ return RunLogCell() }
        cell.setup(run: run)
        return cell
    }
    
    
}

