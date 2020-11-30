import UIKit

//
//  ViewScholarshipsViewControllerExtension.swift
//  Yocket
//
//  Created by SujitAmin on 17/11/20.
//  Copyright © 2020 Avocation Educational Services. All rights reserved.
//

import Foundation
import Kingfisher

extension ViewScholarshipsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scholarshipModel?.scholarships?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibName.ScholarshipCollectionViewCell, for: indexPath) as! ScholarshipCollectionViewCell
        cell.delegate = self;
        cell.id = scholarshipModel?.scholarships?[indexPath.row].id;
        cell.urlAlias = scholarshipModel?.scholarships?[indexPath.row].urlAlias;
        cell.title.text = "Offered by " + (scholarshipModel?.scholarships?[indexPath.row].scholarshipUniversityCourses?[0].university?.name ?? "")
        cell.subTitle.text = scholarshipModel?.scholarships?[indexPath.row].name;
        cell.rangeOfScholarship.text = scholarshipModel?.scholarships?[indexPath.row].data?.amount
        cell.meritBasedValue.text = ScholarshipResource.getScholarshipTypesLabelName(scholarshipType: scholarshipModel?.filters?.scholarshipTypes, scholarshipNumber: scholarshipModel?.scholarships?[indexPath.row].type)
        cell.countryValue.text = scholarshipModel?.scholarships?[indexPath.row].scholarshipUniversityCourses?[0].university?.region?.country?.name;
        cell.deadlineValue.text = scholarshipModel?.scholarships?[indexPath.row].applicationEndDate;
        let logoString = (scholarshipModel?.scholarships?[indexPath.row].scholarshipUniversityCourses?[0].university?.logo ) ?? ""
        guard let url = URL(string: APIEndPoints.STATIC_BASE_URL + APIEndPoints.LOGOS_URL +  logoString) else {return cell}
        cell.universityImage.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: url.absoluteString), placeholder: UIImage(named: "yocketicon"))
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100);
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch (kind) {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header" , for: indexPath)
            return header;
        default:
            //assert(false, "Unexpected element kind")
            fatalError("Unexpected element kind")
        }
    }
}

extension ViewScholarshipsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 368)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
}

extension ViewScholarshipsViewController : ScholarshipCollectionViewCellDelegate {
    func viewScholarshipClicked(urlAlias : String, universityId : Int) {
        urlAliasToPass = urlAlias;
        idToPass = universityId;
        self.performSegue(withIdentifier: segue, sender: self)
    }
}

