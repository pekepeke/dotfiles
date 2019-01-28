func DebugLog(@autoclosure condition: () -> Bool = true, _ message: String = "", function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {

    #if DEBUG
        if let fileName = NSURL(string: String(file))?.lastPathComponent {
            print("time: \(NSDate()), message: \(message), function: \(function), file: \(fileName), line: \(line)")
        } else {
            print("time: \(NSDate()), message: \(message), function: \(function), file: \(file), line: \(line)")
        }

        assert(condition, message, file: file, line: line)
    #endif
}
