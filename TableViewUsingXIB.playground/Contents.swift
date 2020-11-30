import UIKit

//
//  UndergradCollegeViewController.swift
//  Yocket
//
//  Created by SujitAmin on 21/10/20.
//  Copyright © 2020 Avocation Educational Services. All rights reserved.
//

class UndergradCollegeViewController: UIViewController {

    @IBOutlet weak var navigationButtonView: NavigationButtons!
    @IBOutlet weak var tableView: UITableView!
    
    var appSettings = Settings();
    var ugCollegeFinderObj = UGCollegeFinderObject();
    
    let TITLE = "Undergrad College Finder"
    var cellCopy : SelectExamTableViewCell?
    enum CellIdentifier {
        static let infoCell = "info_cell"
        static let indicatorCell = "indicator"
        static let selectExam = "selectExam"
    }
    
    enum ButtonType : Int {
        case ACT
        case SAT
        case OTHERS
    }
    
    enum Segues : String {
        case ADD_DETAILS = "addDetailsSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func setUpView() {
        view.addDefaultBackgroundColor()
        setUpTableView()
        setUpNavigationButton()
    }

    fileprivate func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addDefaultBackgroundColor()
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: NibName.UGProgressIndicatorTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.indicatorCell)
        self.tableView.register(UINib(nibName: NibName.SelectExamTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.selectExam)
    }
    
    fileprivate func setUpNavigationButton() {
        self.title = TITLE
        
        navigationButtonView.previousButton.setImage(UIImage(named: AssetImageName.arrowLeft.getRawValue()), for: .normal)
        navigationButtonView.previousButton.imageEdgeInsets.left = -10
        
        let imageRight = UIImage(named: AssetImageName.arrowRight.getRawValue())
        navigationButtonView.nextButton.setImage(imageRight?.maskWithColor(color: .orange), for: .normal)
        navigationButtonView.nextButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        navigationButtonView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        navigationButtonView.previousButton.isHidden = true
    }
    
    @objc func nextButtonClicked(sender: UIButton) {
        if cellCopy?.actButton.isSelected == true || cellCopy?.satButton.isSelected == true || cellCopy?.othersButton.isSelected == true {
            performSegue(withIdentifier: Segues.ADD_DETAILS.rawValue, sender: self)
        }
        else {
            appSettings.showAlertBox(self, title: "WAIT!", message: "Please Select An Exam")
        }
    }
    
    @objc func buttonClick(sender: UIButton) {
        switch sender.tag {
        case ButtonType.ACT.rawValue:
            toggleButton(sender: cellCopy!.actButton)
            if cellCopy!.othersButton.isSelected {
                toggleButton(sender: cellCopy!.othersButton)
            }
            break
        case ButtonType.SAT.rawValue:
            toggleButton(sender: cellCopy!.satButton)
            if cellCopy!.othersButton.isSelected {
                toggleButton(sender: cellCopy!.othersButton)
            }
            break
        case ButtonType.OTHERS.rawValue:
            toggleButton(sender: cellCopy!.othersButton)
            if cellCopy!.actButton.isSelected {
                toggleButton(sender: cellCopy!.actButton)
            }
            if cellCopy!.satButton.isSelected {
                toggleButton(sender: cellCopy!.satButton)
            }
            break
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ADD_DETAILS.rawValue {
            if let viewController = segue.destination as? AddDetailsViewController {
                calculateWhichSelected(viewController: viewController)
                addDataToObject();
                viewController.ugCollegeFinderObj = ugCollegeFinderObj;
            }
        }
    }
    func addDataToObject() {
        ugCollegeFinderObj.userId = appSettings.userId!;
        guard let cellCopy = cellCopy else {return}
        ugCollegeFinderObj.actAppeared = cellCopy.actButton.isSelected;
        ugCollegeFinderObj.satAppeared = cellCopy.satButton.isSelected;
    }
    func calculateWhichSelected(viewController : AddDetailsViewController) {
        if cellCopy?.actButton.isSelected == true && cellCopy?.satButton.isSelected == true {
            viewController.type = UndergradExamType.BOTH_SAT_ACT
        }
        else if cellCopy?.actButton.isSelected == true {
            viewController.type = UndergradExamType.ACT
        }
        else if cellCopy?.satButton.isSelected == true {
            viewController.type = UndergradExamType.SAT
        }
        else if cellCopy?.othersButton.isSelected == true {
            viewController.type = UndergradExamType.OTHERS
        }
    }
}

extension UndergradCollegeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.infoCell) as! UndergradCollegeFinderInfoTableViewCell
            cell.contentView.addDefaultBackgroundColor()
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.indicatorCell) as! UGProgressIndicatorTableViewCell
            cell.contentView.addDefaultBackgroundColor()
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectExam) as! SelectExamTableViewCell
            cellCopy = cell
            cell.contentView.addDefaultBackgroundColor()
            cell.othersButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            cell.satButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            cell.actButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        else if indexPath.row == 1 {
            return 80
        }
        else if indexPath.row == 2 {
            return 385
        }
        return UITableView.automaticDimension
    }
}

extension UndergradCollegeViewController : UITableViewDelegate {
    
}

