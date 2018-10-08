import UIKit
import RxSwift

// --------------------------------------------------
// RxSwift
let disposeBag = DisposeBag()
// --------------------------------------------------
// UI
weak var button: UIButton!
// --------------------------------------------------
/*
 // merge
 // ２つの同じ型のイベントストリームを１つにまとめる
 */

let subject1 = PublishSubject<String>()
let subject2 = PublishSubject<String>()

Observable.of(subject1, subject2)
    .merge()
    .subscribe(onNext: { print("merge: \($0)") })
    .disposed(by: disposeBag)

subject1.onNext("🅰️")
subject2.onNext("①")
subject1.onNext("🅱️")
subject2.onNext("②")
subject1.onNext("🆎")
subject2.onNext("③")

print("--------------------")
// --------------------------------------------------
/*
 // combineLatest
 // 直近の最新値同士を組み合わせたイベントを作る
 */

let stringSubject = PublishSubject<String>()
let intSubject = PublishSubject<Int>()

Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
    "\(stringElement)\(intElement)"
    }
    .subscribe(onNext: {print("combineLatest: \($0)")})
    .disposed(by: disposeBag)

stringSubject.onNext("🅰️")
stringSubject.onNext("🅱️")
intSubject.onNext(1)
intSubject.onNext(2)
stringSubject.onNext("🆎")

print("--------------------")
// --------------------------------------------------
/*
 // sample
 // ある Observable の値を発行するタイミングを、もう一方の Observable をトリガーして決める場合に使う
 */
