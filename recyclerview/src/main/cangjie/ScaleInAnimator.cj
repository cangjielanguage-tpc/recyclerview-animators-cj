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
class ScaleInAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @Link
    var controller: Controller = Controller();
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    @State
    var duration: Int32 = 0;
    var isClick: Bool = true;
    @Link
    var columnsNum: Int64 = 1;
    @BuilderParam
    var child: (String) -> Unit
    @State
    var trans: Int64 = 0;
    var colNumStr: String = '';
    @State
    var landing: Float32 = 1.0

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexScaleIn: Int64, value: String => this.addValue(indexScaleIn, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexScaleIn: Int64 => this.deleteValue(indexScaleIn);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        AppLog.info("myarr size:" + this
            .myArr
            .size
            .toString());
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexScaleIn: Int64, value: String) {
        if (0 > indexScaleIn) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0;
        this.duration = 0;
        this.landing = 0.0
        this
            .myArr
            .insert(indexScaleIn, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.landing = 1.0
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexScaleIn] = newArr
                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxScaleIn in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxScaleIn]
                                .isNewValue = false;
                        }
                        this.isClick = true;
                }
        }
    }

    func deleteValue(indexScaleIn: Int64) {
        if (0 > indexScaleIn) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexScaleIn >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false

        let currentData = ArrayType(isNewValue: this.myArr[indexScaleIn].isNewValue, value: this.myArr[indexScaleIn].value)
        currentData.isNewValue = true
        this.landing = 1.0
        this.trans = 1
        this.duration = 0

        this.myArr[indexScaleIn] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.landing = 0.0
                this.trans = 0;
                this.duration = this
                    .controller
                    .duration
                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this.landing = 1.0;
                        this
                            .myArr
                            .remove(indexScaleIn)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    item: ArrayType, indexScaleIn: Int64 => GridItem() {
                        child(item.value)
                    }
                        .animationStart(
                            AnimateParam(
                                delay: 50, // 动画延迟
                                iterations: 1, // 播放次数
                                duration: this.duration,
                                curve: Curve.Ease,
                                playMode: PlayMode.Normal
                            )
                        )
                        .opacity(if (item.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .scale(
                            x: (if (item.isNewValue) {
                                this.landing;
                            } else {
                                1.0;
                            }),
                            y: (if (item.isNewValue) {
                                this.landing
                            } else {
                                1.0
                            }),
                            z: (if (item.isNewValue) {
                                this.landing;
                            } else {
                                1.0
                            }),
                            centerX: 50.percent,
                            centerY: 50.percent
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {item: ArrayType, indexScaleIn: Int64 => "${item.toString()}${indexScaleIn}"}
            )
        }
            .columnsGap(2)
            .columnsTemplate(this.colNumStr)
            .rowsGap(2)
            .onScrollIndex({
                firstScaleIn: UInt32 => AppLog.info(firstScaleIn.toString())
            })
            .width(100.percent)
    }
}
