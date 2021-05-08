//
//  ViewController.swift
//  ChessBoardTask
//
//  Created by Kanakaraju Gandreddi on 08/05/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet  weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWidthConstraint: NSLayoutConstraint!
    var boardSize = 8
    @IBOutlet weak var boardSizeTextField: UITextField!    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardSizeTextField.text = "\(boardSize)"
        setupChessboard()
    }
    
    fileprivate func setupChessboard() {
        // Do any additional setup after loading the view.
        let deviceWidth = UIScreen.main.bounds.size.width
        let cellSize = floor(deviceWidth / CGFloat(boardSize))
        let collectionViewWidth = CGFloat(boardSize) * cellSize
        self.collectionViewWidthConstraint.constant = collectionViewWidth
        collectionView.layer.borderWidth = 2
        collectionView.layer.borderColor = UIColor.black.cgColor
        addLongPressGesture()
    }
    
    func addLongPressGesture() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressGR)
    }
    
    @objc func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state != .ended {
            return
        }
        
        let point = longPressGR.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            let cell = collectionView.cellForItem(at: indexPath) as? BoardCollectionViewCell
            if cell?.timer?.isValid == true {
                cell?.stopTimer()
                return
            }
            collectionView?.reloadItems(at: [indexPath])
            print(indexPath.row)
        } else {
            print("Could not find index path")
        }
    }
    
    @IBAction func createChessboard(_ sender: Any) {
    
        if let boardSize = boardSizeTextField.text, boardSize.isEmpty == false {
            boardSizeTextField.resignFirstResponder()
            let bordSizeValue = Int(boardSize) ?? 0
            if bordSizeValue > 20  {
              showAlert("Board size not more than 20")
                return
            } else if bordSizeValue == 0 ||  bordSizeValue == 1 {
                showAlert("Please enter Board size between 2 to 20")
                return
            }
            loadBoard(with: bordSizeValue)
        } else {
            showAlert("Please enter Board size between 2 to 20")
        }
    
    }
   
    func loadBoard(with size: Int) {
        self.boardSize = size
        setupChessboard()
        collectionView.reloadData()
    }
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  boardSize * boardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unique", for: indexPath) as! BoardCollectionViewCell
        let chessRow = indexPath.row / boardSize
        cell.cellTitle.text = ""
        
        if chessRow % 2 == 0 {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.white
            }else{
                cell.backgroundColor = UIColor.black
            }
        } else{
            if boardSize % 2 == 0 {
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = UIColor.black
                }else{
                    cell.backgroundColor = UIColor.white
                }
            } else {
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = UIColor.white
                }else{
                    cell.backgroundColor = UIColor.black
                }
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / CGFloat(boardSize)
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? BoardCollectionViewCell
        if cell?.timer?.isValid == true {
            cell?.stopTimer()
            return
        }
        cell?.startTimer()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
