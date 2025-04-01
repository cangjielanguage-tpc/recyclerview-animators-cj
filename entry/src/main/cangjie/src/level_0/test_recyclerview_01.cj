/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.level_0

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
class Test_RecycleRview_01 {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>();

    @State
    var controller: Controller = Controller()
    @State
    var selectIndex: Int32 = 0
//    @State
    var valIndex: Int32 = 0
    @State
    var listDataTailFlag: Int64 = this.listDatas.size - 1;
    @State
    var addFlag: Int64 = 0;

    protected override func aboutToAppear() {
        this.controller.setAdapterAnimation(AdapterAnimationType.Default)
        this.controller.setItemAnimation(ItemAnimationType.FadeIn)
        this.controller.setDuration(500)
        this.controller.setFirstOnly(false)
    }

    func build() {
        Stack(Alignment.Top) {
            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start)) {
                Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center,justifyContent: FlexAlign.Start)) {
                Text(ItemAnimationType.FadeIn.toString()).fontSize(16).padding(top:10, right:120, bottom:10, left:10)
                Row() {
                    Text('add').fontSize(16).padding(10).onClick(
                        {
                            event =>
                                this.addFlag += 1
                                this.controller.addValue(0, "add_${valIndex}");
                                this.listDataTailFlag += 1
                                this.valIndex ++
                                Hilog.error(0, "xxxxxx", "valIndex =  ${valIndex}")
                        }
                    )
                    Text('del').fontSize(16).padding(10).onClick(
                        {
                            event =>
                            let deleteIndex: Int64 = 0;
                            if (this.listDataTailFlag >= deleteIndex) {
                                this.controller.deleteValue(0);
                                this.listDataTailFlag -= 1
                            }
                        }
                    )
                }
            }.width(100.percent).height(50).backgroundColor(0x3dc49d)
        }.width(100.percent).height(100.percent)
        Column() {
            RecyclerView(
                array: this.listDatas,
                controller: this.controller,
                columnsNum: 1,
                child: this.SpecificChild
            )}.margin(top:50)
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

