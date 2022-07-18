//
//  ViewController.swift
//  NowPlaying
//
//  Created by Don Browning on 7/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var albumImage: UIImageView!
    @IBOutlet var trackTitle: UILabel!
    @IBOutlet var artistName: UILabel!
    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var totalScrobbles: UILabel!
    @IBOutlet var artistNameAndRank: UILabel!
    @IBOutlet var artistBuzz: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // just load it once for now, on view load
        
        getCurrentlyPlaying()
        
    }
    
    func getCurrentlyPlaying() {
        let session = URLSession.shared
    
        
        let endpoint = "https://videowall-kb9x9.ondigitalocean.app/api"
        guard let url = URL(string: endpoint) else {return}
        
        
        session.dataTask(with: url) {data, response, error in
            
            print("fetching now playing api")
            
            if let error = error {
                print("oh shit!")
                print(error)
            } else
            if let data = data {
                let npl: NowPlayingResult = try! JSONDecoder().decode(NowPlayingResult.self, from: data)
                
                print("it seemed to work!")
                
                self.updateUI(info: npl)
            }
            
        }.resume()
    }

    func updateUI(info: NowPlayingResult) {
        DispatchQueue.main.async {
            self.albumTitle.text = info.nowPlaying?.album ?? ""
            self.trackTitle.text = info.nowPlaying?.track ?? ""
            
            let artist = info.nowPlaying?.artist ?? ""
            self.artistName.text = artist
            
            let totalPlayCount = info.nowPlaying?.totalPlayCount ?? "0"
            self.totalScrobbles.text = totalPlayCount
            
            let rank = info.nowPlaying?.artistRanking ?? 0
            let totalRank = info.nowPlaying?.maxRanks ?? 0
            let nameAndRank = "\(artist) (#\(rank) | \(totalRank) plays)"
            self.artistNameAndRank.text = nameAndRank
            
            let fire = self.computeFire(trackPlayCount: info.nowPlaying?.myTrackPlayCount ?? 0)
            self.artistBuzz.text = fire
            
            // set image
            // self.imageView.image = UIImage(data: data)
            let imageURL = info.nowPlaying?.art ?? "https://www.macobserver.com/wp-content/uploads/2020/03/workheader-Apple-Music.jpg"
            guard let url = URL(string: imageURL) else { return }
            
            self.albumImage.load(url: url)
            
        }
    }
    
    func computeFire(trackPlayCount: Int) -> String {
        let count = ceil(Double(trackPlayCount) / 50.0)
        let fires = Int(count) // will never overload an int
        let fire = String(repeating: "🔥", count: fires)
        
        return fire
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
