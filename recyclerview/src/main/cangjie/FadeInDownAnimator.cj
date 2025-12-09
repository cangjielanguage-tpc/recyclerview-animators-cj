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
class FadeInDownAnimator {
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
    var offsetY: Int64 = -30;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexFadeInDown: Int64, value: String => addValue(indexFadeInDown, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexFadeInDown: Int64 => deleteValue(indexFadeInDown);
        }

        for (idx in 0..array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexFadeInDown: Int64, value: String) {
        if (0 > indexFadeInDown) {
            return
        }

        if (!this.isClick) {
            return
        }
        isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        offsetY = -30
        this
            .myArr
            .insert(indexFadeInDown, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                offsetY = 0
                this.myArr[indexFadeInDown] = newArr
                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idx in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idx]
                                .isNewValue = false
                        }
                        isClick = true
                }
        }
    }

    public func deleteValue(indexFadeInDown: Int64): Unit {
        if (0 > indexFadeInDown) {
            return
        }
        AppLog.info(" delete indexFadeInDown: " + indexFadeInDown.toString())
        if (!isClick) {
            return
        }
        if (indexFadeInDown >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: myArr[indexFadeInDown].isNewValue, value: this.myArr[indexFadeInDown].value)
        currentData.isNewValue = true
        duration = 0
        this.trans = 1
        this.offsetY = 0
        this.myArr[indexFadeInDown] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.trans = 0
                this.offsetY = -30
                this.duration = this
                    .controller
                    .duration
                myArr[indexFadeInDown] = currentData

                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this
                            .myArr
                            .remove(indexFadeInDown)
                        isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemFadeInDown: ArrayType, index0: Int64 => GridItem() {
                        child(itemFadeInDown.value)
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
                        .opacity(if (itemFadeInDown.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .offset(
                            x: 0,
                            y: (if (itemFadeInDown.isNewValue) {
                                offsetY
                            } else {
                                0
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemFadeInDown: ArrayType, indexFadeInDown: Int64 => "${itemFadeInDown.toString()}${indexFadeInDown}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstFadeInDown: UInt32 => AppLog.info(firstFadeInDown.toString())
            })
            .width(100.percent)
    }
}
