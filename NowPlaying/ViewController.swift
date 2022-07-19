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
    
    private let placeholderArtURL = "https://www.macobserver.com/wp-content/uploads/2020/03/workheader-Apple-Music.jpg"
    private let videowallURL = "https://videowall-kb9x9.ondigitalocean.app"
    private let videoWallApi = "https://videowall-kb9x9.ondigitalocean.app/api"
    
    private var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentlyPlaying()
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func fireTimer() {
        print("Firing timer...")
        
        getCurrentlyPlaying()
        
    }
    
    func getCurrentlyPlaying() {
        let session = URLSession.shared
        
        guard let url = URL(string: videoWallApi) else {return}
        
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
            let formattedPlayCount = self.makeWithCommas(stringNumber: totalPlayCount)
            self.totalScrobbles.text = "\(formattedPlayCount) scrobbles"
            
            let rank = info.nowPlaying?.artistRanking ?? 0
            let totalPlays = info.nowPlaying?.myArtistPlayCount ?? 0
            let totalPlaysString = self.makeWithCommas(stringNumber: String(totalPlays))
            
            let nameAndRank = "\(artist) (#\(rank) | \(totalPlaysString) plays)"
            self.artistNameAndRank.text = nameAndRank
            
            let fire = self.computeFire(trackPlayCount: info.nowPlaying?.myTrackPlayCount ?? 0)
            self.artistBuzz.text = fire
            
            
            self.setImage(imageName: info.nowPlaying?.art)
            
        }
    }
    
    func setImage(imageName: String?) {
        // this code is a fucking abomination.  String parsing in Swift is a horror show

        var imageStringURL = imageName ?? placeholderArtURL
        // bascially the filename has to be percent encoded, but not the rest of the url string
        // so this is ripping off the file name of the custom artwork, encoding it, and reappending the URL
        if imageStringURL.contains("static/art"){
            guard let fileSuffixIndex = imageStringURL.lastIndex(of: "/") else {
                print("suffex shit")
                return
            }
            let filename = imageStringURL.suffix(from: fileSuffixIndex)
            let theFilename = filename.dropFirst()
            let encodedFileName = theFilename.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? placeholderArtURL
            
            print(encodedFileName)
            
            let finalImageStringURL = videowallURL + "/static/art/" + encodedFileName
            imageStringURL = finalImageStringURL
        }
        
        print("Using image: \(imageStringURL)")
                
        guard let url = URL(string: imageStringURL) else {
            print("there was an issue with the image url")
            return
        }
        
        self.albumImage.load(url: url)
    }
    

    
    func makeWithCommas(stringNumber: String) -> String {
        guard let intNumber = Int(stringNumber) else { return "0" }
        
        return intNumber.withCommas
        
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

extension Int {

    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    internal var withCommas: String {
        return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
