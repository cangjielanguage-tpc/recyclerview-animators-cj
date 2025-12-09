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
class SlideInRightAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    var isClick: Bool = true;
    @State
    var trans: Int64 = 0;
    @State
    var duration: Int32 = 0;
    @State
    var x: Length = 0.percent;
    @State
    var y: Length = 0.percent;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexSlideInRight: Int64, value: String => this.addValue(indexSlideInRight, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexSlideInRight: Int64 => this.deleteValue(indexSlideInRight);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexSlideInRight: Int64, value: String) {
        if (0 > indexSlideInRight) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 1
        this.duration = 0
        this.x = (100).percent
        this.y = (0).percent
        this
            .myArr
            .insert(indexSlideInRight, newArr)

        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.x = 0.percent
                this.y = 0.percent
                this.myArr[indexSlideInRight] = newArr

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxSlideInRight in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxSlideInRight]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexSlideInRight: Int64) {
        if (0 > indexSlideInRight) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexSlideInRight >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false

        let currentData = ArrayType(isNewValue: this.myArr[indexSlideInRight].isNewValue, value: this.myArr[indexSlideInRight].value)
        currentData.isNewValue = true

        this.x = 0.percent
        this.y = 0.percent
        this.trans = 1
        this.duration = 0

        this.myArr[indexSlideInRight] = currentData

        Timer.once(200 * Duration.millisecond) {
            this.x = (100).percent
            this.y = 0.percent
            this.trans = 1
            this.duration = this
                .controller
                .duration
            this.myArr[indexSlideInRight] = currentData
        }
        Timer.once(Int64(this
            .controller
            .duration + 100) * Duration.millisecond) {
            =>
                this.x = 0.percent
                this.y = 0.percent
                this
                    .myArr
                    .remove(indexSlideInRight)
                this.isClick = true
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemSlideInRight: ArrayType, indexSlideInRight: Int64 => GridItem() {
                        child(itemSlideInRight.value)
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
                        .opacity(if (itemSlideInRight.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .offset(
                            x: (if (itemSlideInRight.isNewValue) {
                                this.x
                            } else {
                                0.vp
                            }),
                            y: (if (itemSlideInRight.isNewValue) {
                                this.y
                            } else {
                                0.vp
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemSlideInRight: ArrayType, indexSlideInRight: Int64 => "${itemSlideInRight.toString()}${indexSlideInRight}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstSlideInRight: UInt32 => AppLog.info(firstSlideInRight.toString())
            })
            .width(100.percent)
    }
}
