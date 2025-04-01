/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.level_1

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.hilog.*
import ohos.display.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.*

import std.collection.ArrayList
import recyclerview.RecyclerView
import recyclerview.ItemAnimationType
import recyclerview.AdapterAnimationType
import recyclerview.Controller

@Entry
@Component
class Test_RecycleRview_OvershootInLeft_11 {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>();
    @State
    var controller: Controller = Controller()
    var adapterType:AdapterAnimationType = AdapterAnimationType.AlphaIn
    var itemType:ItemAnimationType = ItemAnimationType.OvershootInLeft

    protected override func aboutToAppear() {
        this.controller.setAdapterAnimation(this.adapterType)
        this.controller.setDuration(3*1000)
    }

    func build() {
        Column() {
            Text("AdapterType : ${adapterType.toString()}  <->  ItemType : ${itemType.toString()}").fontSize(12).width(100.percent).backgroundColor(0x3dc49d)
            .padding(top:0, right:60, bottom:0, left:0)
             Row() {
                Button("setItemAnimation(OvershootInLeft)").fontSize(14).width(85.percent).padding(10).margin(10).onClick(
                {
                    event =>
                        this.controller.setItemAnimation(this.itemType)
                        this.controller.addValue(0, "OvershootInLeft")
                        PromptAction.showToast(message:"设置AdapterAnimationType不为Default，RecyclerView的array初始为空，无动画显示", duration: 1500 )
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

