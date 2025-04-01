/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package recyclerview

import std.collection.*
import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*
import std.time.*
import std.sync.*
import ohos.hilog.Hilog

@Component
class SlideInUpAnimator {
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
    @State
    var y: Length = 0.percent;
    @Link
    var columnsNum: Int64 = 1;
    var colNumStr: String = '';
    var indexX: Int64 = -1;

    protected override func aboutToAppear() {
//        Hilog.info(0x0000, "recycler123", "aboutToAppear1")
        this.controller.addValueCallback = {
            index: Int64, value: String =>
//            Hilog.info(0x0000, "recycler123", "112233")
            this.addValue(index, value);
        }
//        Hilog.info(0x0000, "recycler123", "aboutToAppear2")

        this.controller.deleteValueCallback = {
            index: Int64 => this.deleteValue(index);
        }

//        Hilog.info(0x0000, "recycler123", "aboutToAppear3")
//        Hilog.info(0x0000, "recycler123", "this.array.size:${this.array.size}")
        for (idx in 0..this.array.size) {
            Hilog.info(0x0000, "recycler123", "this.array:${this.array[idx]}")
            let newArr = ArrayType(false, this.array[idx])
            this.myArr.append(newArr)
        }
//        Hilog.info(0x0000, "recycler123", "aboutToAppear4")
        for (i in 0..this.columnsNum) {
            this.colNumStr += '1fr '
        }
//        Hilog.info(0x0000, "recycler123", "aboutToAppear5")
    }

    public func addValue(index: Int64, value: String) {
        if (0 > index) {
        	return
        }
        indexX = index
//        Hilog.info(0x0000, "recycler123", "1111111111")
        Hilog.info(0x0000, "recycler123", "value:${value}")
        if (!this.isClick) {
//            Hilog.info(0x0000, "recycler123", "1111133333")
            return
        }
        this.isClick = false
        let newArr = ArrayType(true, value);
        this.trans = 1
        this.duration = 0
        this.x = (0).percent
        this.y = (100).percent
//        Hilog.info(0x0000, "recycler123", "${index}")
//        Hilog.info(0x0000, "recycler123", "1111122222")
        //        this.myArr.append(newArr)
        for (idx in 0..this.myArr.size) {
            Hilog.info(0x0000, "recycler123", "this.myArrXXX:${this.myArr[idx].value}")
        }
        this.myArr.insert(index, newArr)
        for (idx in 0..this.myArr.size) {
            Hilog.info(0x0000, "recycler123", "this.myArrYYY:${this.myArr[idx].value}")
        }

//        Hilog.info(0x0000, "recycler123", "${myArr.size}")

        Timer.once(200 * Duration.millisecond) {
            => spawn (Main) {
                let newArr = ArrayType(true, value)
                this.trans = 1
                this.duration = this.controller.duration
                this.x = 0.percent
                this.y = 0.percent
                this.myArr[index] = newArr

                for (idx in 0..this.myArr.size) {
                    Hilog.info(0x0000, "recycler123", "this.myArr1:${this.myArr[idx].value}")
                }

                Timer.once(Int64(this.controller.duration) * Duration.millisecond) {
                    => spawn (Main) {
                        for (idx in 0..this.myArr.size) {
                            this.myArr[idx].isNewValue = false
                        }
                        this.isClick = true
                        for (idx in 0..this.myArr.size) {
                            Hilog.info(0x0000, "recycler123", "this.myArr2:${this.myArr[idx].value}")
                        }
                    }
                }
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
        if (index >= this.myArr.size) {
            return
        }
        this.isClick = false
        let currentData = this.myArr[index]
        currentData.isNewValue = true

        this.x = 0.percent
        this.y = 0.percent
        this.trans = 1
        this.duration = 0
        this.myArr[index] = currentData

        Timer.once(200 * Duration.millisecond) {
            => spawn (Main) {
                this.x = 0.percent
                this.y = (100).percent
                this.duration = this.controller.duration

                this.myArr[index] = currentData
            }
        }
        Timer.once(Int64(this.controller.duration + 200) * Duration.millisecond) {
            => spawn (Main) {
                this.myArr.remove(index)
                this.isClick = true
            }
        }
    }

    func asda():Int64 {
        for (idx in 0..this.myArr.size) {
            Hilog.info(0x0000, "recycler123", "this.myArr2:${this.myArr[idx].value}")
        }
        return 1
    }

    func childValue(index: Int64, value: String):String {
        if (index >= 0) {
        	return this.myArr[indexX].value
        }
        return value
    }

    func asddsw1():ObservedArrayList<ArrayType> {
        for (idx in 0..this.myArr.size) {
            Hilog.info(0x0000, "recycler123", "this.myArr4:${this.myArr[idx].value}")
        }
        return this.myArr
    }

    func build() {
        Grid {
            ForEach(
                asddsw1(),
//                this.myArr,
                {
                    item: ArrayType, _: Int64 => GridItem() {
                        child(childValue(indexX, item.value))
                    }
                        .opacity(if (item.isNewValue) {
                            this.trans
                        } else {
                            asda()
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
                            x: (if (item.isNewValue) {
                                this.x
                            } else {
                                0.vp
                            }),
                            y: (if (item.isNewValue) {
                                this.y
                            } else {
                                0.vp
                            })
                        )
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
