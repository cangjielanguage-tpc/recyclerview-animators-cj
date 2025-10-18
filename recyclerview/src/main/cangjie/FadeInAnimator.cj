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
        this
            .controller
            .addValueCallback = {
            index: Int64, value: String => this.addValue(index, value);
        }

        this
            .controller
            .deleteValueCallback = {
            index: Int64 => this.deleteValue(index);
        }

        for (idx in 0..this
                .array
                .size) {
            let newArr = ArrayType(false, this.array[idx]);
            this
                .myArr
                .append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    public func addValue(index: Int64, value: String) {
        if (0 > index) {
            return
        }
        AppLog.info("FadeInAnimator add index: " + index.toString() + ", value:" + value)
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(true, value);
        this.trans = 0
        this.duration = 0
        this
            .myArr
            .insert(index, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr2 = ArrayType(true, value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.myArr[index] = newArr2

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
                        this.isClick = true
                }
        }
    }

    public func deleteValue(index: Int64) {
        if (0 > index) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (index >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(this.myArr[index])
        currentData.isNewValue = true
        this.duration = 0
        this.trans = 0
        this.duration = this
            .controller
            .duration
        this.myArr[index] = currentData

        Timer.once(Int64(this
            .controller
            .duration) * Duration.millisecond) {
            =>
                this.duration = 0
                this
                    .myArr
                    .remove(index)
                this.isClick = true
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                {
                    item: ArrayType, index: Int64 => GridItem() {
                        child(item.value)
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
                        .opacity(if (item.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .animationEnd()
                }
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
