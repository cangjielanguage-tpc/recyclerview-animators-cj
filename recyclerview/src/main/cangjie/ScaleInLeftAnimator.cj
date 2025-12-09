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
class ScaleInLeftAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>()
    var isClick: Bool = true;
    @State
    var duration: Int32 = 0
    @State
    var trans: Int64 = 0;
    @State
    var landing: Float32 = 1.0
    var colNumStr: String = '';
    @Link
    var columnsNum: Int64 = 1;

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexScaleInLeft: Int64, value: String => this.addValue(indexScaleInLeft, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexScaleInLeft: Int64 => this.deleteValue(indexScaleInLeft);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexScaleInLeft: Int64, value: String) {
        if (0 > indexScaleInLeft) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 1
        this.duration = 0
        this.landing = 0.0
        this
            .myArr
            .insert(indexScaleInLeft, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.landing = 1.0
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexScaleInLeft] = newArr
                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxScaleInLeft in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxScaleInLeft]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexScaleInLeft: Int64) {
        if (0 > indexScaleInLeft) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexScaleInLeft >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false

        let currentData = ArrayType(isNewValue: this.myArr[indexScaleInLeft].isNewValue, value: this.myArr[indexScaleInLeft].value)
        currentData.isNewValue = true
        this.landing = 1.0
        this.trans = 1
        this.duration = 0

        this.myArr[indexScaleInLeft] = currentData
        Timer.once(100 * Duration.millisecond) {
            =>
                this.landing = 0.0
                this.duration = this
                    .controller
                    .duration
                this.trans = 1
                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.landing = 1.0
                        this.duration = 0;
                        this
                            .myArr
                            .remove(indexScaleInLeft)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemScaleInLeft: ArrayType, indexScaleInLeft: Int64 => GridItem() {
                        child(itemScaleInLeft.value)
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
                        .opacity(if (itemScaleInLeft.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .scale(
                            x: (if (itemScaleInLeft.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            y: (if (itemScaleInLeft.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            z: (if (itemScaleInLeft.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            centerX: (if (itemScaleInLeft.isNewValue) {
                                0.percent
                            } else {
                                50.percent
                            }),
                            centerY: 50.percent
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemScaleInLeft: ArrayType, indexScaleInLeft: Int64 => "${itemScaleInLeft.toString()}${indexScaleInLeft}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstScaleInLeft: UInt32 => AppLog.info(firstScaleInLeft.toString())
            })
            .width(100.percent)
    }
}
