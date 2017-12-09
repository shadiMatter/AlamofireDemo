//
//  TaskCell.swift
//  AFSample
//
//  Created by Shadi Matter on 11/27/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configreCell(task:tasks){
        textLabel?.text = task.task
        backgroundColor = task.completed ? .yellow : .clear
    }
}
