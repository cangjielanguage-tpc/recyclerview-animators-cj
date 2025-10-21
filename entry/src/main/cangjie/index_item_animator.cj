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
import ohos.resource_manager.__GenerateResource__

@Entry
@Component
class IndexItemAnimator {
    var listDatas: ObservedArrayList<String> = ObservedArrayList<String>();
    private var selectOptions: Array<SelectOption> = ArrayList<SelectOption>(
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
    ).toArray()
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
    var listDataTailFlag: Int64 = this
        .listDatas
        .size - 1;
    @State
    var addFlag: Int64 = 0;

    protected override func aboutToAppear() {
        this
            .controller
            .setAdapterAnimation(AdapterAnimationType.Default)
        this
            .controller
            .setItemAnimation(ItemAnimationType.FadeIn)
        this
            .controller
            .setDuration(500)
        this
            .controller
            .setFirstOnly(false)
    }

    func asd(): String {
        return this
            .animTypes[Int64(this.selectIndex)]
            .value
    }

    @Builder
    func MyMenu1() {
        Menu() {
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[0]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[0]
                                    .enumType)
                            content1 = this
                                .animTypes[0]
                                .value
                    }
                )
                .id(this
                    .animTypes[0]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[1]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[1]
                                    .enumType)
                            content1 = this
                                .animTypes[1]
                                .value
                    }
                )
                .id(this
                    .animTypes[1]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[2]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[2]
                                    .enumType)
                            content1 = this
                                .animTypes[2]
                                .value
                    }
                )
                .id(this
                    .animTypes[2]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[3]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[3]
                                    .enumType)
                            content1 = this
                                .animTypes[3]
                                .value
                    }
                )
                .id(this
                    .animTypes[3]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[4]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[4]
                                    .enumType)
                            content1 = this
                                .animTypes[4]
                                .value
                    }
                )
                .id(this
                    .animTypes[4]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[5]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[5]
                                    .enumType)
                            content1 = this
                                .animTypes[5]
                                .value
                    }
                )
                .id(this
                    .animTypes[5]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[6]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[6]
                                    .enumType)
                            content1 = this
                                .animTypes[6]
                                .value
                    }
                )
                .id(this
                    .animTypes[6]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[7]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[7]
                                    .enumType)
                            content1 = this
                                .animTypes[7]
                                .value
                    }
                )
                .id(this
                    .animTypes[7]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[8]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[8]
                                    .enumType)
                            content1 = this
                                .animTypes[8]
                                .value
                    }
                )
                .id(this
                    .animTypes[8]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[9]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[9]
                                    .enumType)
                            content1 = this
                                .animTypes[9]
                                .value
                    }
                )
                .id(this
                    .animTypes[9]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[10]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[10]
                                    .enumType)
                            content1 = this
                                .animTypes[10]
                                .value
                    }
                )
                .id(this
                    .animTypes[10]
                    .value)
        }
    }

    @Builder
    func MyMenu2() {
        Menu() {
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[11]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[11]
                                    .enumType)
                            content2 = this
                                .animTypes[11]
                                .value
                    }
                )
                .id(this
                    .animTypes[11]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[12]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[12]
                                    .enumType)
                            content2 = this
                                .animTypes[12]
                                .value
                    }
                )
                .id(this
                    .animTypes[12]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[13]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[13]
                                    .enumType)
                            content2 = this
                                .animTypes[13]
                                .value
                    }
                )
                .id(this
                    .animTypes[13]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[14]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[14]
                                    .enumType)
                            content2 = this
                                .animTypes[14]
                                .value
                    }
                )
                .id(this
                    .animTypes[14]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[15]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[15]
                                    .enumType)
                            content2 = this
                                .animTypes[15]
                                .value
                    }
                )
                .id(this
                    .animTypes[15]
                    .value)
            MenuItem(
                startIcon: "",
                content: this
                    .animTypes[16]
                    .value,
                endIcon: "",
                labelInfo: "",
            )
                .selectIcon(true)
                .onChange(
                    {
                        selected =>
                            this
                                .controller
                                .setItemAnimation(this
                                    .animTypes[16]
                                    .enumType)
                            content2 = this
                                .animTypes[16]
                                .value
                    }
                )
                .id(this
                    .animTypes[16]
                    .value)
        }
    }

    @State
    var content1: String = "FadeIn"
    @State
    var content2: String = "SlideInLeft"

    func build() {
        Stack(Alignment.Top) {
            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start)) {
                Flex(
                    FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center,
                        justifyContent: FlexAlign.Start)) {
                    Text(content1)
                        .fontWeight(FontWeight.Bold)
                        .bindMenu(builder: this.MyMenu1)
                        .id("ItemAnimator1")
                    Text(content2)
                        .fontWeight(FontWeight.Bold)
                        .bindMenu(builder: this.MyMenu2)
                        .id("ItemAnimator2")
                }
                    .width(70.percent)
                    .height(50)
                    .backgroundColor(0x3dc49d)

                Row() {
                    Text('ADD')
                        .fontSize(18)
                        .padding(8)
                        .onClick(
                            {
                                event =>
                                    this.addFlag += 1
                                    this
                                        .controller
                                        .addValue(0, "add_${valIndex}")
                                    this.listDataTailFlag += 1
                                    this.valIndex++
                            }
                        )
                        .id("add")
                    Text('DEL')
                        .fontSize(18)
                        .padding(8)
                        .onClick(
                            {
                                event =>
                                    let deleteIndex: Int64 = 0;
                                    if (this.listDataTailFlag >= deleteIndex) {
                                        this
                                            .controller
                                            .deleteValue(0);
                                        this.listDataTailFlag -= 1
                                    }
                            }
                        )
                        .id("del")
                }
                    .width(100.percent)
                    .height(50)
                    .backgroundColor(0x3dc49d)
            }
                .width(100.percent)
                .height(100.percent)
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
            Image(@r(app.media.sample13))
                .width(100.percent)
                .height(100)
            Text(itemData + '')
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .width(100.percent)
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
