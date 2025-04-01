/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.level_1

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class Test_RecycleRview_13 {
    var listDatas: ObservedArrayList<String> = listDatas2
    @State
    var controller: Controller = Controller()

    var adapterType:AdapterAnimationType = AdapterAnimationType.Default
    var itemType:ItemAnimationType = ItemAnimationType.ScaleInBottom

    protected override func aboutToAppear() {
        this.controller.setDuration(3*1000)
        this.controller.setAdapterAnimation(this.adapterType)
    }

    func build() {
        Column() {
            Text("AdapterType : Default  <->  ItemType : ${itemType.toString()}").fontSize(14).width(100.percent).backgroundColor(0x3dc49d)
            .padding(top:0, right:60, bottom:0, left:0)
             Row() {
                Button("setItemAnimation为ScaleInBottom").fontSize(14).width(70.percent).padding(6).onClick(
                {
                    event =>
                        this.controller.setItemAnimation(this.itemType)
                        this.controller.addValue(0, "ScaleInBottom")

                })
                Button("del最后一个").fontSize(14).padding(6).onClick(
                {
                    event =>
                        this.controller.deleteValue(this.listDatas.size -1)
                })
            }
            RecyclerView(
                array: listDatas,
                controller: this.controller,
                child: this.SpecificChild,
                columnsNum: 2
            )
        }
    }

    @Builder
    func SpecificChild(itemData: String) {
        Column() {
            Image(@r(app.media.sample13)).width(100.percent).height(100)
            Text(itemData).fontSize(16).textAlign(TextAlign.Center).width(100.percent)
        }.margin(10)
    }
}

