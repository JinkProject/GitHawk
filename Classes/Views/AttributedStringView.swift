//
//  AttributedStringView.swift
//  Freetime
//
//  Created by Ryan Nystrom on 6/23/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

protocol AttributedStringViewDelegate: class {
    func didTapURL(view: AttributedStringView, url: URL)
    func didTapUsername(view: AttributedStringView, username: String)
}

final class AttributedStringView: UIView {

    weak var delegate: AttributedStringViewDelegate? = nil

    private var text: NSAttributedStringSizing? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        isOpaque = true

        layer.contentsGravity = kCAGravityTopLeft

        let tap = UITapGestureRecognizer(target: self, action: #selector(AttributedStringView.onTap(recognizer:)))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public API

    func reposition(width: CGFloat) {
        guard let text = text else { return }
        layer.contents = text.contents(width)
        let rect = CGRect(origin: .zero, size: text.textViewSize(width))
        frame = UIEdgeInsetsInsetRect(rect, text.inset)
    }

    func configureAndSizeToFit(text: NSAttributedStringSizing, width: CGFloat) {
        self.text = text
        layer.contentsScale = text.screenScale
        reposition(width: width)
    }

    // MARK: Private API

    func onTap(recognizer: UITapGestureRecognizer) {
        guard let attributes = text?.attributes(point: recognizer.location(in: self)) else { return }
        if let urlString = attributes[MarkdownURLName] as? String, let url = URL(string: urlString) {
            delegate?.didTapURL(view: self, url: url)
        } else if let usernameString = attributes[UsernameAttributeName] as? String {
            delegate?.didTapUsername(view: self, username: usernameString)
        }
    }

}
