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
class Test_RecycleRview_16 {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>(["Ball", "Camera", "Spain"]);
    var listDatas2: ObservedArrayList<String> = ObservedArrayList<String>(["hello", "仓颉", "cangjie"]);
    @State
    var controller: Controller = Controller()
    @State
    var controller2: Controller = Controller()
    var adapterType:AdapterAnimationType = AdapterAnimationType.ScaleIn
    var itemType:ItemAnimationType = ItemAnimationType.SlideInUp

    protected override func aboutToAppear() {
        this.controller.setDuration(2*1000)
        this.controller2.setDuration(3*1000)
        this.controller.setAdapterAnimation(AdapterAnimationType.SlideInLeft)
        this.controller2.setAdapterAnimation(this.adapterType)

    }

    func build() {
        Column() {
            Text("两个RecyclerView组件").fontSize(14).width(100.percent).backgroundColor(0x3dc49d)
            .padding(top:0, right:60, bottom:0, left:0)
            RecyclerView(
                array: listDatas,
                controller: this.controller,
                child: this.SpecificChild,
                columnsNum: 2
            )
            RecyclerView(
                array: listDatas2,
                controller: this.controller2,
                child: this.SpecificChild2,
                columnsNum: 1
            )
        }
    }

    @Builder
    func SpecificChild(itemData: String) {
        Column() {
            Image(@r(app.media.elk)).width(100.percent).height(100)
            Text(itemData).fontSize(16).textAlign(TextAlign.Center).width(100.percent)
        }.margin(10)
    }
    @Builder
    func SpecificChild2(itemData: String) {
        Column() {
            Image(@r(app.media.TIF)).width(100.percent).height(100)
            Text(itemData).fontSize(16).textAlign(TextAlign.Center).width(100.percent)
        }.margin(10)
    }
}

