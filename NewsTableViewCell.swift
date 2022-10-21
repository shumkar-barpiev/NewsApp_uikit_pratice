//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by User on 21/10/22.
//

import UIKit

class NewsTableViewCellViewModel{
    let title: String
    let subTitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(   title: String,
            subTitle: String,
            imageURL: URL?){
        
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
        
    }
}


class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
         let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let subTitleLabel : UILabel = {
         let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10 , y: 0, width: contentView.frame.size.width - 140, height:  70)
        subTitleLabel.frame = CGRect(x: 10 , y: 70, width: contentView.frame.size.width - 140, height:  contentView.frame.size.height / 2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 130 , y: 5 , width: 120, height:  contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        
//        image
        if let data = viewModel.imageData{
            newsImageView.image = UIImage(data: data)
        }else if let url = viewModel.imageURL{
//            fetch
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
