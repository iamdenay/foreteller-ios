import UIKit
import EasyPeasy
import Reusable
import Sugar


final class CityTableViewCell: UITableViewCell, Reusable {
    
    fileprivate lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    fileprivate lazy var bottomSeparator = UIView().then {
        $0.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViews() {
        contentView.backgroundColor = .white
        contentView.addSubviews(titleLabel, bottomSeparator)
    }
    
    fileprivate func configureConstraints() {
        
        titleLabel.easy.layout(
            CenterY(),
            Left(24),
            Top(8),
            Bottom(8)
        )
        bottomSeparator.easy.layout(
            Left(0),
            Right(0),
            Bottom(0),
            Height(1)
        )
        
    }
    
    func configure(text:String?) {
        titleLabel.text = text
    }
}



