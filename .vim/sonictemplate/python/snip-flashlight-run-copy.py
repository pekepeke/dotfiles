def run(text):
    from AppKit import NSApplication, NSWindow, NSApp, NSBorderlessWindowMask, NSBackingStoreBuffered, NSScreen, NSView, NSColor, NSBezierPath, NSAnimationContext, NSTimer, NSApplicationActivationPolicyAccessory, NSMainMenuWindowLevel, NSAttributedString, NSFont, NSCenterTextAlignment, NSFontAttributeName, NSMutableParagraphStyle, NSParagraphStyleAttributeName, NSForegroundColorAttributeName, NSStringDrawingUsesLineFragmentOrigin, NSMakeRect, NSInsetRect, NSMakeSize, NSColorPanel, NSButton, NSRoundedBezelStyle, NSViewMaxXMargin, NSViewMinXMargin, NSViewMaxYMargin, NSViewMinYMargin, NSObject, NSNotificationCenter, NSWindowDidResignKeyNotification, NSPasteboard, NSPasteboardTypeString, NSColorSpace
    NSPasteboard.generalPasteboard().clearContents()
    NSPasteboard.generalPasteboard().setString_forType_(text, NSPasteboardTypeString)

