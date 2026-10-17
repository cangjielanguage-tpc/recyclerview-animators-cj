/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package recyclerview

import ohos.state_manage.*
import ohos.state_macro_manage.*

@Observed
public class ArrayType {
    @Publish
    public var isNewValue: Bool
    @Publish
    public var value: String

    public func toString():String {
        return "${isNewValue}${value}"
    }
}