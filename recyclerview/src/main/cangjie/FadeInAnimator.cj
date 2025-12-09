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
class FadeInAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>()
    @State
    var duration: Int32 = 0;
    var isClick: Bool = true;
    @State
    var trans: Int64 = 0;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        controller
            .addValueCallback = {
            indexFadeIn: Int64, value: String => this.addValue(indexFadeIn, value);
        }

        controller
            .deleteValueCallback = {
            indexFadeIn: Int64 => this.deleteValue(indexFadeIn);
        }

        for (idx in 0..array.size) {
            let newArr = ArrayType(isNewValue: false, value: array[idx]);
            myArr.append(newArr)
        }

        for (i in 0..columnsNum) {
            colNumStr += '1fr '
        }
    }

    public func addValue(indexFadeIn: Int64, value: String): Unit {

        if (0 > indexFadeIn) {
            return
        }
        AppLog.info("FadeInAnimator add indexFadeIn: " + indexFadeIn.toString() + ", value:" + value)
        if (!isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        this
            .myArr
            .insert(indexFadeIn, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr2 = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.myArr[indexFadeIn] = newArr2

                Timer.once(Int64(controller.duration) * Duration.millisecond) {
                    =>
                        for (idxFadeIn in 0..myArr.size) {
                            myArr[idxFadeIn].isNewValue = false
                        }
                        isClick = true
                }
        }
    }

    public func deleteValue(indexFadeIn: Int64): Unit {
        if (0 > indexFadeIn) {
            return
        }

        if (!isClick) {
            return
        }
        if (indexFadeIn >= myArr.size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexFadeIn].isNewValue, value: this.myArr[indexFadeIn].value)
        currentData.isNewValue = true
        this.duration = 0
        trans = 1
        this.duration = this
            .controller
            .duration
        this.myArr[indexFadeIn] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.trans = 0
                this.duration = this
                    .controller
                    .duration
                myArr[indexFadeIn] = currentData

                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this
                            .myArr
                            .remove(indexFadeIn)
                        isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                myArr,
                itemGeneratorFunc: {
                    itemFadeIn: ArrayType, indexFadeIn: Int64 => GridItem {
                        child(itemFadeIn.value)
                    }
                        .animationStart(
                            AnimateParam(
                                duration: duration,
                                curve: Curve.Ease,
                                delay: 50, // 动画延迟
                                iterations: 1, // 播放次数
                                playMode: PlayMode.Normal
                            )
                        )
                        .opacity(if (itemFadeIn.isNewValue) {
                            trans
                        } else {
                            1
                        })
                        .animationEnd()
                },
                keyGeneratorFunc: {itemFadeIn: ArrayType, indexFadeIn: Int64 => "${itemFadeIn.toString()}${indexFadeIn}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstFadeIn: UInt32 => AppLog.info(firstFadeIn.toString())
            })
            .width(100.percent)
    }
}
