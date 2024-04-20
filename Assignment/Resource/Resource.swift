//
//  Resource.swift
//  Assignment
//
//  Created by Abhishek Kumar Singh on 20/04/24.
//

import Foundation
struct Resource {
    let httpUtility = HttpUtility()

    func getImages(completion : @escaping (_ result: ImageList?) -> Void) {
        let requestUrl = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100")!
        do {
            httpUtility.getData(requestUrl: requestUrl, resultType: ImageList.self) { (result) in
                _ = completion(result)
            }
        }
    }
}
