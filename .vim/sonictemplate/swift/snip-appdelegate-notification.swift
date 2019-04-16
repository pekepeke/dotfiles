    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // MARK: デバイストークンが取得されたら呼び出されるメソッド
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // MARK: アプリが起動しているときに通知が来た場合に実行する処理を追記する場所
        switch application.applicationState {
        case .Inactive:
            // アプリがバックグラウンドにいる状態で、Push通知から起動したとき
            break
        case .Active:
            // アプリ起動時にPush通知を受信したとき
            break
        case .Background:
            // アプリがバックグラウンドにいる状態でPush通知を受信したとき
            break
        }

    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] {
            // MARK: アプリ未起動時、通知タップされた場合
        }
    }
