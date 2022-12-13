//
//  DetailViewController.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/12/22.
//

import UIKit
import Kingfisher
import Alamofire

class DetailViewController: UIViewController {
    var searchResult: Movie!
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = searchResult.Title
        posterImage.kf.setImage(with: URL(string: searchResult.Poster))
        titleLabel.text = searchResult.Title
        yearLabel.text = searchResult.Year
        
        let detailURL = "https://www.omdbapi.com/?&apikey=919af252&i=\(searchResult.imdbID)"
        fetchDescription(for: detailURL)
    }
        
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func fetchDescription(for url: String) {
        AF.request(url).responseDecodable(of: MovieDetail.self) { response in
            let movie = response.value!
            self.descriptionLabel.text = movie.Plot
        }
    }
}
