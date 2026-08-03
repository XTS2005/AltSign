//
//  ALTErrors.swift
//  AltSign
//

import Foundation

// MARK: Domains

public let AltSignErrorDomain = "AltSign.Error"
public let ALTAppleAPIErrorDomain = "AltStore.AppleDeveloperError"
public let ALTUnderlyingAppleAPIErrorDomain = "Apple.APIError"

// MARK: UserInfo Keys

public let ALTSourceFileErrorKey = "ALTSourceFile"
public let ALTSourceLineErrorKey = "ALTSourceLine"
public let ALTAppNameErrorKey    = NSError.UserInfoKey("appName")

// MARK: Error Enums

public enum ALTError: Int, Error {
    case unknown = 0
    case invalidApp
    case missingAppBundle
    case missingInfoPlist
    case missingProvisioningProfile
}

public enum ALTAppleAPIError: Int, Error {
    case unknown = 3000
    case invalidParameters
    case incorrectCredentials
    case appSpecificPasswordRequired
    case noTeams
    case invalidDeviceID
    case deviceAlreadyRegistered
    case invalidCertificateRequest
    case certificateDoesNotExist
    case invalidAppIDName
    case invalidBundleIdentifier
    case bundleIdentifierUnavailable
    case appIDDoesNotExist
    case maximumAppIDLimitReached
    case invalidAppGroup
    case appGroupDoesNotExist
    case invalidProvisioningProfileIdentifier
    case provisioningProfileDoesNotExist
    case requiresTwoFactorAuthentication
    case incorrectVerificationCode
    case authenticationHandshakeFailed
    case invalidAnisetteData
    case tooManyCertificates
}

extension ALTAppleAPIError {
    public static func unknown() -> ALTAppleAPIError {
        return .unknown
    }
}

// MARK: Install providers

extension NSError {
    public static func registerErrorProviders() {
        NSError.setUserInfoValueProvider(forDomain: AltSignErrorDomain) { error, key in
            let nsError = error as NSError

            if key == NSLocalizedDescriptionKey {
                if nsError.altsignLocalizedFailure != nil { return nil }
                return nsError.localizedFailureReason
            }

            if key == NSLocalizedFailureReasonErrorKey {
                return nsError.altLocalizedFailureReason
            }

            return nil
        }

        NSError.setUserInfoValueProvider(forDomain: ALTAppleAPIErrorDomain) { error, key in
            let nsError = error as NSError

            if key == NSLocalizedDescriptionKey {
                if nsError.altsignLocalizedFailure != nil { return nil }
                return nsError.localizedFailureReason
            }

            if key == NSLocalizedFailureReasonErrorKey {
                return nsError.altAppleAPILocalizedFailureReason
            }

            if key == NSLocalizedRecoverySuggestionErrorKey {
                return nsError.altAppleAPILocalizedRecoverySuggestion
            }

            return nil
        }
    }

    var altsignLocalizedFailure: String? {
        if let value = userInfo[NSLocalizedFailureErrorKey] as? String {
            return value
        }

        guard let provider =
            NSError.userInfoValueProvider(forDomain: domain)
        else { return nil }

        return provider(self, NSLocalizedFailureErrorKey) as? String
    }

    var altLocalizedFailureReason: String? {

        guard let code = ALTError(rawValue: self.code) else { return nil }

        switch code {
        case .unknown:
            return NSLocalizedString("发生未知错误。", comment: "")
        case .invalidApp:
            return NSLocalizedString("应用无效。", comment: "")
        case .missingAppBundle:
            return NSLocalizedString("提供的 .ipa 文件不包含应用包。", comment: "")
        case .missingInfoPlist:
            return NSLocalizedString("提供的应用缺少 Info.plist 文件。", comment: "")
        case .missingProvisioningProfile:
            return NSLocalizedString("找不到匹配的描述文件。", comment: "")
        }
    }

    var altAppleAPILocalizedFailureReason: String? {

        guard let code = ALTAppleAPIError(rawValue: self.code) else { return nil }

        switch code {

        case .unknown:
            return NSLocalizedString("发生未知错误。", comment: "")

        case .invalidParameters:
            return NSLocalizedString("提供的参数无效。", comment: "")

        case .incorrectCredentials:
            return NSLocalizedString("你的 Apple ID 或密码不正确。", comment: "")

        case .noTeams:
            return NSLocalizedString("你不是任何开发团队的成员。", comment: "")

        case .appSpecificPasswordRequired:
            return NSLocalizedString("需要应用专用密码。你可以在 appleid.apple.com 创建。", comment: "")

        case .invalidDeviceID:
            return NSLocalizedString("此设备的 UDID 无效。", comment: "")

        case .deviceAlreadyRegistered:
            return NSLocalizedString("此设备已在此团队中注册。", comment: "")

        case .invalidCertificateRequest:
            return NSLocalizedString("证书请求无效。", comment: "")

        case .certificateDoesNotExist:
            return NSLocalizedString("此团队没有请求的序列号对应的证书。", comment: "")

        case .invalidAppIDName:
            if let appName = userInfo[ALTAppNameErrorKey as String] as? String {
                return String(
                    format: NSLocalizedString("名称“%@”包含无效字符。", comment: ""),
                    appName
                )
            }
            return NSLocalizedString("此应用的名称包含无效字符。", comment: "")
            
        case .invalidBundleIdentifier:
            return NSLocalizedString("此应用的应用包名无效。", comment: "")

        case .bundleIdentifierUnavailable:
            return NSLocalizedString("请求的应用包名无法注册或已被其它开发者账户注册。", comment: "")

        case .appIDDoesNotExist:
            return NSLocalizedString("此团队没有请求的标识符对应的应用 ID。", comment: "")

        case .maximumAppIDLimitReached:
            return NSLocalizedString("你每 7 天只能注册 10 个应用 ID。", comment: "")

        case .invalidAppGroup:
            return NSLocalizedString("提供的应用组无效。", comment: "")

        case .appGroupDoesNotExist:
            return NSLocalizedString("应用组不存在。", comment: "")

        case .invalidProvisioningProfileIdentifier:
            return NSLocalizedString("请求的描述文件的标识符无效。", comment: "")

        case .provisioningProfileDoesNotExist:
            return NSLocalizedString("此团队没有请求的标识符对应的描述文件。", comment: "")

        case .requiresTwoFactorAuthentication:
            return NSLocalizedString("此账户需要使用双重认证登录。", comment: "")

        case .incorrectVerificationCode:
            return NSLocalizedString("验证码不正确。", comment: "")

        case .authenticationHandshakeFailed:
            return NSLocalizedString("与服务器进行身份验证协商失败。", comment: "")

        case .invalidAnisetteData:
            return NSLocalizedString("提供的 anisette 数据无效。", comment: "")
        
        case .tooManyCertificates:
            return NSLocalizedString("此账户的证书数量已达到上限。", comment: "")
        }
    }

    var altAppleAPILocalizedRecoverySuggestion: String? {

        guard let code = ALTAppleAPIError(rawValue: self.code) else { return nil }

        switch code {

        case .incorrectCredentials:
            return NSLocalizedString(
                "请确保你正确输入了 Apple ID 和密码，然后重试。",
                comment: ""
            )

        case .invalidAnisetteData:
            #if os(macOS)
            return NSLocalizedString(
                "请确保此电脑的日期和时间与你的 iOS 设备一致，然后重试。",
                comment: ""
            )
            #else
            return NSLocalizedString(
                "请确保你电脑的日期和时间与你的 iOS 设备一致，然后重试。如果问题仍然存在，你可能需要使用 AltServer 重新安装 AltStore。",
                comment: ""
            )
            #endif

        default:
            return nil
        }
    }
}


// MARK: - Swift CustomNSError & Initializer Compatibility

extension ALTError: CustomNSError {
    public static var errorDomain: String {
        return AltSignErrorDomain
    }

    public var errorCode: Int {
        return rawValue
    }

    public var errorUserInfo: [String: Any] {
        return [:]
    }

    public init(_ code: ALTError) {
        self = code
    }

    public static func invalidApp(reason: String) -> NSError {
        return NSError(domain: AltSignErrorDomain, code: ALTError.invalidApp.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: reason])
    }
}

extension ALTAppleAPIError: CustomNSError {
    public static var errorDomain: String {
        return ALTAppleAPIErrorDomain
    }

    public var errorCode: Int {
        return rawValue
    }

    public var errorUserInfo: [String: Any] {
        return [:]
    }

    public init(_ code: ALTAppleAPIError) {
        self = code
    }
}

public enum ALTServerError: LocalizedError {
    case badServerResponse(reason: String, jsonPayload: String)
    case invalidResponseFormat(rawPayload: String)
    case missingKey(key: String, jsonPayload: String)

    public var errorDescription: String? {
        switch self {
        case .badServerResponse(let reason, let jsonPayload):
            return "无效的服务器响应：\(reason)（负载：'\(jsonPayload)')"
        case .invalidResponseFormat(let rawPayload):
            let trimmed = rawPayload.trimmingCharacters(in: .whitespacesAndNewlines)
            let formattedPayload: String
            if trimmed.isEmpty {
                formattedPayload = "''（内容长度：0）"
            } else if trimmed.lowercased().contains("<html") || trimmed.hasPrefix("<!DOCTYPE") || (trimmed.hasPrefix("<") && trimmed.contains(">")) {
                let stripped = trimmed
                    .replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
                    .components(separatedBy: .whitespacesAndNewlines)
                    .filter { !$0.isEmpty }
                    .joined(separator: " ")
                formattedPayload = stripped.isEmpty ? "（HTML 响应）" : "'\(stripped)'"
            } else {
                formattedPayload = "'\(rawPayload)'"
            }
            return "无效的服务器响应：无法解析的格式（负载：\(formattedPayload))"
        case .missingKey(let key, let jsonPayload):
            return "无效的服务器响应：缺少必需的键 '\(key)'（负载：'\(jsonPayload)')"
        }
    }
}
