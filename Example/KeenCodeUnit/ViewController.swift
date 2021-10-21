//
//  ViewController.swift
//  KeenCodeUnit
//
//  Created by chongzone on 03/16/2021.
//  Copyright (c) 2021 chongzone. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "KeenCodeUnit"
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.className
        )
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 6 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        switch indexPath.row {
        case 0: cell.textLabel?.text = "分割下划线样式"
        case 1: cell.textLabel?.text = "分割下划线样式2"
        case 2: cell.textLabel?.text = "分割下划线密文样式"
        case 3: cell.textLabel?.text = "分割边框样式"
        case 4: cell.textLabel?.text = "分割边框样式2"
        case 5: cell.textLabel?.text = "边框连续样式"
        default: cell.textLabel?.text = "其他模式"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = NextVc()
        vc.type = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
