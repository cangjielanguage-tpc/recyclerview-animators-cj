package ohos_app_cangjie_entry_test.LLT

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.ui_test.*
import std.fs.*
import std.fs.File as File1
import std.io.*
import std.core.*
import ohos.file_fs.*

@Test
class AdapterViewTest {
    @TestCase
    func testAdapter(): Unit {
        let driver = Driver.create()
        let componentButton1 = driver.findComponent(On().id("ADAPTER"))
        componentButton1.click()
        driver.delayMs(1000)
        let componentButton2 = driver.findComponent(On().id("Select"))
        componentButton2.click()
        driver.delayMs(5000)
    }
}