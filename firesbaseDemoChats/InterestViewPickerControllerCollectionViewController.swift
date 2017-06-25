//
//  InterestViewPickerControllerCollectionViewController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 6/21/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let interestDataBase = [
    "少年","风景","美女","情感","运动","游戏","帅哥","汽车","手势","成长","手绘","爱情","工作","艺术","学习","烹饪","安静","夜晚","科技","复古","经典","故事","动漫","电影","浪漫","伤感","开心","流行","清新","环保","亲情","后悔"
]
private var selectedInterest = [String]()

class InterestViewPickerControllerCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(InterestCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "选择兴趣"
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.autoresizesSubviews = false
        self.collectionView?.indicatorStyle = .black
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
        
     
        
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(confirmButtonView)
    }
    
    
    let confirmButtonView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height * 0.9), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.setNeedsDisplay()
        return view
        
    }()
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print(selectedInterest)
        selectedInterest.removeAll()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return interestDataBase.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> InterestCell {
        let cell: InterestCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InterestCell
        
        cell.setInterestText(text: interestDataBase[indexPath.row])
        cell.layer.cornerRadius = cell.frame.height * 0.5
        cell.clipsToBounds = true
        if selectedInterest.contains(cell.getText()) {
            cell.backgroundColor = UIColor.black
            cell.setTextLabelTextCor(color: UIColor.white)
        } else{
            cell.backgroundColor = UIColor.white
            cell.setTextLabelTextCor(color: UIColor.black)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let currentCell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        let currentCell: InterestCell = collectionView.cellForItem(at: indexPath) as! InterestCell
        
        if currentCell.backgroundColor == UIColor.white {
            // Adding to database
            currentCell.backgroundColor = UIColor.black
            currentCell.setTextLabelTextCor(color: UIColor.white)
            selectedInterest.append(interestDataBase[indexPath.row])
        } else{
            // Removing from database
          currentCell.backgroundColor = UIColor.white
            selectedInterest.remove(at: getIndexOfArray(searchElement: interestDataBase[indexPath.row]))
            currentCell.setTextLabelTextCor(color: UIColor.black)
        }
        
        
//        let selectedLeftSeperatorView = UIView(frame: CGRect(x: 0, y: 0, width: currentCell.frame.width * 0.05, height: currentCell.frame.height))
//        selectedLeftSeperatorView.backgroundColor = UIColor.black
//        selectedLeftSeperatorView.translatesAutoresizingMaskIntoConstraints = false
//        selectedLeftSeperatorView.tag = 1
//        currentCell.addSubview(selectedLeftSeperatorView)
//        
//        let selectedRightSeperatorView = UIView(frame: CGRect(x: currentCell.frame.width * 0.95 , y: 0, width: currentCell.frame.width * 0.05, height: currentCell.frame.height))
//        selectedRightSeperatorView.backgroundColor = UIColor.black
//        selectedRightSeperatorView.translatesAutoresizingMaskIntoConstraints = false
//        selectedLeftSeperatorView.tag = 2
//        currentCell.addSubview(selectedRightSeperatorView)
//        
//        let selectedTopSeperatorView = UIView(frame: CGRect(x: currentCell.frame.width * 0.05, y: 0, width: currentCell.frame.width * 0.9, height: currentCell.frame.width * 0.05))
//        selectedTopSeperatorView.backgroundColor = UIColor.black
//        selectedTopSeperatorView.translatesAutoresizingMaskIntoConstraints = false
//        selectedTopSeperatorView.tag = 3
//        currentCell.addSubview(selectedTopSeperatorView)
//        
//        let selectedBottomSeperatorView = UIView(frame: CGRect(x: currentCell.frame.width * 0.05, y: currentCell.frame.height * 0.93, width: currentCell.frame.width * 0.9, height: currentCell.frame.width * 0.05))
//        selectedBottomSeperatorView.backgroundColor = UIColor.black
//        selectedBottomSeperatorView.translatesAutoresizingMaskIntoConstraints = false
//        selectedBottomSeperatorView.tag = 4
//        currentCell.addSubview(selectedBottomSeperatorView)
        
    }

    func getIndexOfArray(searchElement: String) -> Int{
        var index = 0;
        for search in selectedInterest {
            if search == searchElement {
                return index
            }
            index += 1
        }
        
        return index
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}

class InterestCell: UICollectionViewCell{
    
    var interestText: UILabel = {
       let it = UILabel()
        it.textAlignment = .center
        it.textColor = UIColor.black
        it.translatesAutoresizingMaskIntoConstraints = false
        it.backgroundColor = nil
        it.layer.setNeedsDisplay()
        return it
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        interestText.frame = CGRect(x: frame.height * 0.05, y: frame.height * 0.05, width: frame.width - (frame.height * 0.1), height: frame.height * 0.9)
        interestText.layer.cornerRadius = layer.cornerRadius
        addSubview(interestText)
    }
    
    func setTextLabelBackgroundColor(color: UIColor){
        interestText.backgroundColor = color
    }
    
    func setTextLabelTextCor(color: UIColor){
        interestText.textColor = color
    }
    func getText() -> String {
        return interestText.text!
    }
    
    func setInterestText( text: String){
        interestText.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
