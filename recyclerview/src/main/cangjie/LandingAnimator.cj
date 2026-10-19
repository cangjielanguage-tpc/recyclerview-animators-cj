/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package recyclerview

import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import std.sync.*

@Component
class LandingAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    @State
    var duration: Int32 = 0
    @State
    var trans: Int64 = 0;
    @State
    var landing: Float32 = 1.0
    @Link
    var columnsNum: Int64 = 1
    var colNumStr: String = ''
    var isClick: Bool = true

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexLanding: Int64, value: String => this.addValue(indexLanding, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexLanding: Int64 => this.deleteValue(indexLanding);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexLanding: Int64, value: String) {
        if (0 > indexLanding) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        this.landing = 1.5
        this
            .myArr
            .insert(indexLanding, newArr)
        MainTimer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.landing = 1.0
                this.myArr[indexLanding] = newArr

                MainTimer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxLanding in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxLanding]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexLanding: Int64) {
        if (0 > indexLanding) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexLanding >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexLanding].isNewValue, value: this.myArr[indexLanding].value)
        currentData.isNewValue = true
        this.trans = 1
        this.landing = 1.0
        this.duration = 0
        this.myArr[indexLanding] = currentData

        MainTimer.once(100 * Duration.millisecond) {
            =>
                this.trans = 0
                this.landing = 1.5
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexLanding] = currentData
                MainTimer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this.landing = 1.0
                        this
                            .myArr
                            .remove(indexLanding)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemLanding: ArrayType, indexLanding: Int64 => GridItem() {
                        child(itemLanding.value)
                    }
                        .animationStart(
                            AnimateParam(
                                duration: this.duration,
                                curve: Curve.Ease,
                                delay: 50, // 动画延迟
                                iterations: 1, // 播放次数
                                playMode: PlayMode.Normal
                            )
                        )
                        .opacity(if (itemLanding.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .scale(
                            x: (if (itemLanding.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            y: (if (itemLanding.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            z: (if (itemLanding.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemLanding: ArrayType, indexLanding: Int64 => "${itemLanding.toString()}${indexLanding}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstLanding: UInt32 => AppLog.info(firstLanding.toString())
            })
            .width(100.percent)
    }
}
