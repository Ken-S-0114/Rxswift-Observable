import UIKit
import RxSwift

let disposeBag = DisposeBag()

// combineLatest
let stringSubject = PublishSubject<String>()
let intSubject = PublishSubject<Int>()

Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
    "\(stringElement)\(intElement)"
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

stringSubject.onNext("🍎")
stringSubject.onNext("🍌")
intSubject.onNext(1)
stringSubject.onNext("🍑")
intSubject.onNext(2)
