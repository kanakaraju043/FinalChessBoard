//
//  BoardCollectionViewCell.swift
//  ChessBoardTask
//
//  Created by Kanakaraju Gandreddi on 08/05/21.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    var timer: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let current = Int(self.cellTitle.text ?? "0") ?? 0
            self.cellTitle.text = "\(current + 1)"
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
}
