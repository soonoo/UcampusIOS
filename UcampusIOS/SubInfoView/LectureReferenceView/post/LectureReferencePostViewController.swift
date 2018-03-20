//
//  LectureReferencePostViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 8..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftSoup

class LectureReferencePostViewController: UIViewController {
    var documentController: UIDocumentInteractionController!
    var lectureCode: String!
    var scrollView: UIScrollView!
    var isDownloading = false

    @IBOutlet weak var failureLabel: UILabel!
    
    @objc func startDownload(sender: UITapGestureRecognizer) {
        if isDownloading { return }
        isDownloading = !isDownloading
        let downloadLabel = sender.view! as! DownloadLabel

        if let savedName = downloadLabel.text?.replacingOccurrences(of: " ", with: "_").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let serverName = downloadLabel.fileName {
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            let url = Urls.notice_download.rawValue + "p_savefile=\(serverName)&p_realfile=\("_" + savedName)"
            Alamofire.download(url, to: destination).response { response in
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let directory = URL(fileURLWithPath: path)
                let oldUrl = response.destinationURL!
                let newUrl = URL(fileURLWithPath: directory.path + "/" + downloadLabel.text!.replacingOccurrences(of: " ", with: "_"))

                do {
                    if FileManager.default.fileExists(atPath: newUrl.path) {
                        try FileManager.default.removeItem(atPath: newUrl.path)
                    }
                    try FileManager.default.moveItem(at: oldUrl, to: newUrl)
                    self.documentController = UIDocumentInteractionController(url: newUrl)
                    self.documentController.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
                    
                    self.isDownloading = !self.isDownloading
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = Urls.reference_view.rawValue + "&p_bdseq=" + lectureCode
        Alamofire.request(url).response { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let contents = try? doc.select(".tl_l2 > p").array(),
                let fileLinks = try? doc.select("a[href*=download]").array() {
                
                var post = ""
                for element in contents {
                    post += (try? element.text()) ?? ""
                    post += "\n"
                }

                self.scrollView = UIScrollView(frame: self.view.bounds)

                let textLabel = UILabel()
                textLabel.frame = CGRect(x:15, y: 15, width: self.view.frame.width - 30, height: 0)
                
                textLabel.text = post
                textLabel.textColor = .black
                textLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
                textLabel.numberOfLines = 0
                textLabel.sizeToFit()

                var yPosition = textLabel.frame.height + 35
                for link in fileLinks {
                    if let href = try? link.attr("href"),
                        let fileName = self.getFileName(text: href),
                        let saveName = self.getSaveName(text: href) {

                        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.startDownload))
                        let buttonFrame = CGRect(x: 15, y: yPosition, width: self.scrollView.frame.width, height: 0)
                        let downloadLabel = DownloadLabel(frame: buttonFrame, title: saveName, fileName: fileName, recognizer: recognizer)
                        self.scrollView.addSubview(downloadLabel)
                        downloadLabel.sizeToFit()
                        downloadLabel.frame = CGRect(x: downloadLabel.frame.origin.x, y: downloadLabel.frame.origin.y, width: UIScreen.main.bounds.width-30.0, height: downloadLabel.frame.height)
                        yPosition += downloadLabel.frame.height + 10
                    }
                }

                self.scrollView.addSubview(textLabel)
                self.scrollView.alwaysBounceVertical = true
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: yPosition)
                self.view.addSubview(self.scrollView)
            } else {
                self.failureLabel.isHidden = false
            }
        }
    }

    func getFileName(text: String) -> String? {
        guard let fromIndex = text.range(of: "download('") else { return nil }
        guard let toIndex = text.range(of: "','") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex.upperBound)
        let to = text.distance(from: text.startIndex, to: toIndex.lowerBound) - 1

        return text.substr(from: from, to: to)
    }
    
    func getSaveName(text: String) -> String? {
        guard let fromIndex = text.range(of: "','") else { return nil }
        guard let toIndex = text.range(of: "');") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex.upperBound)
        let to = text.distance(from: text.startIndex, to: toIndex.lowerBound) - 1

        return text.substr(from: from, to: to)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class DownloadLabel: UILabel {
    var fileName: String?
    
    init(frame: CGRect, title: String, fileName: String, recognizer: UITapGestureRecognizer) {
        super.init(frame: frame)
        font = font.withSize(18)
        text = title
        textColor = .black
        self.fileName = fileName
        
        // set underline
        let textRange = NSMakeRange(0, text!.count)
        let attributedText = NSMutableAttributedString(string: text!)
        attributedText.addAttribute(.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)

        isUserInteractionEnabled = true
        addGestureRecognizer(recognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
