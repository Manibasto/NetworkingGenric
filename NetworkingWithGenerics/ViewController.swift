//
//  ViewController.swift
//  NetworkingWithGenerics
//
//  Created by Brian Voong on 6/5/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchHomeFeed { (homeFeed) in
//            homeFeed.videos.forEach({print($0.name)})
//        }
        
//        fetchDetails { (courseDetails) in
//            courseDetails.forEach({print($0.name, $0.duration)})
//        }
        
        fetchGenericData(urlString: "https://api.letsbuildthatapp.com/youtube/home_feed") { (homeFeed: HomeFeed) in
            homeFeed.videos.forEach({print($0.name)})
        }
        
        fetchGenericData(urlString: "https://api.letsbuildthatapp.com/youtube/course_detail?id=1") { (courseDetails: [CourseDetail]) in
            courseDetails.forEach({print($0.name, $0.duration)})
        }
        
        struct Course: Decodable {
            let id: Int
            let name: String
            let link: String
        }
        fetchGenericData(urlString: "https://api.letsbuildthatapp.com/jsondecodable/courses") { (courses: [Course]) in
            courses.forEach({print($0.link)})
        }
    }
    
//    fileprivate func fetchHomeFeed(completion: @escaping (HomeFeed) -> ()) {
//        let urlString = "https://api.letsbuildthatapp.com/youtube/home_feed"
//        let url = URL(string: urlString)
//        URLSession.shared.dataTask(with: url!) { (data, resp, err) in
//
//            guard let data = data else { return }
//
//            do {
//                let homeFeed = try JSONDecoder().decode(HomeFeed.self, from: data)
//                completion(homeFeed)
//            } catch let jsonErr {
//                print("Failed to decode json:", jsonErr)
//            }
//        }.resume()
//    }
//
//    fileprivate func fetchDetails(completion: @escaping ([CourseDetail]) -> ()) {
//        let urlString = "https://api.letsbuildthatapp.com/youtube/course_detail?id=1"
//        let url = URL(string: urlString)
//        URLSession.shared.dataTask(with: url!) { (data, resp, err) in
//
//            guard let data = data else { return }
//
//            do {
//                let courseDetails = try JSONDecoder().decode([CourseDetail].self, from: data)
//                completion(courseDetails)
//            } catch let jsonErr {
//                print("Failed to decode json:", jsonErr)
//            }
//            }.resume()
//    }
    
    fileprivate func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
//        let urlString = "https://api.letsbuildthatapp.com/youtube/course_detail?id=1"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, resp, err) in
            if let err = err {
                print("Failed to fetch data:", err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonErr {
                print("Failed to decode json:", jsonErr)
            }
            }.resume()
    }

}

struct CourseDetail: Decodable {
    let name: String
    let duration: String
}

struct HomeFeed: Decodable {
    let videos: [Video]
}

struct Video: Decodable {
    let id: Int
    let name: String
}





