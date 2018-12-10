//
//  ServiceCell.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
         setupLayout()
    }

    func setupLayout() {
        statusView.layer.cornerRadius = statusView.frame.width/2
        statusView.layer.borderWidth = 1
        statusView.layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }


    // MARK: Override Functions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func prepareForReuse() {

        nameLabel.text = ""
        statusView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }

    func setData(service: Service) {

        if let isAvailable = service.isAvailable {
            if isAvailable {
                statusView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }else{
                statusView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }

        if let lastUpt = service.lastUpdate {
            lastUpdatedLabel.text = Date.getFormatedTime(date: lastUpt)
        }
        nameLabel.text = service.name
    }
}
