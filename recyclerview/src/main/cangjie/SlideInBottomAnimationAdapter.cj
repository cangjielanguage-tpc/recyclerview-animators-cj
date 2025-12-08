/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package recyclerview

import ohos.component.*
import ohos.state_macro_manage.*
import ohos.state_manage.*

@Component
class SlideInBottomAnimationAdapter {
    @Link
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @BuilderParam
    var child: (String) -> Unit
    @Link
    var controller: Controller = Controller();
    @State
    var end: Int32 = 0;
    @State
    var list: ObservedArrayList<AnimationAdapterTypeData> = ObservedArrayList<AnimationAdapterTypeData>();
    @State
    var animateList: ObservedArrayList<AnimationAdapterTypeData> = ObservedArrayList<AnimationAdapterTypeData>();
    @State
    var start: Int32 = 0;

    protected override func aboutToAppear() {
        for (idx in 0..this.array.size) {
            let temp = AnimationAdapterTypeData(controller.mHeight, this.array[idx]);
            this.animateList.append(temp)
            list.append(temp)
        }
    }

    func build() {
        List {
            ForEach(
                list,
                {
                    item: AnimationAdapterTypeData, index1: Int64 => ListItem() {
                        child(item.value)
                    }.width(100.percent).animationStart(
                        AnimateParam(
                            duration: controller.duration,
                            curve: Curve.Ease,
                            delay: 50, // 动画延迟
                            iterations: 1, // 播放次数
                            playMode: PlayMode.Normal
                        )
                    ).translate(y: animateList[index1].animationAdapterKey)
                    .animationEnd()
                }
            )
        }.width(100.percent).onScrollIndex(
            {
                start: Int32, end: Int32 =>
                this.start = start
                this.end = end
                for (index in 0..animateList.size) {
                    var item = animateList[index]
                    if (index >= Int64(start) && index <= Int64(end)) {
                        let temp = AnimationAdapterTypeData(0.0, item.value);
                        animateList[index] = temp
                    } else {
                        if (!controller.isFirstOnly) {
                            let temp = AnimationAdapterTypeData(this.controller.mHeight, item.value);
                            this.animateList[index] = temp
                        }
                    }
                }
            }
        )
    }
}
