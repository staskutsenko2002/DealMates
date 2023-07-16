//
//  RequestTableViewCell.swift
//  dealMates
//
//  Created by Stanislav on 10.06.2023.
//

import UIKit

struct RequestCellModel {
    let title: String
    let description: String
    let avatarURL: URL?
    let userName: String
    let publishDate: String
    let location: String?
    let price: String
    let isLiked: Bool
}

final class RequestTableViewCell: UITableViewCell, Reusable {
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.white()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 16, weight: .bold)
        label.textColor = AppColor.black()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 14, weight: .regular)
        label.textColor = AppColor.black()
        label.numberOfLines = 2
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.image = AppImage.profile_avatarPlaceholder()
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.black()
        label.font = .handoSoft(size: 16, weight: .regular)
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 20, weight: .bold)
        label.textColor = AppColor.black()
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 12, weight: .regular)
        label.textColor = AppColor.any_132_134_137()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        contentView.backgroundColor = AppColor.white()
        bgView.addShadowForSquareView(opacity: 0.35, width: 5, height: 5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(cellModel: RequestCellModel) {
        titleLabel.text = cellModel.title
        descriptionLabel.text = cellModel.description
        dateLabel.text = cellModel.publishDate
        priceLabel.text = cellModel.price
        likeButton.setImage(cellModel.isLiked ? AppImage.likeFill() : AppImage.like(), for: .normal)
        
        userNameLabel.text = cellModel.userName
        
        if let url = cellModel.avatarURL,
           let data = try? Data(contentsOf: url) {
            userImageView.image = UIImage(data: data)
        }
       
        dateLabel.text = ""
    }
    
    private func setupLayout() {
        contentView.add(view: bgView, constraints: [
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        bgView.add(views: [titleLabel, descriptionLabel, userImageView, userNameLabel, dateLabel, likeButton, priceLabel], constraints: [
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            userImageView.heightAnchor.constraint(equalToConstant: 30),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            userImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            userImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -10),
            
            priceLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10),
            
            likeButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10),
            likeButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 27),
            likeButton.heightAnchor.constraint(equalToConstant: 27)
        ])
    }
}
