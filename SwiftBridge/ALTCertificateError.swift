//
//  ALTCertificateError.swift
//  AltSign
//
//  Created by Magesh K.
//

import Foundation

public enum ALTCertificateError: LocalizedError, Equatable {
    case invalidFormat(cause: String? = nil)          // Wrong ASN.1 tag sequence (e.g. raw certificate passed)
    case decryptionFailed(cause: String? = nil)       // Wrong password (MAC verify/generation failure)
    case extractionFailed(cause: String? = nil)       // General parsing or null pointer failure
    case memoryAllocationFailed(cause: String? = nil) // Out of memory or allocation failed
    
    public var errorDescription: String? {
        let base: String
        let cause: String?
        switch self {
        case .invalidFormat(let c):
            base = "数据不是 PKCS12 格式。"
            cause = c
        case .decryptionFailed(let c):
            base = "解密失败。请检查密码是否正确。"
            cause = c
        case .extractionFailed(let c):
            base = "从 PKCS12 存档中提取证书或私钥失败。"
            cause = c
        case .memoryAllocationFailed(let c):
            base = "内存不足。PKCS12 提取过程中内存分配失败。"
            cause = c
        }
        if let cause = cause {
            return "\(base)\n原因：\(cause)"
        }
        return base
    }
    
    public static func ~= (lhs: ALTCertificateError, rhs: Error) -> Bool {
        guard let error = rhs as? ALTCertificateError else { return false }
        switch (lhs, error) {
        case (.invalidFormat, .invalidFormat): return true
        case (.decryptionFailed, .decryptionFailed): return true
        case (.extractionFailed, .extractionFailed): return true
        case (.memoryAllocationFailed, .memoryAllocationFailed): return true
        default: return false
        }
    }
}
