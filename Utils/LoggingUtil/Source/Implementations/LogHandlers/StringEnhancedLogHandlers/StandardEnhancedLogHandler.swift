public class StandardEnhancedLogHandler<LogExporter: StringLogExporter> {
	public typealias Message = String
	
	public var logRecordFormatter: StringLogRecordFormatted
	public var logExporter: LogExporter
	public var loggerInfo: EnhancedLoggerInfo
	public var enabling: EnhancedEnablingConfig
	
	public init (
		logRecordFormatter: StringLogRecordFormatted = SingleLineFormatter(),
		logExporter: LogExporter,
		loggerInfo: EnhancedLoggerInfo = .init(),
		enabling: EnhancedEnablingConfig = .init()
	) {
		self.logRecordFormatter = logRecordFormatter
		self.logExporter = logExporter
		self.loggerInfo = loggerInfo
		self.enabling = enabling
	}
}


extension StandardEnhancedLogHandler: EnhancedLogHandler {	
	public func log (metaInfo: EnhancedMetaInfo, logRecord: EnhancedLogRecord<Message>) {
		guard metaInfo.level >= loggerInfo.level else { return }
		
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [loggerInfo.label] + metaInfo.labels)
		let logRecord = EnhancedLogRecordCombiner.default.combine(logRecord, loggerInfo)
		
		let moderatedLogRecord = EnhancedModerator.default.moderate(logRecord: logRecord, enabling: enabling)
		let finalMessage = logRecordFormatter.format(logRecord: moderatedLogRecord)
		
		logExporter.log(metaInfo.level, finalMessage, nil)
	}
}
