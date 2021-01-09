//
//  SpotifyCell.swift
//  Music Remember
//
//  Created by TechExactlyMAC4 on 13/08/19.
//  Copyright © 2019 besttech. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

  
    @IBOutlet weak var songName: UILabel!
    

    @IBOutlet weak var songadd: UILabel!
   
    @IBOutlet weak var separateCellLbl: UILabel!
    @IBOutlet weak var playSongBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
         
//        [songName,SongImage].forEach{
//            $0?.showAnimatedGradientSkeleton()
//        }
       // SelectImg.showAnimatedGradientSkeleton()
        // Initialization code
   
   
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
