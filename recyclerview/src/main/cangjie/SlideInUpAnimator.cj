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
        if (!this.isClick) {
            return
        }
        this.isClick = false
        let newArr = ArrayType(true, value);
        this.trans = 1
        this.duration = 0
        this.x = (0).percent
        this.y = (100).percent
        this
            .myArr
            .insert(index, newArr)
        Timer.once(200 * Duration.millisecond) {
            =>
                let newArr = ArrayType(true, value)
                this.trans = 1
                this.duration = this
                    .controller
                    .duration
                this.x = 0.percent
                this.y = 0.percent
                this.myArr[index] = newArr

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
        if (!this.isClick) {
            return
        }
        if (index >= this
            .myArr
            .size) {
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
            =>
                this.x = 0.percent
                this.y = (100).percent
                this.duration = this
                    .controller
                    .duration

                this.myArr[index] = currentData
        }
        Timer.once(Int64(this
            .controller
            .duration + 200) * Duration.millisecond) {
            =>
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
                    item: ArrayType, _: Int64 => GridItem() {
                        child(item.value)
                    }
                        .opacity(if (item.isNewValue) {
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
