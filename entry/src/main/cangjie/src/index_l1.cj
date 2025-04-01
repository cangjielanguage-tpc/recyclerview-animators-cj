package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*

@Entry
@Component
class Index_L1 {
    let arr_L1 = Array<String>([
            "Test_RecycleRview_11",
            "Test_RecycleRview_12",//D
            "Test_RecycleRview_13",//D
            "Test_RecycleRview_14",//D
            "Test_RecycleRview_15",//D
            "Test_RecycleRview_16",
            "Test_RecycleRview_Default_11",
            "Test_RecycleRview_Default_12",//D
            "Test_RecycleRview_FadeIn_11",
            "Test_RecycleRview_FadeIn_12",
            "Test_RecycleRview_FadeIn_13",
            "Test_RecycleRview_FadeInDown_11",
            "Test_RecycleRview_FadeInDown_12",
            "Test_RecycleRview_FadeInDown_13",
            "Test_RecycleRview_FadeInDown_14",
            "Test_RecycleRview_FadeInDown_15",
            "Test_RecycleRview_FadeInLeft_11",
            "Test_RecycleRview_FadeInLeft_12",//D
            "Test_RecycleRview_FadeInLeft_13",
            "Test_RecycleRview_FadeInRight_11",
            "Test_RecycleRview_FadeInRight_12",
            "Test_RecycleRview_FadeInRight_13",
            "Test_RecycleRview_FadeInUp_11",
            "Test_RecycleRview_FadeInUp_12",
            "Test_RecycleRview_FadeInUp_13",//D
            "Test_RecycleRview_Landing_11",
            "Test_RecycleRview_Landing_12",//D
            "Test_RecycleRview_Landing_13",
            "Test_RecycleRview_OvershootInLeft_11",
            "Test_RecycleRview_OvershootInLeft_12",
            "Test_RecycleRview_OvershootInLeft_13",
            "Test_RecycleRview_OvershootInRight_11",
            "Test_RecycleRview_OvershootInRight_12",//D
            "Test_RecycleRview_OvershootInRight_13",//D
            "Test_RecycleRview_ScaleIn_11",
            "Test_RecycleRview_ScaleIn_12",
            "Test_RecycleRview_ScaleIn_13",
            "Test_RecycleRview_ScaleInBottom_11",
            "Test_RecycleRview_ScaleInBottom_12",
            "Test_RecycleRview_ScaleInBottom_13",
            "Test_RecycleRview_ScaleInLeft_11",
            "Test_RecycleRview_ScaleInLeft_12",
            "Test_RecycleRview_ScaleInLeft_13",
            "Test_RecycleRview_ScaleInRight_11",
            "Test_RecycleRview_ScaleInRight_12",
            "Test_RecycleRview_ScaleInRight_13",
            "Test_RecycleRview_ScaleInTop_11",
            "Test_RecycleRview_ScaleInTop_12",
            "Test_RecycleRview_ScaleInTop_13",
            "Test_RecycleRview_SetDuration_11",
            "Test_RecycleRview_SetFirstOnly_11",
            "Test_RecycleRview_SetHeight_11",
            "Test_RecycleRview_SetWidth_11",
            "Test_RecycleRview_SetWidth_12",
            "Test_RecycleRview_SlideInDown_11",
            "Test_RecycleRview_SlideInDown_12",
            "Test_RecycleRview_SlideInDown_13",//D
            "Test_RecycleRview_SlideInLeft_11",
            "Test_RecycleRview_SlideInLeft_12",
            "Test_RecycleRview_SlideInLeft_13",
            "Test_RecycleRview_SlideInRight_11",
            "Test_RecycleRview_SlideInRight_12",
            "Test_RecycleRview_SlideInRight_13",
            "Test_RecycleRview_SlideInUp_11",
            "Test_RecycleRview_SlideInUp_12",
            "Test_RecycleRview_SlideInUp_13"
        ])


    func build() {
            Scroll(Scroller()){
                Column {
                    Text("-- recyclerview-animators-cj-L1-用例 --").height(80)
                    Divider().color(0x000000).strokeWidth(1).margin(top: 10, bottom: 10)

                    ForEach(arr_L1, itemGeneratorFunc: {item: String, _: Int64 =>
                          Button(item).height(40).margin(top: 5, bottom: 5).fontSize(16)
                            .shape(ShapeType.Capsule).width(95.percent)
                            .stateEffect(true).id(item)
                          .onClick {
                            Router.push(url: item)
                        }
                    })

            }.width(100.percent)
        }
    }

}