/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.level_1

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.hilog.*
import ohos.prompt_action.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.*

import std.collection.ArrayList
import recyclerview.RecyclerView
import recyclerview.ItemAnimationType
import recyclerview.AdapterAnimationType
import recyclerview.Controller

@Entry
@Component
class Test_RecycleRview_FadeIn_11 {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>();
    @State
    var controller: Controller = Controller()
    var adapterType:AdapterAnimationType = AdapterAnimationType.Default
    var itemType:ItemAnimationType = ItemAnimationType.FadeIn
    var text:String = "Test_RecycleRview_FadeIn_11"

    protected override func aboutToAppear() {
        this.controller.setAdapterAnimation(this.adapterType)
        this.controller.setItemAnimation(this.itemType)
        this.controller.setDuration(2000)
    }

    func build() {
        Column() {
            Text("AdapterType : Default  <->  ItemType : ${itemType.toString()}").fontSize(14).width(100.percent).backgroundColor(0x3dc49d)
            .padding(top:0, right:60, bottom:0, left:0)
            Row() {
                Button("setFirstOnly(false)").fontSize(16).width(45.percent).padding(10).margin(10).onClick(
                {
                    event =>
                        this.controller.setFirstOnly(false)
                        this.controller.addValue(0, text)
                })
            }
            Row() {
                Button("getItemAnimation").fontSize(14).width(45.percent).padding(10).margin(10).onClick(
                {
                    event =>
                        if(this.controller.getItemAnimation() == this.itemType){
                            PromptAction.showToast(message:"设置的ItemAnimation为：${this.itemType}", duration: 1500 )
                        }
                })

                Button("getAdapterAnimation").fontSize(14).padding(10).width(45.percent).margin(10).onClick(
                {
                    event =>
                    if(this.controller.getAdapterAnimation() == this.adapterType){
                        PromptAction.showToast(message:"设置的AdapterAnimation为：Default", duration: 1500 )
                    }
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
            Text(itemData).fontSize(20).textAlign(TextAlign.Center).width(100.percent)
        }.margin(10)
    }
}

