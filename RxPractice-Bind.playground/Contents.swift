import UIKit
import RxSwift
import RxCocoa

// --------------------------------------------------
// RxSwift
let disposeBag = DisposeBag()
// --------------------------------------------------
// UI
var button = UIButton()
weak var button2: UIButton!
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

// 受信側の処理
let presenter = Presenter()
// RxCocoa: 画面部分とのバインドを目的としている
let disposable = presenter.buttonHidden.bind(to: button.rx.isHidden)
//  let disposable = presenter.buttonHidden.bind(to: button2.rx.isHidden ?? presenter.buttonHidden)

presenter.doSomething()
presenter.start()
presenter.doSomething()

