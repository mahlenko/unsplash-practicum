//
// Created by Сергей Махленко on 08.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import WebKit
import UIKit

final class WebViewViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!

    var delegate: WebViewViewControllerDelegate?

    @IBAction private func didTapBackButton(_ sender: Any?) {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard var urlComponent = URLComponents(string: "\(Constant.unsplashOauthURL.rawValue)/authorize") else {
            return
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: Constant.accessKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: Constant.redirectURI.rawValue),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constant.accessScope.rawValue)
        ]

        guard let url = urlComponent.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self

        //
        progressView.setProgress(0.0, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Подписываемся за изменениями прогресса загрузки страницы
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: .none)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Отписываемся от изменений
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: .none)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }),
            let code = codeItem.value
        else { return nil }

        return code
    }

    /// Наблюдатель
    /// В данном случае за изменением прогресса загрузки страницы
    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}
