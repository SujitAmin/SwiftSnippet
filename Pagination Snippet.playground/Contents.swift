import UIKit

func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let maxPageCount = self.viewModel?.getMaxPageCount() ?? 0;
    if((self.commentsTable.contentOffset.y > 0) && (self.commentsTable.contentOffset.y >= self.commentsTable.contentSize.height - self.commentsTable.bounds.size.height) && pageCount <= maxPageCount && fetchingData == false) {
        print("Bottom");
        fetchingData = true;
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        guard let url = URL(string: APIEndPoints.BASE_URL + APIEndPoints.POST_VIEWUSERCHILDPOSTS + "\(user_id).json?page=\(pageCount)" ) else { return }
        HttpUtility.getApiData(requestUrl: url, decodingType: TrendingYocketersComment.self) { [weak self] (yocketersCommentsModel, error) in
            if (error != nil) {
                print(error as Any);
                return;
            }
            if let yocketersCommentsModel = yocketersCommentsModel {
                self?.viewModel?.addPaginatedData(newModel: yocketersCommentsModel.posts)
                self?.pageCount = (self?.pageCount ?? 0) + 1;
                self?.fetchingData = false;
                self?.commentsTable.reloadData();
                self?.activityIndicator.isHidden = true
            }
            
        }
    }
}

class TrendingYocketersCommentViewModel {
    let userDefaults = UserDefaults.standard;
    var model : TrendingYocketersComment?
    var cellViewModel : [TrendingYocketersCommentCellViewModel]?
    init(model : TrendingYocketersComment) {
        self.model = model
        if let posts = model.posts {
            cellViewModel = posts.map(TrendingYocketersCommentCellViewModel.init)
        }
    }
   
    func getItemAtIndexPath(row : Int) -> TrendingYocketersCommentCellViewModel {
        return cellViewModel![row];
    }
    
    func getCount() -> Int {
        return cellViewModel?.count ?? 0;
    }
    
    func getMaxPageCount() -> Int {
        return model?.pageCount ?? 0;
    }
    //pagination code
    func addPaginatedData(newModel : [TrendingYocketersCommentPost]?) {
        guard let newData = newModel else {return}
        self.model?.posts! += newData
        self.cellViewModel = self.model?.posts!.map(TrendingYocketersCommentCellViewModel.init)
    }
    func getTitle() -> String {
        if let name = userDefaults.value(forKey:"selectedUserName") as? String {
            return "Comments by \(name)"
        }
        return "Comments"
    }
}


