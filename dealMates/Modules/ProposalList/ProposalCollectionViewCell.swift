//
//  ProposalCollectionViewCell.swift
//  dealMates
//
//  Created by Stanislav on 13.05.2023.
//

import UIKit

struct ProposalCellModel {
    let id: String
    let title: String
    let description: String
    let avatarURL: URL?
    let imageURL: URL?
    let category: Category
    let publishDate: String?
    let location: String?
    let price: String
    var isLiked: Bool
    var likeId: String?
    let onLikeClick: ((Bool) -> ())?
}

final class ProposalCollectionViewCell: UICollectionViewCell, Reusable {
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.white()
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .handoSoft(size: 12, weight: .bold)
        label.textColor = AppColor.black()
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 12, weight: .regular)
        label.textColor = AppColor.any_132_134_137()
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 12, weight: .bold)
        label.textColor = AppColor.any_132_134_137()
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .handoSoft(size: 20, weight: .bold)
        label.textColor = AppColor.black()
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = AppImage.proposal_image_placeholder()
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didPressLike), for: .touchUpInside)
        return button
    }()
    
    private var cellModel: ProposalCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bgView.addShadowForSquareView(opacity: 0.35, width: 5, height: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(cellModel: ProposalCellModel) {
        self.cellModel = cellModel
        titleLabel.text = cellModel.title
        dateLabel.text = cellModel.publishDate
        priceLabel.text = cellModel.price
        likeButton.setImage(cellModel.isLiked ? AppImage.likeFill() : AppImage.like(), for: .normal)
        
        if let location = cellModel.location {
            locationLabel.text = location
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }
    }
    
    private func setupLayout() {
        contentView.add(view: bgView, constraints: [
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bgView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -10)
        ])
        
        bgView.add(views: [mainImageView, titleLabel, dateLabel, locationLabel, priceLabel, likeButton], constraints: [
            mainImageView.topAnchor.constraint(equalTo: bgView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -5),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -5),
            
            priceLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 5),
            priceLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -5),
            
            likeButton.heightAnchor.constraint(equalToConstant: 25),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            likeButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -5),
            likeButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -5),
        ])
    }
    
    @objc private func didPressLike() {
        let currentLike = cellModel?.isLiked ?? false
        self.cellModel?.isLiked = !currentLike
        likeButton.setImage(cellModel?.isLiked ?? false ? AppImage.likeFill() : AppImage.like(), for: .normal)
        cellModel?.onLikeClick?(cellModel?.isLiked ?? false)
    }
}
