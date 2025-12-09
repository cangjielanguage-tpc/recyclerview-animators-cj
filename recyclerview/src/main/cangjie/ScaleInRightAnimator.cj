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
class ScaleInRightAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    @State
    var duration: Int32 = 0;
    var isClick: Bool = true;
    @State
    var trans: Int64 = 0;
    @State
    var landing: Float32 = 1.0;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexScaleInRight: Int64, value: String => this.addValue(indexScaleInRight, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexScaleInRight: Int64 => this.deleteValue(indexScaleInRight);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexScaleInRight: Int64, value: String) {
        if (0 > indexScaleInRight) {
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
            .insert(indexScaleInRight, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.landing = 1.0
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexScaleInRight] = newArr

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (indexScaleInRight in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[indexScaleInRight]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexScaleInRight: Int64) {
        if (0 > indexScaleInRight) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexScaleInRight >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false

        let currentData = ArrayType(isNewValue: this.myArr[indexScaleInRight].isNewValue, value: this.myArr[indexScaleInRight].value)
        currentData.isNewValue = true
        this.landing = 1.0
        this.trans = 1
        this.duration = 0

        this.myArr[indexScaleInRight] = currentData
        Timer.once(100 * Duration.millisecond) {
            =>
                this.landing = 0.0
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this.landing = 1.0
                        this
                            .myArr
                            .remove(indexScaleInRight)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemScaleInRight: ArrayType, indexScaleInRight: Int64 => GridItem() {
                        child(itemScaleInRight.value)
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
                        .opacity(if (itemScaleInRight.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .scale(
                            x: (if (itemScaleInRight.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            y: (if (itemScaleInRight.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            z: (if (itemScaleInRight.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            centerX: (if (itemScaleInRight.isNewValue) {
                                100.percent
                            } else {
                                50.percent
                            }),
                            centerY: 50.percent
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemScaleInRight: ArrayType, indexScaleInRight: Int64 => "${itemScaleInRight.toString()}${indexScaleInRight}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstScaleInRight: UInt32 => AppLog.info(firstScaleInRight.toString())
            })
            .width(100.percent)
    }
}
