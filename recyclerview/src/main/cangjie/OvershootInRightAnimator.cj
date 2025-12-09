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
class OvershootInRightAnimator {
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
    var x: Length = 0.percent;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = ''
    @State
    var y: Length = 0.percent;

    protected override func aboutToAppear() {
        this
            .controller
            .addValueCallback = {
            indexOvershootInRight: Int64, value: String => this.addValue(indexOvershootInRight, value);
        }

        this
            .controller
            .deleteValueCallback = {
            indexOvershootInRight: Int64 => this.deleteValue(indexOvershootInRight);
        }

        for (idx in 0..this.array.size) {
            let newArr = ArrayType(isNewValue: false, value: this.array[idx]);
            this.myArr.append(newArr);
        }
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
    }

    func addValue(indexOvershootInRight: Int64, value: String) {
        if (0 > indexOvershootInRight) {
            return
        }
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(isNewValue: true, value: value);
        this.trans = 0;
        this.duration = 0
        this.x = 100.percent
        this.y = 0.percent
        this
            .myArr
            .insert(indexOvershootInRight, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(isNewValue: true, value: value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.x = (-5).percent
                this.y = 0.percent
                this.myArr[indexOvershootInRight] = newArr

                Timer.once(Int64(this
                    .controller
                    .duration + 50) * Duration.millisecond) {
                    =>
                        this.duration = 50
                        this.x = 0.percent;
                }

                Timer.once(Int64(this
                    .controller
                    .duration) * Duration.millisecond) {
                    =>
                        for (idx in 0..this
                                .myArr
                                .size) {
                            this
                                .myArr[idx]
                                .isNewValue = false;
                        }
                        this.isClick = true
                }
        }
    }

    func deleteValue(indexOvershootInRight: Int64) {
        if (0 > indexOvershootInRight) {
            return
        }
        if (!this.isClick) {
            return
        }
        if (indexOvershootInRight >= this
            .myArr
            .size) {
            return
        }
        this.isClick = false
        let currentData = ArrayType(isNewValue: this.myArr[indexOvershootInRight].isNewValue, value: this.myArr[indexOvershootInRight].value)
        currentData.isNewValue = true

        this.x = (-5).percent
        this.y = 0.percent
        this.trans = 1
        this.duration = 0
        this.myArr[indexOvershootInRight] = currentData

        Timer.once(100 * Duration.millisecond) {
            =>
                this.x = 100.percent
                this.y = 0.percent
                this.trans = 0
                this.duration = this
                    .controller
                    .duration;
                Timer.once(Int64(this
                    .controller
                    .duration + 100) * Duration.millisecond) {
                    =>
                        this.duration = 0
                        this.x = 0.percent;
                        this.y = 0.percent
                        this
                            .myArr
                            .remove(indexOvershootInRight)
                        this.isClick = true
                }
        }
    }

    func build() {
        Grid {
            ForEach(
                this.myArr,
                itemGeneratorFunc: {
                    item: ArrayType, indexOvershootInRight: Int64 => GridItem() {
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
                            this.trans;
                        } else {
                            1
                        })
                        .offset(
                            x: (if (item.isNewValue) {
                                this.x;
                            } else {
                                0.vp;
                            }),
                            y: (if (item.isNewValue) {
                                this.y
                            } else {
                                0.vp
                            }),
                        )
                        .animationEnd()
                },
                keyGeneratorFunc: {item: ArrayType, indexOvershootInRight: Int64 => "${item.toString()}${indexOvershootInRight}"}
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
