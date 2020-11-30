import UIKit

class ScholarshipResource {
    func getDataFromURL(universityId: Int?, completionHandler : @escaping (_ result : Scholarships?, Error?) -> ()) {
        guard let url = URL(string: APIEndPoints.BASE_URL + APIEndPoints.SCHOLARSHIP_URL + "?university_id=\(universityId ?? 0)") else {
            completionHandler(nil, nil);
            return
        }
        HttpUtility.getApiData(requestUrl: url, decodingType: Scholarships.self) { (response, error) in
            completionHandler(response, error);
        }
    }
    
    static func getScholarshipTypesLabelName(scholarshipType : [String: String]?, scholarshipNumber : Int?) -> String {
        if let scholarshipNumber = scholarshipNumber , let scholarshipType = scholarshipType {
            let key = "\(scholarshipNumber)";
            return scholarshipType[key] ?? "";
        } else {
            return "";
        }
        
    }
}


