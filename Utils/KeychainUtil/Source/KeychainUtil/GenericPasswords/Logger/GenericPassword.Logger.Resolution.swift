import os.log

extension GenericPassword.Logger {
	enum Resolution {
		case overwriting
		case saving
		case loading(Value)
		case loadingOptional(Value?)
		case deletion
		case existance(Bool, Value? = nil)
		
		case codingError(GenericPasswordError.Category.Coding)
		case keychainError(Error)
		case genericError(Error)
		
		
		
		var value: Value? {
			let value: Value?
			
			switch self {
			case .loading(let item):
				value = item
			case .loadingOptional(let item):
				value = item
			case .existance(_, let item):
				value = item
			default:
				value = nil
			}
			
			return value
		}
		
		var isExists: Bool? {
			let isExists: Bool?
			
			switch self {
			case .existance(let existance, _):
				isExists = existance
			default:
				isExists = nil
			}
			
			return isExists
		}
		
		var errorType: String? {
			let errorType: String?
			
			switch self {
			case .codingError:
				errorType = "CODING ERROR"
			case .keychainError:
				errorType = "KEYCHAIN ERROR"
			case .genericError:
				errorType = "ERROR"
			default:
				errorType = nil
			}
			
			return errorType
		}
		
		var error: Error? {
			let error: Error?
			
			switch self {
			case .codingError(let codingError):
				error = codingError
			case .keychainError(let keychainError):
				error = keychainError
			case .genericError(let genericError):
				error = genericError
			default:
				error = nil
			}
			
			return error
		}
		
		var level: OSLogType {
			let level: OSLogType
			
			switch self {
			case .overwriting:
				level = .info
			case .saving:
				level = .info
			case .loading:
				level = .default
			case .loadingOptional:
				level = .default
			case .deletion:
				level = .info
			case .existance:
				level = .default
			case .codingError:
				level = .error
			case .keychainError:
				level = .error
			case .genericError:
				level = .error
			}
			
			return level
		}
	}
}
