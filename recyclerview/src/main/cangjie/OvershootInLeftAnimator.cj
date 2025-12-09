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
class OvershootInLeftAnimator {
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
    @Link
    var columnsNum: Int64 = 1
    @State
    var x: Length = 0.percent;
    @State
    var y: Length = 0.percent
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexOvershootInLeft: Int64, valueOvershootInLeft: String => this.addValue(indexOvershootInLeft, valueOvershootInLeft);
        }

        this
            .controller
            .deleteValueCallback = {
            indexOvershootInLeft: Int64 => this.deleteValue(indexOvershootInLeft);
        }

        for (idx in 0..this.array.size) {
            let newArrOvershootInLeft = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArrOvershootInLeft)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(index: Int64, value: String) {
        if (0 > index) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArrOvershootInLeft = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        this.x = (-100).percent
        this.y = 0.percent
        this
            .myArr
            .insert(index, newArrOvershootInLeft)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArrOvershootInLeft = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.x = 5.percent
                this.y = 0.percent
                this.myArr[index] = newArrOvershootInLeft
                Timer.once(Int64(this
                    .controller
                    .duration + 50) * Duration.millisecond) {
                    =>
                        this.duration = 50
                        this.x = 0.percent
                }

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxOvershootInLeft in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxOvershootInLeft]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexOvershootInLeft: Int64) {
        if (0 > indexOvershootInLeft) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexOvershootInLeft >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexOvershootInLeft].isNewValue, value: this.myArr[indexOvershootInLeft].value)
        currentData.isNewValue = true

        this.x = 5.percent
        this.y = 0.percent
        this.trans = 1
        this.duration = 0
        this.myArr[indexOvershootInLeft] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.x = (-100).percent
                this.y = 0.percent
                this.trans = 0
                this.duration = this
                    .controller
                    .duration;
                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this.x = 0.percent;
                        this.y = 0.percent
                        this
                            .myArr
                            .remove(indexOvershootInLeft)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    item: ArrayType, indexOvershootInLeft: Int64 => GridItem() {
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
                            this.trans;
                        } else {
                            1;
                        })
                        .offset(
                            x: (if (item.isNewValue) {
                                this.x;
                            } else {
                                0.vp
                            }),
                            y: (if (item.isNewValue) {
                                this.y;
                            } else {
                                0.vp
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {item: ArrayType, indexOvershootInLeft: Int64 => "${item.toString()}${indexOvershootInLeft}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .onScrollIndex({
                first: UInt32 => AppLog.info(first.toString())
            })
            .columnsGap(2)
            .rowsGap(2)
            .width(100.percent)
    }
}
