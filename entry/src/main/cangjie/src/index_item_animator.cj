/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.ArrayList
import recyclerview.RecyclerView
import recyclerview.ItemAnimationType
import recyclerview.AdapterAnimationType
import recyclerview.Controller

@Entry
@Component
class IndexItemAnimator {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>();
    private var selectOptions: Array<SelectOption> = Array<SelectOption>(
        [
            SelectOption('FadeIn', icon: @r(app.media.icon)),
            SelectOption('FadeInDown', icon: @r(app.media.icon)),
            SelectOption('FadeInUp', icon: @r(app.media.icon)),
            SelectOption('FadeInLeft', icon: @r(app.media.icon)),
            SelectOption('FadeInRight', icon: @r(app.media.icon)),
            SelectOption('Landing', icon: @r(app.media.icon)),
            SelectOption('ScaleIn', icon: @r(app.media.icon)),
            SelectOption('ScaleInTop', icon: @r(app.media.icon)),
            SelectOption('ScaleInBottom', icon: @r(app.media.icon)),
            SelectOption('ScaleInLeft', icon: @r(app.media.icon)),
            SelectOption('ScaleInRight', icon: @r(app.media.icon)),
            SelectOption('SlideInLeft', icon: @r(app.media.icon)),
            SelectOption('SlideInRight', icon: @r(app.media.icon)),
            SelectOption('SlideInDown', icon: @r(app.media.icon)),
            SelectOption('SlideInUp', icon: @r(app.media.icon)),
            SelectOption('OvershootInRight', icon: @r(app.media.icon)),
            SelectOption('OvershootInLeft', icon: @r(app.media.icon))
        ]
    );
    private var animTypes: ArrayList<AnimType> = ArrayList<AnimType>(
        [
            AnimType('FadeIn', ItemAnimationType.FadeIn),
            AnimType('FadeInDown', ItemAnimationType.FadeInDown),
            AnimType('FadeInUp', ItemAnimationType.FadeInUp),
            AnimType('FadeInLeft', ItemAnimationType.FadeInLeft),
            AnimType('FadeInRight', ItemAnimationType.FadeInRight),
            AnimType('Landing', ItemAnimationType.Landing),
            AnimType('ScaleIn', ItemAnimationType.ScaleIn),
            AnimType('ScaleInTop', ItemAnimationType.ScaleInTop),
            AnimType('ScaleInBottom', ItemAnimationType.ScaleInBottom),
            AnimType('ScaleInLeft', ItemAnimationType.ScaleInLeft),
            AnimType('ScaleInRight', ItemAnimationType.ScaleInRight),
            AnimType('SlideInLeft', ItemAnimationType.SlideInLeft),
            AnimType('SlideInRight', ItemAnimationType.SlideInRight),
            AnimType('SlideInDown', ItemAnimationType.SlideInDown),
            AnimType('SlideInUp', ItemAnimationType.SlideInUp),
            AnimType('OvershootInRight', ItemAnimationType.OvershootInRight),
            AnimType('OvershootInLeft', ItemAnimationType.OvershootInLeft)
        ]
    );
    private var animTimes: Array<SelectOption> = Array<SelectOption>(
        [
            SelectOption('0.5s', icon: @r(app.media.icon)),
            SelectOption('3s', icon: @r(app.media.icon)),
            SelectOption('60s', icon: @r(app.media.icon)),
            SelectOption('1000s', icon: @r(app.media.icon))
        ]
    );
    private var animTime: ArrayList<AnimTime> = ArrayList<AnimTime>(
        [
            AnimTime('0.5s', 500),
            AnimTime('3s', 3000),
            AnimTime('60s', 60000),
            AnimTime('1000s', 1000000)
        ]
    );

    @State
    var controller: Controller = Controller()
    @State
    var selectIndex: Int32 = 0
    @State
    var selectIndex1: Int32 = 0
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
                Flex(
                    FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center,
                    justifyContent: FlexAlign.Start)) {
                    Select(this.selectOptions).selected(this.selectIndex).value(
                        this.animTypes[Int64(this.selectIndex)].value).backgroundColor(0x3dc49d).onSelect(
                        {
                            index: Int32, text: String =>
                            this.selectIndex = index
                            this.controller.setItemAnimation(this.animTypes[Int64(index)].enumType)
                        }
                    )
                }.width(70.percent).height(50).backgroundColor(0x3dc49d)

                Flex(
                    FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center,
                    justifyContent: FlexAlign.Start)) {
                    Select(this.animTimes).selected(this.selectIndex1).value(
                        this.animTime[Int64(this.selectIndex1)].value).backgroundColor(0x3dc49d).onSelect(
                        {
                            index: Int32, text: String =>
                            this.selectIndex1 = index
                            this.controller.setDuration(this.animTime[Int64(index)].time)
                        }
                    )
                }.width(70.percent).height(50).backgroundColor(0x3dc49d)

                Row() {
                    Text('ADD').fontSize(18).padding(8).onClick(
                        {
                            event =>
                                this.addFlag += 1
                                this.controller.addValue(0, "ADD");
                                this.listDataTailFlag += 1
                        }
                    )
                    Text('DEL').fontSize(18).padding(8).onClick(
                        {
                            event =>
                            let deleteIndex: Int64 = 0;
                            if (this.listDataTailFlag >= deleteIndex) {
                                this.controller.deleteValue(0);
                                this.listDataTailFlag -= 1
                            }
                        }
                    )
                }.width(100.percent).height(50).backgroundColor(0x3dc49d)
            }.width(100.percent).height(100.percent)
            Column() {
                RecyclerView(
                    array: this.listDatas,
                    controller: this.controller,
                    columnsNum: 1,
                    child: this.SpecificChild
                )
            }.margin(top: 50)
        }
    }

    @Builder
    func SpecificChild(itemData: String) {
        Column() {
            Image(@r(app.media.sample13)).width(100.percent).height(100)
            Text(itemData + '').fontSize(20).textAlign(TextAlign.Center).width(100.percent)
        }.margin(10)
    }
}

class AnimType {
    var value: String
    var enumType: ItemAnimationType

    public init(value: String, enumType: ItemAnimationType) {
        this.value = value
        this.enumType = enumType
    }
}

class AnimTime {
    var value: String
    var time: Int32

    public init(value: String, time: Int32) {
        this.value = value
        this.time = time
    }
}
