//
//  ViewController.swift
//  samplemedia
//
//  Created by TechExactlyMAC4 on 09/01/21.
//  Copyright © 2021 TechExactlyMAC4. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SystemConfiguration

class ViewController: UIViewController {
    var SongURl = [String]()
    
    @IBOutlet weak var playSongLbl: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var songTbl: UITableView!
    @IBOutlet weak var playBtn: UIButton!
    var SpotifyCellObj = TableCell()
    var player: AVPlayer?
    private var listenSongIndex = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity.stopAnimating()
        self.activity.isHidden = true
        SongURl = ["https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3","https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3","https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"]
        // Do any additional setup after loading the view.
    }

    @IBAction func playBtnClick(_ sender: Any) {
        if !(playBtn.isSelected){
                   player?.pause()
                   DispatchQueue.main.async {
                       self.playBtn.isSelected = true
                       self.songTbl.reloadData()
                     
                   }
               }
               else{
                   playBtn.isSelected = false
                   player?.play()
                    self.songTbl.reloadData()
               }
    }
    
}
extension ViewController : UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongURl.count 
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        SpotifyCellObj = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! TableCell
       
        if SongURl.count  > 0 {

          
            SpotifyCellObj.songName.text = SongURl[indexPath.row]
            SpotifyCellObj.separateCellLbl.isHidden = false
            
          
        }
        return SpotifyCellObj
    }

    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
            DispatchQueue.main.async {
               self.playBtn.isSelected = true
           }
           if listenSongIndex == indexPath.row{
               player?.pause()
              
               playerView.isHidden = true
               
               playBtn.isSelected = true
               listenSongIndex = -1

               //cell.equlizerView.stopAnimating()
               let indexPosition = IndexPath(row: indexPath.row, section: 0)
              songTbl.reloadRows(at: [indexPosition], with: .none)
              
           }
           else{
             
               playerView.isHidden = false
               activity.isHidden = false
               if listenSongIndex != -1 {
               let indexPosition = IndexPath(row: listenSongIndex, section: 0)
               songTbl.reloadRows(at: [indexPosition], with: .none)
               }
             
               if isNetworkAvailable(){
                   // showHud("")
                   listenSongIndex = indexPath.row
                   let songstr = SongURl[indexPath.row]
                   
                   let songURL = URL(string:songstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                   self.play(url: songURL! as NSURL,songName:songstr)
               }
               else{
                  
                    self.showAlert(withTitle: "Error", andMessage: "Check your Internet connection")
               }
           }
          // self.songListTbl.reloadData()
       }
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
               let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
               let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
               if newStatus != oldStatus {
                   DispatchQueue.main.async {[weak self] in
                       if newStatus == .playing  {
                          
                           self?.playBtn.isSelected = false
                           self?.activity.stopAnimating()
                           self?.activity.isHidden = true
                          
                        
                           let indexPosition = IndexPath(row: self?.listenSongIndex ?? 0, section: 0)
                            self?.songTbl.reloadRows(at: [indexPosition], with: .none)
                           
                       } else if newStatus == .paused {
                          
                       }
                       else{
                         
                       }
                   }
               }
           }
       }
    func play(url:NSURL,songName:String) {
        
        
        activity.isHidden = false
        self.activity.startAnimating()
        
        do {
            let playerItem = AVPlayerItem(url: url as URL)
            
            player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
            playBtn.isSelected = false
            
            print("play rate..\(String(describing: player?.seek(to: CMTime.zero)))")
            print("play rate..\(String(describing: player?.status))")
            player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            
            if Int(player!.rate) > 0
            {

                playSongLbl.text = songName
                
            }
        } catch let error as NSError {
            player = nil
            print(error.localizedDescription)
            self.activity.stopAnimating()
            activity.isHidden = true
            self.showAlert(withTitle: "Oops!", andMessage: "Couldn’t play the file. There is some problem in audio file." )
        } catch {
            print("AVAudioPlayer init failed")
            self.activity.stopAnimating()
            activity.isHidden = true
            self.showAlert(withTitle: "Oops!", andMessage: "Couldn’t play the file. There is some problem in audio file.")
        }
    }
}
