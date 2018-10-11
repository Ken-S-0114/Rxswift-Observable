import UIKit
import Foundation
import RxSwift

extension Observable {
    public func myMap<T> (converter: @escaping (E) throws -> T) -> Observable<T> {
        return Observable<T>.create { observer in
            let disposable = self.subscribe(
                onNext: {
                    do {
                        try observer.onNext(converter($0))
                    } catch let e {
                        observer.onError(e)
                    }
            }, onError: {
                observer.onError($0)
            }, onCompleted: {
                observer.onCompleted()
            })
            return disposable
        }
    }
}
