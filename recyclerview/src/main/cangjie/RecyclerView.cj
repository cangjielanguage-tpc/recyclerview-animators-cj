/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package recyclerview

import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Component
public class RecyclerView {
    @State
    var array: ObservedArrayList<String> = ObservedArrayList<String>();
    @Link
    var controller: Controller = Controller();
    @Link
    var columnsNum: Int64 = 1;
    @BuilderParam
    var child: (String) -> Unit

    func build() {
        if (this.controller.adapterAnimation != AdapterAnimationType.Default) {
            if (this.controller.adapterAnimation == AdapterAnimationType.AlphaIn) {
                AlphaInAnimationAdapter(
                    array: this.array,
                    controller: this.controller,
                    child: this.child
                )
            } else if (this.controller.adapterAnimation == AdapterAnimationType.ScaleIn) {
                ScaleInAnimationAdapter(
                    array: this.array,
                    controller: this.controller,
                    child: this.child
                )
            } else if (this.controller.adapterAnimation == AdapterAnimationType.SlideInBottom) {
                SlideInBottomAnimationAdapter(
                    array: this.array,
                    controller: this.controller,
                    child: this.child
                )
            } else if (this.controller.adapterAnimation == AdapterAnimationType.SlideInLeft) {
                SlideInLeftAnimationAdapter(
                    array: this.array,
                    controller: this.controller,
                    child: this.child
                )
            } else if (this.controller.adapterAnimation == AdapterAnimationType.SlideInRight) {
                SlideInRightAnimationAdapter(
                    array: this.array,
                    controller: this.controller,
                    child: this.child
                )
            }
        } else {
            if (this.controller.itemAnimation == ItemAnimationType.FadeIn) {
                FadeInAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.FadeInDown) {
                FadeInDownAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.FadeInUp) {
                FadeInUpAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.FadeInLeft) {
                FadeInLeftAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.FadeInRight) {
                FadeInRightAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.Landing) {
                LandingAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.ScaleIn) {
                ScaleInAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.ScaleInLeft) {
                ScaleInLeftAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.ScaleInRight) {
                ScaleInRightAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.ScaleInTop) {
                ScaleInTopAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.ScaleInBottom) {
                ScaleInBottomAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.SlideInLeft) {
                SlideInLeftAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.SlideInRight) {
                SlideInRightAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.SlideInUp) {
                SlideInUpAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.SlideInDown) {
                SlideInDownAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.OvershootInLeft) {
                OvershootInLeftAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            } else if (this.controller.itemAnimation == ItemAnimationType.OvershootInRight) {
                OvershootInRightAnimator(
                    array: this.array,
                    controller: this.controller,
                    columnsNum: this.columnsNum,
                    child: this.child
                )
            }
        }
    }
}

public enum ItemAnimationType <: Hashable & Equatable<ItemAnimationType> & ToString {
    // 淡入
    | FadeIn
    // 从上往下淡入
    | FadeInDown
    // 从下往上淡入
    | FadeInUp
    // 从左往右淡入
    | FadeInLeft
    // 从右往左淡入
    | FadeInRight
    // 整体向内收缩
    | Landing
    // 从中间伸展
    | ScaleIn
    // 从左侧伸展
    | ScaleInLeft
    // 从右侧伸展
    | ScaleInRight
    // 从顶部伸展
    | ScaleInTop
    // 从底部伸展
    | ScaleInBottom
    // 从左侧平移进入
    | SlideInLeft
    // 从右侧平移进入
    | SlideInRight
    // 从下侧平移进入
    | SlideInUp
    // 从上侧平移进入
    | SlideInDown
    // 从左侧平移进入 弹性
    | OvershootInLeft
    // 从右侧平移进入 弹性
    | OvershootInRight
    // 无
    | Default

    /**
     * 获取hashCode
     *
     * @return hashCode
     */
    public override func hashCode(): Int64 {
        return toString().hashCode()
    }

    /**
     * 判断两个枚举是否相等
     *
     * @param that 其他枚举
     * @return 是否相等
     */
    public operator func ==(that: ItemAnimationType): Bool {
        return this.toString() == that.toString()
    }

    /**
     * 判断两个枚举是否不相等
     *
     * @param that 其他枚举
     * @return 是否不相等
     */
    public operator func !=(that: ItemAnimationType): Bool {
        return !(this == that)
    }

    /**
     * 获取toString
     *
     * @return toString
     */
    public override func toString(): String {
        match (this) {
            case FadeIn => "FadeIn"
            case FadeInDown => "FadeInDown"
            case FadeInUp => "FadeInUp"
            case FadeInLeft => "FadeInLeft"
            case FadeInRight => "FadeInRight"
            case Landing => "Landing"
            case ScaleIn => "ScaleIn"
            case ScaleInLeft => "ScaleInLeft"
            case ScaleInRight => "ScaleInRight"
            case ScaleInTop => "ScaleInTop"
            case ScaleInBottom => "ScaleInBottom"
            case SlideInLeft => "SlideInLeft"
            case SlideInRight => "SlideInRight"
            case SlideInUp => "SlideInUp"
            case SlideInDown => "SlideInDown"
            case OvershootInLeft => "OvershootInLeft"
            case OvershootInRight => "OvershootInRight"
            case Default => ""
        }
    }
}

public enum AdapterAnimationType <: Hashable & Equatable<AdapterAnimationType> & ToString {
    // 淡入
    | AlphaIn
    // 从中间伸展
    | ScaleIn
    // 从下侧平移进入
    | SlideInBottom
    // 从左侧平移进入
    | SlideInLeft
    // 从右侧平移进入
    | SlideInRight
    | Default

    /**
     * 获取hashCode
     *
     * @return hashCode
     */
    public override func hashCode(): Int64 {
        return toString().hashCode()
    }

    /**
     * 判断两个枚举是否相等
     *
     * @param that 其他枚举
     * @return 是否相等
     */
    public operator func ==(that: AdapterAnimationType): Bool {
        return this.toString() == that.toString()
    }

    /**
     * 判断两个枚举是否不相等
     *
     * @param that 其他枚举
     * @return 是否不相等
     */
    public operator func !=(that: AdapterAnimationType): Bool {
        return !(this == that)
    }

    /**
     * 获取toString
     *
     * @return toString
     */
    public override func toString(): String {
        match (this) {
            case AlphaIn => "AlphaIn"
            case ScaleIn => "ScaleIn"
            case SlideInBottom => "SlideInBottom"
            case SlideInLeft => "SlideInLeft"
            case SlideInRight => "SlideInRight"
            case Default => ""
        }
    }
}

@Observed
public class Controller {
    public var addValueCallback: (index: Int64, value: String) -> Unit = {index, value => };
    public var deleteValueCallback: (index: Int64) -> Unit = {index =>};
    var duration: Int32 = 500;
    @Publish
    var itemAnimation: ItemAnimationType = ItemAnimationType.FadeIn
    @Publish
    var adapterAnimation: AdapterAnimationType = AdapterAnimationType.AlphaIn
    var isFirstOnly: Bool = false
    public var mWidth: Float64 = 480.0;
    public var mHeight: Float64 = 855.0;

    public func addValue(index: Int64, value: String): Unit {
        this.addValueCallback(index, value)
    }

    public func deleteValue(index: Int64): Unit {
        this.deleteValueCallback(index)
    }

    public func setDuration(duration: Int32): Unit {
        this.duration = duration
    }

    public func setItemAnimation(itemAnimation: ItemAnimationType): Unit {
        this.itemAnimation = itemAnimation
    }

    public func setAdapterAnimation(adapterAnimation: AdapterAnimationType): Unit {
        this.adapterAnimation = adapterAnimation
    }

    public func setFirstOnly(isFirstOnly: Bool): Unit {
        this.isFirstOnly = isFirstOnly
    }

    public func setMovingWidth(width: Float64): Controller {
        this.mWidth = width
        return this
    }

    public func setMovingHeight(height: Float64): Controller {
        this.mHeight = height
        return this
    }

    public func getItemAnimation(): ItemAnimationType {
        return this.itemAnimation
    }

    public func getAdapterAnimation(): AdapterAnimationType {
        return this.adapterAnimation
    }
}

public class ArrayType <: ToString {
    public var isNewValue: Bool
    public var value: String

    public init(isNewValue: Bool, value: String) {
        this.isNewValue = isNewValue
        this.value = value
    }

    public init(that: ArrayType) {
        this.isNewValue = that.isNewValue
        this.value = that.value
    }

    public override func toString():String {
        return value
    }
}

public class AnimationAdapterTypeData {
    public var animationAdapterKey: Float64
    public var value: String

    public init(animationAdapterKey: Float64, value: String) {
        this.animationAdapterKey = animationAdapterKey
        this.value = value
    }
}
