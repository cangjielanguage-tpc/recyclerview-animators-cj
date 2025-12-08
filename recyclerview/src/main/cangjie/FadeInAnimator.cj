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
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
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
            index: Int64, value: String => this.addValue(index, value);
        }

        controller
            .deleteValueCallback = {
            index: Int64 => this.deleteValue(index);
        }

        for (idx in 0..array.size) {
            let newArr = ArrayType(isNewValue: false, value: array[idx]);
            myArr.append(newArr)
        }

        for (i in 0..columnsNum) {
            colNumStr += '1fr '
        }
    }

    public func addValue(index: Int64, value: String): Unit {

        if (0 > index) {
            return
        }
        AppLog.info("FadeInAnimator add index: " + index.toString() + ", value:" + value)
        if (!isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0
        this.duration = 0
        this
            .myArr
            .insert(index, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr2 = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.myArr[index] = newArr2

                Timer.once(Int64(controller.duration) * Duration.millisecond) {
                    =>
                        for (idx in 0..myArr.size) {
                            myArr[idx].isNewValue = false
                        }
                        isClick = true
                }
        }
    }

    public func deleteValue(index: Int64): Unit {
        if (0 > index) {
            return
        }

        if (!isClick) {
            return
        }
        if (index >= myArr.size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[index].isNewValue, value: this.myArr[index].value)
        currentData.isNewValue = true
        this.duration = 0
        trans = 1
        this.duration = this
            .controller
            .duration
        this.myArr[index] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.trans = 0
                this.duration = this
                    .controller
                    .duration
                myArr[index] = currentData

                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this
                            .myArr
                            .remove(index)
                        isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                myArr,
                itemGeneratorFunc: {
                    item: ArrayType, index: Int64 => GridItem {
                        child(item.value)
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
                        .opacity(if (item.isNewValue) {
                            trans
                        } else {
                            1
                        })
                        .animationEnd()
                },
                keyGeneratorFunc: {item: ArrayType, index: Int64 => "${item.toString()}${index}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                first: UInt32 => AppLog.info(first.toString())
            })
            .width(100.percent)
    }
}
