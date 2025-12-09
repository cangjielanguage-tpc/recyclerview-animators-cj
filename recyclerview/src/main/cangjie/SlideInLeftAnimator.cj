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
class SlideInLeftAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var duration: Int32 = 0;
    var isClick: Bool = true;
    @State
    var trans: Int64 = 0;
    @State
    var x: Length = 0.percent
    @State
    var y: Length = 0.percent;
    @Link
    var columnsNum: Int64 = 1;
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexSlideInLeft: Int64, value: String => this.addValue(indexSlideInLeft, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexSlideInLeft: Int64 => this.deleteValue(indexSlideInLeft);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexSlideInLeft: Int64, value: String) {
        if (0 > indexSlideInLeft) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 1
        this.duration = 0
        this.x = (-100).percent
        this.y = (0).percent
        this
            .myArr
            .insert(indexSlideInLeft, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.x = 0.percent
                this.y = 0.percent
                this.myArr[indexSlideInLeft] = newArr

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxSlideInLeft in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxSlideInLeft]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexSlideInLeft: Int64) {
        if (0 > indexSlideInLeft) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexSlideInLeft >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexSlideInLeft].isNewValue, value: this.myArr[indexSlideInLeft].value)
        currentData.isNewValue = true

        this.x = 0.percent
        this.y = 0.percent
        this.trans = 1
        this.duration = 0
        this.myArr[indexSlideInLeft] = currentData

        Timer.once(200 * Duration.millisecond) {
            this.x = (-100).percent
            this.y = 0.percent
            this.trans = 1
            this.duration = this
                .controller
                .duration
            this.myArr[indexSlideInLeft] = currentData
        }
        Timer.once(Int64(this
            .controller
            .duration + 100) * Duration.millisecond) {
            =>
                this.x = 0.percent
                this.y = 0.percent
                this
                    .myArr
                    .remove(indexSlideInLeft)
                this.isClick = true
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemSlideInLeft: ArrayType, indexSlideInLeft: Int64 => GridItem() {
                        child(itemSlideInLeft.value)
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
                        .opacity(if (itemSlideInLeft.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .offset(
                            x: (if (itemSlideInLeft.isNewValue) {
                                this.x
                            } else {
                                0.vp
                            }),
                            y: (if (itemSlideInLeft.isNewValue) {
                                this.y
                            } else {
                                0.vp
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemSlideInLeft: ArrayType, indexSlideInLeft: Int64 => "${itemSlideInLeft.toString()}${indexSlideInLeft}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstSlideInLeft: UInt32 => AppLog.info(firstSlideInLeft.toString())
            })
            .width(100.percent)
    }
}
