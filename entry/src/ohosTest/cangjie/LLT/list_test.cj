package ohos_app_cangjie_entry_test.LLT

import ohos_app_cangjie_entry_test.unittest_support.registerTestSuite

private let register = testsuite()

func testsuite() {

    // y轴670，左30，右365，
    // 播放x:195,y:773
    // 完成:353,771
    registerTestSuite { AdapterViewTest() }
}