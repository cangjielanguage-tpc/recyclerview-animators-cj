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
import recyclerview.AdapterAnimationType
import recyclerview.ItemAnimationType
import recyclerview.Controller
import ohos.resource_manager.__GenerateResource__

@Entry
@Component
class IndexAdapterAnimator {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>(
        ["Apple", "Ball", "Camera", "Day", "Egg", "Foo", "GL", "Hello", "Iron", "Japan", "Coke", "Dog", "Cat", "Yahoo",
        "Sony", "Canon", "Fujitsu", "USA", "Nexus", "LINE", "Haskell", "C++", "Java", "Go", "Swift", "Objective-c",
        "Ruby", "PHP", "Bash", "ksh", "C", "Groovy", "Kotlin", "Chip", "Japan", "U.S.A", "San Francisco", "Paris",
        "Tokyo", "Silicon Valley", "London", "Spain", "China", "Taiwan", "Asia", "New York", "France", "Kyoto", "AD",
        "GL", "iPhone", "iPad", "iPod", "Wasabeef"]);
    private var animTypes: ArrayList<AdaptAnimType> = ArrayList<AdaptAnimType>(
        [
            AdaptAnimType('AlphaIn', AdapterAnimationType.AlphaIn),
            AdaptAnimType('ScaleIn', AdapterAnimationType.ScaleIn),
            AdaptAnimType('SlideInBottom', AdapterAnimationType.SlideInBottom),
            AdaptAnimType('SlideInLeft', AdapterAnimationType.SlideInLeft),
            AdaptAnimType('SlideInRight', AdapterAnimationType.SlideInRight)
        ]
    );
    private var selectOptions: Array<SelectOption> = ArrayList<SelectOption>(
        [
            SelectOption('AlphaIn', icon: @r(app.media.icon)),
            SelectOption('ScaleIn', icon: @r(app.media.icon)),
            SelectOption('SlideInBottom', icon: @r(app.media.icon)),
            SelectOption('SlideInLeft', icon: @r(app.media.icon)),
            SelectOption('SlideInRight', icon: @r(app.media.icon))
        ]
    ).toArray()

    @State
    var controller: Controller = Controller()
    @State
    var selectIndex: Int32 = 0

    protected override func aboutToAppear() {
        this.controller.setItemAnimation(ItemAnimationType.Default)
        this.controller.setAdapterAnimation(AdapterAnimationType.AlphaIn)
        this.controller.setFirstOnly(false)
        this.controller.setDuration(3000)
    }

    func build() {
        Stack(Alignment.Top) {
            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start)
            ) {
            Select(this.selectOptions).selected(this.selectIndex).value(
                    this.animTypes[Int64(this.selectIndex)].value).backgroundColor(0x3dc49d)
                .onSelect({
                    index: Int32, text: String =>
                    this.selectIndex = index
                    this.controller.setAdapterAnimation(this.animTypes[Int64(index)].enumType)
                })
            }.width(100.percent).height(50).backgroundColor(0x3dc49d)
            Column() {
                RecyclerView(
                    array: this.listDatas,
                    controller: this.controller,
                    child: this.SpecificChild,
                    columnsNum: 1
                )
            }.margin(top: 50)
        }.width(100.percent).height(100.percent)
    }

    @Builder
    func SpecificChild(itemData: String) {
        Column() {
            Image(@r(app.media.sample13)).width(100.percent).height(100)
            Text(itemData + '').fontSize(20).textAlign(TextAlign.Center).width(100.percent)
        }.margin(10)
    }
}

class AdaptAnimType {
    var value: String
    var enumType: AdapterAnimationType

    public init(value: String, enumType: AdapterAnimationType) {
        this.value = value
        this.enumType = enumType
    }
}
