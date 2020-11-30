
import Foundation
import Alamofire


class HttpUtility {
    static func getApiData<T: Codable>(requestUrl : URL, decodingType: T.Type ,completionHandler : ((T?, Error?) -> Void)? ) {
        Alamofire.request(requestUrl, method: .get, headers: Network().getHeaders()).validate().responseJSON { (response) in
            switch (response.result) {
            case .success:
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(decodingType, from: data)
                        DispatchQueue.main.async {
                            completionHandler?(result, nil);
                        }
                    } catch let error {
                        print("getApiData from Try Catch:")
                        print(error)
                        DispatchQueue.main.async {
                            completionHandler?(nil, error);
                        }
                        
                    }
                } else {
                    print("getApiData from data:")
                    print(response.error)
                    DispatchQueue.main.async {
                        completionHandler?(nil, response.error);
                    }
                    
                }
                break;
            case .failure(let error):
                print("getApiData from failure:")
                print(error)
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                break;
            }
        }
    }
    
    static func postApiData<T: Codable>(requestUrl: URL, requestBody : Parameters, resultType : T.Type, completionHandler: @escaping (_ result : T? , _ error : Error?) -> Void) {
        Alamofire.request(requestUrl,method: .post , parameters: requestBody, encoding: URLEncoding.default, headers: Network().getHeaders()).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let json = try JSONDecoder().decode(resultType, from: data)
                        DispatchQueue.main.async {
                            completionHandler(json, nil);
                        }
                    } catch let error {
                        print("postApiData from Try Catch:")
                        print(error)
                        DispatchQueue.main.async {
                            completionHandler(nil, error);
                        }
                    }
                } else {
                    print("postApiData from data:")
                    print(response.error)
                    DispatchQueue.main.async {
                        completionHandler(nil, response.error);
                    }
                }
                break;
            case .failure(let error):
                print("postApiData from failure:")
                print(error)
                DispatchQueue.main.async {
                    completionHandler(nil, error);
                }
                break;
            }
        }
    }
}

