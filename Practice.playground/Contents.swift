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
 // PublishSubject
 // イベントを発生させる一般的なObservable
 */

class Hoge {
    private let eventSubject = PublishSubject<Int> ()
    var event: Observable<Int> { return eventSubject }

    func doSomething(_ value: Int) {
        // イベント発行
        eventSubject.onNext(value)
    }
}

let hoge = Hoge()
hoge.event
    .subscribe(onNext: { print("PublishSubject: \($0)") } )
    .disposed(by: disposeBag)

hoge.doSomething(1)
hoge.doSomething(2)

// --------------------------------------------------
/*
 // BehaviorSubject
 // BehaviorSubject は最後の値を覚えていて、subscribeすると即座にそれを最初に通知する Subject です。生成するときに初期値を指定できます。
 */

class Presenter {
    private let buttonHiddenSubject = BehaviorSubject(value: false)
    var buttonHidden: Observable<Bool> { return buttonHiddenSubject }

    func start() -> Void {
        buttonHiddenSubject.onNext(true)
    }
    func stop() -> Void {
        buttonHiddenSubject.onNext(false)
    }

    func doSomething() {
        do {
            let buttonHidden = try buttonHiddenSubject.value()
            if buttonHidden {
                print("🌟 BehaviorSubject: value is true")
            }
        } catch {
            // buttonHidden が既に完了またはエラーで終了している場合
        }
    }
}

let presenter = Presenter()
let disposable = presenter.buttonHidden.subscribe(onNext: { [button] value in
    button?.isHidden = value
    print("BehaviorSubject: \(value)")
})
presenter.doSomething()
presenter.start()
presenter.doSomething()

// --------------------------------------------------
/*
 // Variable
 // BehaviorSubject の薄いラッパーで、onError を発生させる必要がない場合に置き換え可能
 */

class Presenter2 {
    private let buttonHiddenVar = Variable(false)
    var buttonHidden: Observable<Bool> { return buttonHiddenVar.asObservable() }

    // イベントを発行するには value プロパティに値を設定する
    func start() {
        buttonHiddenVar.value = true
    }

    func stop() {
        buttonHiddenVar.value = false
    }

    func doSomething() {
        print("value(Variable): \(buttonHiddenVar.value)")
    }

}

let presenter2 = Presenter2()
let disposable2 = presenter2.buttonHidden.subscribe(onNext: { [button] value in
    button?.isHidden = value
    print("Variable: \(value)")
})
presenter2.doSomething()
presenter2.start()

// --------------------------------------------------

// combineLatest
//let stringSubject = PublishSubject<String>()
//let intSubject = PublishSubject<Int>()
//
//Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
//    "\(stringElement)\(intElement)"
//    }
//    .subscribe(onNext: { print($0) })
//    .disposed(by: disposeBag)
//
//stringSubject.onNext("🍎")
//stringSubject.onNext("🍌")
//intSubject.onNext(1)
//stringSubject.onNext("🍑")
//intSubject.onNext(2)

