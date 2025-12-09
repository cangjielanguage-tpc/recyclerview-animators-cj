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
class FadeInRightAnimator {
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
    var offsetX: Int64 = 50;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexFadeInRight: Int64, value: String => this.addValue(indexFadeInRight, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexFadeInRight: Int64 => this.deleteValue(indexFadeInRight);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexFadeInRight: Int64, value: String) {
        if (0 > indexFadeInRight) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        this.offsetX = 50
        this
            .myArr
            .insert(indexFadeInRight, newArr)

        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.offsetX = 0
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexFadeInRight] = newArr

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxFadeInRight in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxFadeInRight]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexFadeInRight: Int64) {
        if (0 > indexFadeInRight) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexFadeInRight >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexFadeInRight].isNewValue, value: this.myArr[indexFadeInRight].value)
        currentData.isNewValue = true
        this.trans = 1
        this.duration = 0
        this.offsetX = 0
        this.myArr[indexFadeInRight] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.trans = 0
                this.offsetX = 50
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexFadeInRight] = currentData

                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this
                            .myArr
                            .remove(indexFadeInRight)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid() {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemFadeInRight: ArrayType, indexFadeInRight: Int64 => GridItem() {
                        child(itemFadeInRight.value)
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
                        .opacity(if (itemFadeInRight.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .offset(
                            x: (if (itemFadeInRight.isNewValue) {
                                this.offsetX
                            } else {
                                0
                            }),
                            y: 0
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemFadeInRight: ArrayType, indexFadeInRight: Int64 => "${itemFadeInRight.toString()}${indexFadeInRight}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstFadeInRight: UInt32 => AppLog.info(firstFadeInRight.toString())
            })
            .width(100.percent)
    }
}
