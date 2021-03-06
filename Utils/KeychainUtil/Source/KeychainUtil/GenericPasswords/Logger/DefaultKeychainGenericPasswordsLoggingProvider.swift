import os.log

public struct DefaultKeychainGenericPasswordsLoggingProvider: KeychainGenericPasswordsLoggingProvider {
	public static let defaultInstance = Self(prefix: nil)
	
	public var prefix: String?
	
	public init (prefix: String?) {
		self.prefix = prefix
	}
	
	public func log <T: Codable> (_ info: GenericPassword<T>.Logger.Info) {
		let log = OSLog(subsystem: info.keychainIdentifier, category: "KeychainUtil")
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.keychainIdentifier.isEmpty && !prefix.isEmpty
			? "\(prefix)."
			: ""
		
		let message = "\(preparedPrefix)\(info.keychainIdentifier) – \(info.defaultMessage)"
		
		os_log("%{public}@", log: log, type: info.level, message)
	}
}
