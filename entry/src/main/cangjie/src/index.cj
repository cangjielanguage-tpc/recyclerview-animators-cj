/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.*
internal import ohos.state_manage.*
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
                }).margin(top: 50)
                Button("ITEM SAMPLE PAGE").onClick({
                    e => Router.push(url: "IndexItemAnimator")
                }).margin(top: 50)

                Button("HLT_L0").width(80.percent).height(50).fontSize(18).margin(top: 10).onClick({evt =>Router.push(url:"Index_L0")})
                Button("HLT_L1").width(80.percent).height(50).fontSize(18).margin(top: 10).onClick({evt =>Router.push(url:"Index_L1")})
                Button("HLT_L2").width(80.percent).height(50).fontSize(18).margin(top: 10,bottom:10).onClick({evt =>Router.push(url:"Index_L2")})

            }.width(100.percent)
        }.width(100.percent)
    }
}
