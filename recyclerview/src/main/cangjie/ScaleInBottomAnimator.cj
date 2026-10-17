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
class ScaleInBottomAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    var isClick: Bool = true;
    @State
    var duration: Int32 = 0
    @State
    var trans: Int64 = 0;
    @Link
    var columnsNum: Int64 = 1;
    @State
    var landing: Float32 = 1.0
    var colNumStr: String = ''

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexScaleInBottom: Int64, value: String => this.addValue(indexScaleInBottom, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexScaleInBottom: Int64 => this.deleteValue(indexScaleInBottom);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexScaleInBottom: Int64, value: String) {
        if (0 > indexScaleInBottom) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr1 = ArrayType(isNewValue: true, value: value);
        this.trans = 1
        this.duration = 0
        this.landing = 0.0
        this
            .myArr
            .insert(indexScaleInBottom, newArr1)
        MainTimer.once(200 * Duration.millisecond) {
            =>
                let newArr2 = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.landing = 1.0
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexScaleInBottom] = newArr2
                MainTimer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (indexScaleInBottom in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[indexScaleInBottom]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexScaleInBottom: Int64) {
        if (0 > indexScaleInBottom) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexScaleInBottom >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false

        let currentData = ArrayType(isNewValue: this.myArr[indexScaleInBottom].isNewValue, value: this.myArr[indexScaleInBottom].value)
        currentData.isNewValue = true

        this.landing = 1.0
        this.trans = 1
        this.duration = 0

        this.myArr[indexScaleInBottom].isNewValue = true

        MainTimer.once(100 * Duration.millisecond) {
            =>
                this.landing = 0.0
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexScaleInBottom] = currentData

                MainTimer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this.landing = 1.0
                        this
                            .myArr
                            .remove(indexScaleInBottom)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemScaleInBottom: ArrayType, indexScaleInBottom: Int64 => GridItem {
                        child(itemScaleInBottom.value)
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
                        .opacity(if (itemScaleInBottom.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .scale(
                            x: (if (itemScaleInBottom.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            y: (if (itemScaleInBottom.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            z: (if (itemScaleInBottom.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            centerX: 50.percent,
                            centerY: (if (itemScaleInBottom.isNewValue) {
                                100.percent
                            } else {
                                50.percent
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemScaleInBottom: ArrayType, indexScaleInBottom: Int64 => "${itemScaleInBottom.toString()}${indexScaleInBottom}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstScaleInBottom: UInt32 => AppLog.info(firstScaleInBottom.toString())
            })
            .width(100.percent)
    }
}
