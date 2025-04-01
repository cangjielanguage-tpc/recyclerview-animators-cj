/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.level_2

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*


@Entry
@Component
class Test_RecycleRview_SetDuration_22 {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>();
    @State
    var controller: Controller = Controller()
    var adapterType:AdapterAnimationType = AdapterAnimationType.Default
    var itemType:ItemAnimationType = ItemAnimationType.FadeIn

    protected override func aboutToAppear() {
        this.controller.setAdapterAnimation(this.adapterType)
        this.controller.setItemAnimation(this.itemType)

    }

    func build() {
        Column() {
            Text("AdapterType : Default  <->  ItemType : ${itemType.toString()}").fontSize(14).width(100.percent).backgroundColor(0x3dc49d)
            .padding(top:0, right:60, bottom:0, left:0)
            Row() {
                Button("setDuration(0)").fontSize(16).width(45.percent).padding(10).margin(10).onClick(
                {
                    event =>
                        this.controller.setDuration(0)
                        this.controller.addValue(0, "setDuration(0)")
                })
            }
            RecyclerView(array: this.listDatas,controller: this.controller,columnsNum: 1,child: this.SpecificChild)

        }
    }

    @Builder
    func SpecificChild(itemData: String) {
        Column() {
            Image(@r(app.media.sample13)).width(100.percent).height(100)
            Text(itemData).fontSize(20).textAlign(TextAlign.Center).width(100.percent)
        }.margin(10)
    }
}

