import UIKit

class MovieSpotTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadItem (name: String, location:String?) {
        self.titleLabel.text = name
        if location != nil {
            self.subtitleLabel.text = location
        }
    }
    
}
