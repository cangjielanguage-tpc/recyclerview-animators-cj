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
class FadeInUpAnimator {
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
    var offsetY: Int64 = 30;
    @State
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexFadeInUp: Int64, value: String => this.addValue(indexFadeInUp, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexFadeInUp: Int64 => this.deleteValue(indexFadeInUp);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexFadeInUp: Int64, value: String) {
        if (0 > indexFadeInUp) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        this.offsetY = 30
        this
            .myArr
            .insert(indexFadeInUp, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.offsetY = 0
                this.myArr[indexFadeInUp] = newArr

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxFadeInUp in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxFadeInUp]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexFadeInUp: Int64) {
        if (0 > indexFadeInUp) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexFadeInUp >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexFadeInUp].isNewValue, value: this.myArr[indexFadeInUp].value)
        currentData.isNewValue = true
        this.trans = 1
        this.offsetY = 0
        this.duration = 0
        this.myArr[indexFadeInUp] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.trans = 0
                this.offsetY = 30
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexFadeInUp] = currentData

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this.offsetY = 0
                        this
                            .myArr
                            .remove(indexFadeInUp)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemFadeInUp: ArrayType, indexFadeInUp: Int64 => GridItem() {
                        child(itemFadeInUp.value)
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
                        .opacity(if (itemFadeInUp.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .offset(
                            y: (if (itemFadeInUp.isNewValue) {
                                this.offsetY
                            } else {
                                0
                            }),
                            x: 0
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemFadeInUp: ArrayType, indexFadeInUp: Int64 => "${itemFadeInUp.toString()}${indexFadeInUp}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstFadeInUp: UInt32 => AppLog.info(firstFadeInUp.toString())
            })
            .width(100.percent)
    }
}
