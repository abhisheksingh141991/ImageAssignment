//
//  Images.swift
//  Assignment
//
//  Created by Abhishek Kumar Singh on 20/04/24.
//

import Foundation

struct ImageListElement: Codable {
    let id, title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
}

struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
}

struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Int
}

typealias ImageList = [ImageListElement]
