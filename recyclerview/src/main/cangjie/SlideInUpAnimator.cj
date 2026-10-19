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
class SlideInUpAnimator {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @State
    var myArr: ObservedArrayList<ArrayType> = ObservedArrayList<ArrayType>();
    @State
    var duration: Int32 = 0;
    var isClick: Bool = true;
    @State
    var trans: Int64 = 0;
    @Link
    var controller: Controller = Controller();
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
            indexSlideInUp: Int64, value: String => this.addValue(indexSlideInUp, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexSlideInUp: Int64 => this.deleteValue(indexSlideInUp);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr)
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    public func addValue(indexSlideInUp: Int64, value: String): Unit {
        if (0 > indexSlideInUp) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 1
        this.duration = 0
        this.x = (0).percent
        this.y = (100).percent
        this
            .myArr
            .insert(indexSlideInUp, newArr)
        MainTimer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.x = 0.percent
                this.y = 0.percent
                this.myArr[indexSlideInUp] = newArr

                MainTimer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idxSlideInUp in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idxSlideInUp]
                                .isNewValue = false
                        }
                        this.isClick = true
                }
        }
    }

    public func deleteValue(indexSlideInUp: Int64): Unit {
        if (0 > indexSlideInUp) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexSlideInUp >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexSlideInUp].isNewValue, value: this.myArr[indexSlideInUp].value)
        currentData.isNewValue = true

        this.x = 0.percent
        this.y = 0.percent
        this.trans = 1
        this.duration = 0
        this.myArr[indexSlideInUp] = currentData

        MainTimer.once(200 * Duration.millisecond) {
            =>
                this.x = 0.percent
                this.y = (100).percent
                this.duration = this
                    .controller
                    .duration

                this.myArr[indexSlideInUp] = currentData
        }
        MainTimer.once(Int64(this
            .controller
            .duration + 200) * Duration.millisecond) {
            =>
                this
                    .myArr
                    .remove(indexSlideInUp)
                this.isClick = true
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    itemSlideInUp: ArrayType, indexSlideInUp: Int64 => GridItem() {
                        child(itemSlideInUp.value)
                    }
                        .opacity(if (itemSlideInUp.isNewValue) {
                            this.trans
                        } else {
                            1
                        })
                        .animationStart(
                            AnimateParam(
                                duration: this.duration,
                                curve: Curve.Ease,
                                delay: 50, // 动画延迟
                                iterations: 1, // 播放次数
                                playMode: PlayMode.Normal
                            )
                        )
                        .offset(
                            x: (if (itemSlideInUp.isNewValue) {
                                this.x
                            } else {
                                0.vp
                            }),
                            y: (if (itemSlideInUp.isNewValue) {
                                this.y
                            } else {
                                0.vp
                            })
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {itemSlideInUp: ArrayType, indexSlideInUp: Int64 => "${itemSlideInUp.toString()}${indexSlideInUp}"}
            )
        }
            .columnsTemplate(this.colNumStr)
            .columnsGap(2)
            .rowsGap(2)
            .onScrollIndex({
                firstSlideInUp: UInt32 => AppLog.info(firstSlideInUp.toString())
            })
            .width(100.percent)
    }
}
