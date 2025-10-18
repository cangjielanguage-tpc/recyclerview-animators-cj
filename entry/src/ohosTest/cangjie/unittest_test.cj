package ohos_app_cangjie_entry_test

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.ui_test.*

@Test
class TestExample {
    @TestCase
    func test(): Unit {
        let driver = Driver.create()
        let componentButton1 = driver.findComponent(On().id("ZJson"))
        componentButton1.click()
        driver.delayMs(2000)
        let componentButton2 = driver.findComponent(On().id("LLTTest"))
        componentButton2.click()
        driver.delayMs(180000)
    }
}
