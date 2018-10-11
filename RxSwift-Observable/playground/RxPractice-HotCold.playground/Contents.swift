import UIKit
import Foundation
import RxSwift

// --------------------------------------------------
// RxSwift
let disposeBag = DisposeBag()
// --------------------------------------------------
// Consts
let url = URL(string: "https://itunes.apple.com/lookup?id=1187265767&country=JP")

func parse(data: Data) -> String {
    let str = String(data: data, encoding: .utf8)!
    return str
}

enum MyError: Error {
    case FailedToFetchServerData
}

extension MyError {
    var description: String {
        switch self {
        case .FailedToFetchServerData:
            return "FailedToFetchServerData"
        }
    }

}
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
                    resultSubject.onError(error ?? MyError.FailedToFetchServerData)
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
                    observer.onError(error ?? MyError.FailedToFetchServerData)
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}

let loader = ColdServerDataLoader()

/*
 observeOn: スレッドを指定
 */

//_ = loader.fetchServerDataWithRequest(url: url!)
//    //メインスレッドでイベントを通知
//    .observeOn(MainScheduler.instance)
//    .map { parse(data: $0) }
//    .subscribe(onNext: { result in
//        // パース済みデータ受信時の処理
//        print(result)
//    }, onError: { error in
//        // エラー時の処理
//        print(error)
//    })

/*
 subscribeOn
 subscibe処理を実行するスレッドを指定(Observableの購読登録処理)
 ※ subscribeに渡すクロージャがそのスレッドで実行されるのではない
 */

//_ = loader.fetchServerDataWithRequest(url: url!)
//    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
//    .map { parse(data: $0) }
//    .observeOn(MainScheduler.instance)
//    .subscribe(
//      onNext: { result in
//        print(result)
//    },
//      onError: { error in
//        // エラー時の処理
//        print(error)
//    })

/*
 retry
 onError が起こると、自動的に subscribe しなおす
 */

//_ = loader.fetchServerDataWithRequest(url: url!)
//    .map { parse(data: $0) }
//    // map の後に指定しているので、parse で例外が発生して失敗した場合もリトライする
//    .retry(3)
//    .observeOn(MainScheduler.instance)
//    .subscribe(
//        onNext: { result in
//            print(result)
//    },
//        onError: { error in
//            print(error)
//    }
//)

/*
 timeout
 第一引数が秒数、第二引数がタイマーを実行するスレッド（Scheduler）
 タイムアウトすると TimeoutError が onError で通知される
 タイムアウトしたら代わりに実行する Observable を指定する other 引数を持つバージョンも存在
 */

//let lowPriorityScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .default))
//_ = loader.fetchServerDataWithRequest(url: url!)
////    .timeout(5, scheduler: lowPriorityScheduler)
//    // Observable.just は指定した値を onNext で１つだけ流して onCompleted になる Observable を生成します。
//    // ここではタイムアウトしたら空の Data を渡して完了するようにしている
//    .timeout(5, other: Observable.just(Data()), scheduler: lowPriorityScheduler)
//    .map { parse(data: $0) }
//    .observeOn(MainScheduler.instance)
//    .subscribe(
//        onNext: { result in
//            print(result)
//        },
//        onError: { error in
//            print(error)
//    }
//)

/*
 catchErrorJustReturn
 onError が発生した場合の処理
 */
//_ = loader.fetchServerDataWithRequest(url: url!)
//    .map { parse(data: $0) }
//    .catchErrorJustReturn("")
//    .observeOn(MainScheduler.instance)
//    .subscribe(
//        onNext: { result in
//            // パース済みデータ受信時の処理
//            print(result)
//    }
//)

/*
 catchError
 エラー内容によって処理を選択
 */

_ = loader.fetchServerDataWithRequest(url: url!)
    .map { parse(data: $0) }
    .catchError { error in
        if error is MyError { throw error }
//        if error is MyError { return Observable.error(error) }
        return Observable.just("")
    }
    .observeOn(MainScheduler.instance)
    .subscribe(
        onNext: { result in
            // パース済みデータ受信時の処理
            print(result)
    }
)
