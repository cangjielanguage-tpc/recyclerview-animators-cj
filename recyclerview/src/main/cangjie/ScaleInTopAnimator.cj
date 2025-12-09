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
class ScaleInTopAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    var isClick: Bool = true
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    @State
    var duration: Int32 = 0;
    @State
    var trans: Int64 = 0;
    @Link
    var columnsNum: Int64 = 1
    var colNumStr: String = '';
    @State
    var landing: Float32 = 1.0;

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexScaleInTop: Int64, value: String => this.addValue(indexScaleInTop, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexScaleInTop: Int64 => this.deleteValue(indexScaleInTop);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexScaleInTop: Int64, value: String) {
        if (0 > indexScaleInTop) {
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
            .insert(indexScaleInTop, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.landing = 1.0
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexScaleInTop] = newArr
                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxScaleInTop in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxScaleInTop]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexScaleInTop: Int64) {
        if (0 > indexScaleInTop) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexScaleInTop >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false

        let currentData = ArrayType(isNewValue: this.myArr[indexScaleInTop].isNewValue, value: this.myArr[indexScaleInTop].value)
        currentData.isNewValue = true
        this.landing = 1.0
        this.trans = 1
        this.duration = 0
        this.myArr[indexScaleInTop] = currentData
        Timer.once(100 * Duration.millisecond) {
            =>
                this.landing = 0.0;
                this.trans = 1
                this.duration = this
                    .controller
                    .duration;
                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0;
                        this.landing = 1.0
                        this
                            .myArr
                            .remove(indexScaleInTop)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemScaleInTop: ArrayType, indexScaleInTop: Int64 => GridItem() {
                        child(itemScaleInTop.value)
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
                        .opacity(if (itemScaleInTop.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .scale(
                            x: (if (itemScaleInTop.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            y: (if (itemScaleInTop.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            z: (if (itemScaleInTop.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            centerX: 50.percent,
                            centerY: (if (itemScaleInTop.isNewValue) {
                                0.percent
                            } else {
                                50.percent
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemScaleInTop: ArrayType, indexScaleInTop: Int64 => "${itemScaleInTop.toString()}${indexScaleInTop}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstScaleInTop: UInt32 => AppLog.info(firstScaleInTop.toString())
            })
            .width(100.percent)
    }
}
