/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.level_1

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.hilog.*
import ohos.state_macro_manage.*
import ohos_app_cangjie_entry.*

import std.collection.ArrayList
import recyclerview.RecyclerView
import recyclerview.ItemAnimationType
import recyclerview.AdapterAnimationType
import recyclerview.Controller

@Entry
@Component
class Test_RecycleRview_FadeIn_13 {
    var listDatas: ObservedArrayList<String> = listDatas2
    @State
    var controller: Controller = Controller()
    var adapterType:AdapterAnimationType = AdapterAnimationType.Default
    var itemType:ItemAnimationType = ItemAnimationType.FadeIn

    protected override func aboutToAppear() {
        this.controller.setAdapterAnimation(this.adapterType)
        this.controller.setDuration(2500)
        this.controller.setFirstOnly(false)

    }

    func build() {
        Column() {
            Text("AdapterType : Default  <->  ItemType : ${itemType.toString()}").fontSize(14).width(100.percent).backgroundColor(0x3dc49d)
            .padding(top:0, right:60, bottom:0, left:0)
            Row() {
                Button("ItemAnimationType.FadeIn").fontSize(16).padding(top: 0, right:10, bottom:0, left:10).margin(10).onClick(
                {
                    event =>
                        this.controller.setItemAnimation(this.itemType)
                        this.controller.addValue(listDatas.size -1, "Test_RecycleRview_FadeIn_13")
                })

//                Button('del').fontSize(16).padding(10).margin(10).onClick(
//                {
//                    event =>
//                    let deleteIndex: Int64 = 0;
//                    if (this.listDataTailFlag >= deleteIndex) {
//                        this.controller.deleteValue(0);
//                        this.listDataTailFlag -= 1
//                    }
//                })
            }
            RecyclerView(array: this.listDatas,controller: this.controller,columnsNum: 1,child: this.SpecificChild)

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

