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
import ohos.hilog.Hilog

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

    @State
    var controller: Controller = Controller()
    @State
    var selectIndex: Int32 = 0
    @State
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

    func asd():String {
        Hilog.info(0x0000, "recycler123", "value:${this.animTypes[Int64(this.selectIndex)].value}")
        return this.animTypes[Int64(this.selectIndex)].value
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

                Row() {
                    Text('ADD').fontSize(18).padding(8).onClick(
                        {
                            event =>
                                this.addFlag += 1
                                this.controller.addValue(0, "add_${valIndex}");
                                this.listDataTailFlag += 1
                                this.valIndex ++
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
        }.margin(asddd(itemData))
    }

    func asddd(itemData: String):Int64 {
        Hilog.info(0x0000, "recycler123", "itemData:${itemData}")
        return 10
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
