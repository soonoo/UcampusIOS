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
        let label = sender.view! as! DownloadLabel

        if let savedName = label.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let serverName = label.fileName {
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            
            let url = Urls.notice_download.rawValue + "p_savefile=\(serverName)&p_realfile=\(savedName)"
            Alamofire.download(url, to: destination).response { response in
                //self.documentController = UIDocumentInteractionController(url: URL(fileURLWithPath: response.destinationURL?.path ?? ""))
                //self.documentController.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
                
                self.isDownloading = !self.isDownloading
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

                var yPosition = textLabel.frame.height + 15
                for link in fileLinks {
                    if let href = try? link.attr("href"),
                        let fileName = self.getFileName(text: href),
                        let saveName = self.getSaveName(text: href) {
                        let label = DownloadLabel()
                        label.text = saveName
                        label.fileName = fileName
                        label.isUserInteractionEnabled = true
                        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.startDownload)))
                        label.frame = CGRect(x: 15, y: yPosition, width: self.scrollView.frame.width, height: 0)
                        label.sizeToFit()
                        label.frame = CGRect(x: 15, y: yPosition, width: self.scrollView.frame.width - 30, height: label.frame.height + 15.0)
                        self.scrollView.addSubview(label)
                        yPosition += label.frame.height
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
        guard let fromIndex = text.index(of: "(") else { return nil }
        guard let toIndex = text.index(of: ",") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex) + 2
        let to = text.distance(from: text.startIndex, to: toIndex) - 2
        
        let result: String? = text.substr(from: from, to: to)
        return result
    }
    
    func getSaveName(text: String) -> String? {
        guard let fromIndex = text.index(of: ",") else { return nil }
        guard let toIndex = text.index(of: ")") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex) + 2
        let to = text.distance(from: text.startIndex, to: toIndex) - 2
        
        let result: String? = text.substr(from: from, to: to)
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class DownloadLabel: UILabel {
    var fileName: String?

    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        font = font.withSize(17)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

