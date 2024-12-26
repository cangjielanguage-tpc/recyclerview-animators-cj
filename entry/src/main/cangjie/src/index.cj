package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*

@Entry
@Component
class EntryView {
    func build() {
        Row {
            Column {
                Button("ADAPTER SAMPLE PAGE").onClick({
                    e => Router.push(url: "IndexAdapterAnimator")
                }).margin(top: 50)
                Button("ITEM SAMPLE PAGE").onClick({
                    e => Router.push(url: "IndexItemAnimator")
                }).margin(top: 50)
            }.width(100.percent)
        }.width(100.percent)
    }
}
