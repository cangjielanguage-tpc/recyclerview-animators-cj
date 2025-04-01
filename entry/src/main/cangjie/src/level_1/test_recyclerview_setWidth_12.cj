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
class Test_RecycleRview_SetWidth_12 {

    @State
    var controller: Controller = Controller()

    var adapterType:AdapterAnimationType = AdapterAnimationType.AlphaIn
    var itemType:ItemAnimationType = ItemAnimationType.FadeIn

    protected override func aboutToAppear() {
        this.controller.setAdapterAnimation(AdapterAnimationType.AlphaIn)
        this.controller.setItemAnimation(ItemAnimationType.ScaleIn)
        this.controller.setFirstOnly(false)
        this.controller.setDuration(5*1000)
    }

    func build() {
        Column() {
            Text("AdapterType : ${adapterType.toString()}  <->  ItemType : ${itemType.toString()}").fontSize(14).width(100.percent).backgroundColor(0x3dc49d)
            .padding(top:0, right:60, bottom:0, left:0)
             Row() {
                Button("setMovingWidth(60*1000)").fontSize(16).width(45.percent).padding(10).margin(10).onClick(
                {
                    event =>
                        this.controller.setMovingWidth(200.0)
                        this.controller.setMovingHeight(1200.0)
                })
            }
            RecyclerView(
                array: listDatas,
                controller: this.controller,
                child: this.SpecificChild,
                columnsNum: 1
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

