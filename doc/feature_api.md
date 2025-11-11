# recyclerview-animators-cj 特性文档

## 介绍

recyclerview-animators-cj 是一个带有添加删除动画效果以及整体动画效果的list组件库

### class RecyclerView

RecyclerView预览自定义控件

```cangjie
/**
 * RecyclerView预览自定义控件
 */
@Component
public class RecyclerView {
    /**
    * 初始化RecyclerView自定义控件
    *
    * @param model 传入recyclerview配置内容
    */
    RecyclerView(
        array!: ObservedArrayList<String>, 
        controller!: Controller,  // 
        columnsNum!: Int64, // 列数，仅在Controller设置itemAnimationType不为Default，adapterAnimationType为Default时生效 
        child!: ObservedProperty<(Class-CustomView)> // Builder函数
    )
}
```

array 传入字符串标识数组，可通过child中传入的@Builder函数控制具体展示内容<br>
Controller 见 “Controller配置”<br>
columnsNum:列数，仅在Controller设置itemAnimationType不为Default，adapterAnimationType为Default时生效<br>
child：设置每个子组件中具体展示的内容<br>

## UI配置接口

### class Controller

Controller配置

```cangjie
/**
 * 控制器类，用于配置RecyclerView的行为和动画效果
 */
@Observed
public class Controller {
    /**
     * 设置动画持续时间
     *
     * @param duration 持续时间
     */
    public func setDuration(duration: Int32)

    /**
     * 设置条目动画类型
     *
     * @param itemAnimation 动画类型
     */
    public func setItemAnimation(itemAnimation: ItemAnimationType)

    /**
     * 设置适配器动画类型
     *
     * @param adapterAnimation 动画类型
     */
    public func setAdapterAnimation(adapterAnimation: AdapterAnimationType)

    /**
     * 设置是否仅首次执行动画
     *
     * @param isFirstOnly 是否仅首次执行
     */
    public func setFirstOnly(isFirstOnly: Bool)

    /**
     * 设置x轴偏移宽度
     *
     * @param width 宽度
     * @return Controller对象
     */
    public func setMovingWidth(width: Float64): Controller

    /**
     * 设置y轴偏移高度
     *
     * @param height 高度
     * @return Controller对象
     */
    public func setMovingHeight(height: Float64): Controller

    /**
     * 获取条目动画类型
     *
     * @return 条目动画类型
     */
    public func getItemAnimation(): ItemAnimationType

    /**
     * 获取适配器动画类型
     *
     * @return 适配器动画类型
     */
    public func getAdapterAnimation(): AdapterAnimationType
}
```

```cangjie
/**
 * 条目动画类型
 */
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
}
```

### enum AdapterAnimationType
AdapterAnimationType枚举定义了适配器动画的类型。

```cangjie
/**
 * 适配器动画类型
 */
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
}
```