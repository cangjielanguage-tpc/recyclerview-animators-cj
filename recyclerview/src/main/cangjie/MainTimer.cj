package recyclerview

import ohos.concurrency.*
import std.sync.*

internal class MainTimer {
    public static func once(delay: Duration, callback: () -> Unit): Unit {
        Timer.once(delay) {
            =>
                launch {
                    callback()
                }
        }
    }
}
