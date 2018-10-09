import UIKit
import Foundation
import RxSwift

// --------------------------------------------------
// RxSwift
let disposeBag = DisposeBag()
// --------------------------------------------------

class ServerDataLoader {
    private let resultSubject = PublishSubject<Data>()
    private let url: URL
    private var task: URLSessionDataTask?

    var result: Observable<Data> { return resultSubject }

    init(url: URL) {
        self.url = url
    }

    func start() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url){ [resultSubject] data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    resultSubject.onNext(data)
                    resultSubject.onCompleted()
                } else {
                    resultSubject.onError(error!)
                }
            }
        }
        // 通信開始（非同期でバックグラウンド実行される）
        task.resume()
        self.task = task
    }

    func cancel() {
        task?.cancel()
    }
}

//let url = URL(string: "https://itunes.apple.com/lookup?id=1187265767&country=JP")
//let loader = ServerDataLoader(url: url!)
//loader.result.subscribe(
//    onNext: { data in
//        // データ受信時の処理
//        dump(data)
//},
//    onError: { error in
//        // エラー時の処理
//        print(error)
//})
//
//loader.start()
//loader.cancel()

class ColdServerDataLoader {
    private let resultSubject = PublishSubject<Data>()

    var result: Observable<Data> { return resultSubject }

    func fetchServerDataWithRequest(url: URL) -> Observable<Data> {
        return Observable.create { observer in
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(error!)
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

}

let url = URL(string: "https://itunes.apple.com/lookup?id=1187265767&country=JP")
let loader = ColdServerDataLoader()
_ = loader.fetchServerDataWithRequest(url: url!)
    //メインスレッドでイベントを通知
    .observeOn(MainScheduler.instance)
    .map { XMLParser(data: $0) }
    .subscribe(onNext: { result in
        // データ受信時の処理
        print(result)
    }, onError: { error in
        // エラー時の処理
        print(error)
    })

