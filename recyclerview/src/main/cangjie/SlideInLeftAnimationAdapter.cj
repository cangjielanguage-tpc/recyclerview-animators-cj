/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package recyclerview

import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*

@Component
class SlideInLeftAnimationAdapter {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var list: ObservedArrayList<AnimationAdapterTypeData> = ObservedArrayList<AnimationAdapterTypeData>();
    @State
    var end: Int32 = 0;
    @State
    var animateList: ObservedArrayList<AnimationAdapterTypeData> = ObservedArrayList<AnimationAdapterTypeData>();
    @State
    var start: Int32 = 0;

    protected override func aboutToAppear() {
        for (idx in 0..array.size) {
            let temp = AnimationAdapterTypeData(-this.controller.mWidth, this.array[idx]);
            this.list.append(temp)
            this.animateList.append(temp)
        }
    }

    func build() {
        List {
            ForEach(
                this.list,
                {
                    item: AnimationAdapterTypeData, index: Int64 => ListItem() {
                        child(item.value)
                    }
                    .width(100.percent)
                    .animationStart(
                        AnimateParam(
                            duration: this.controller.duration,
                            curve: Curve.Ease,
                            delay: 50, // 动画延迟
                            iterations: 1, // 播放次数
                            playMode: PlayMode.Normal
                        )
                    ).translate(x: this.animateList[index].animationAdapterKey)
                    .animationEnd()
                }
            )
        }.width(100.percent).onScrollIndex(
            {
                start: Int32, end1: Int32 =>
                this.start = start
                this.end = end1
                for (index in 0..animateList.size) {
                    var item = animateList[index]
                    if (index >= Int64(start) && index <= Int64(end1)) {
                        let temp = AnimationAdapterTypeData(0.0, item.value);
                        this.animateList[index] = temp
                    } else {
                        if (!this.controller.isFirstOnly) {
                            let temp = AnimationAdapterTypeData(-this.controller.mWidth, item.value);
                            this.animateList[index] = temp
                        }
                    }
                }
            }
        )
    }
}
