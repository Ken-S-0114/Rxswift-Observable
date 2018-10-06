import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

// --------------------------------------------------
/*
 // map
 // イベントの各要素を別の要素に変換
 */
Observable.of(1, 2, 3)
    .map { $0 * $0 }
    .subscribe(onNext: { print("map: \($0)") })
    .disposed(by: disposeBag)

print("--------------------")
// --------------------------------------------------
/*
 // filter
 // イベントの各要素を別の要素に変換
 */

Observable.of(
    "🐱", "🐰", "🐶",
    "🐸", "🐱", "🐰",
    "🐹", "🐸", "🐱")
    .filter {
        $0 == "🐰"
    }.subscribe(onNext: { print("filter: \($0)") })
    .disposed(by: disposeBag)

print("--------------------")
// --------------------------------------------------
/*
 // take
 // イベントを最初の指定した数だけに絞る
 */

Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
    .take(3)
    .subscribe(onNext: { print("take: \($0)") })
    .disposed(by: disposeBag)

print("--------------------")
// --------------------------------------------------
/*
 // skip
 // イベントの最初から指定個を無視
 */
Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
    .skip(1)
    .subscribe(onNext: { print("skip: \($0)") })
    .disposed(by: disposeBag)

print("--------------------")
// --------------------------------------------------


