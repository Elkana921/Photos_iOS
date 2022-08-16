

import Foundation

struct Q{
    static let ui = DispatchQueue.main
    static let userInteractive = DispatchQueue.global(qos: .userInteractive)
    static let userInitiated = DispatchQueue.global(qos: .userInitiated)
    static let `default` = DispatchQueue.global(qos: .default)
    static let utility = DispatchQueue.global(qos: .utility)
    static let background = DispatchQueue.global(qos: .background)
}
