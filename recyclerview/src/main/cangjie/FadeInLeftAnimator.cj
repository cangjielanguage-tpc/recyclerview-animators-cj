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
class FadeInLeftAnimator {
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
    var offsetX: Int64 = -50;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexFadeInLeft: Int64, value: String => this.addValue(indexFadeInLeft, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexFadeInLeft: Int64 => this.deleteValue(indexFadeInLeft);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexFadeInLeft: Int64, value: String) {
        if (0 > indexFadeInLeft) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        this.offsetX = -50
        this
            .myArr
            .insert(indexFadeInLeft, newArr)
        MainTimer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.offsetX = 0
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexFadeInLeft] = newArr

                MainTimer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxFadeInLeft in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxFadeInLeft]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexFadeInLeft: Int64) {
        if (0 > indexFadeInLeft) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexFadeInLeft >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexFadeInLeft].isNewValue, value: this.myArr[indexFadeInLeft].value)
        currentData.isNewValue = true
        this.trans = 1
        this.offsetX = 0
        this.duration = 0
        this.myArr[indexFadeInLeft] = currentData

        MainTimer.once(100 * Duration.millisecond) {
            =>
                this.trans = 0
                this.offsetX = -50
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexFadeInLeft] = currentData

                MainTimer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this
                            .myArr
                            .remove(indexFadeInLeft)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemFadeInLeft: ArrayType, indexFadeInLeft: Int64 => GridItem() {
                        child(itemFadeInLeft.value)
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
                        .opacity(if (itemFadeInLeft.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .offset(
                            x: (if (itemFadeInLeft.isNewValue) {
                                this.offsetX
                            } else {
                                0
                            }),
                            y: 0
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemFadeInLeft: ArrayType, indexFadeInLeft: Int64 => "${itemFadeInLeft.toString()}${indexFadeInLeft}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstFadeInLeft: UInt32 => AppLog.info(firstFadeInLeft.toString())
            })
            .width(100.percent)
    }
}
