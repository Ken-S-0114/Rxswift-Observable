import UIKit
import RxSwift
import RxCocoa

// --------------------------------------------------
// RxSwift
let disposeBag = DisposeBag()
// --------------------------------------------------
// UI
var button = UIButton()
// --------------------------------------------------

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
let disposable = presenter.buttonHidden.bind(to: button.rx.isHidden)

presenter.doSomething()
presenter.start()
presenter.doSomething()

