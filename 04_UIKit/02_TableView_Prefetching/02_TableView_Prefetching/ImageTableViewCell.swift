//
//  ImageTableViewCell.swift
//  02_TableView_Prefetching
//
//  Created by Karthik K on 07/11/25.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    static let identifier = "ImageTableViewCell"
    
    // UI Components
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(cellImageView)
        containerStackView.addArrangedSubview(titleLabel)
        cellImageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            cellImageView.widthAnchor.constraint(equalToConstant: 80),
            cellImageView.heightAnchor.constraint(equalToConstant: 80),
            
            activityIndicator.centerXAnchor.constraint(equalTo: cellImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor)
        ])
    }
    
    func configure(with text: String, image: UIImage?) {
        titleLabel.text = text
        
        if let image = image {
            cellImageView.image = image
            activityIndicator.stopAnimating()
        } else {
            cellImageView.image = nil
            activityIndicator.startAnimating()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        titleLabel.text = nil
        activityIndicator.stopAnimating()
    }
}

