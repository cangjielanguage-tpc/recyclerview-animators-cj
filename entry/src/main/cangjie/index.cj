/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry

import ohos.base.LengthProp
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*

@Entry
@Component
class EntryView {
    func build() {
        Row {
            Column {
                Button("ADAPTER SAMPLE PAGE").onClick({
                    e => Router.push(url: "IndexAdapterAnimator")
                }).margin(top: 50).id("ADAPTER")
                Button("ITEM SAMPLE PAGE").onClick({
                    e => Router.push(url: "IndexItemAnimator")
                }).margin(top: 50).id("ITEM")

            }.width(100.percent)
        }.width(100.percent)
    }
}
