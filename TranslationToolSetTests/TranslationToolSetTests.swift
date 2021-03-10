//
//  TranslationToolSetTests.swift
//  TranslationToolSetTests
//
//  Created by Dmitry Matyushkin on 3/9/21.
//

import XCTest

class TranslationToolSetTests: XCTestCase {
    
    private let enTranslationData =
"""
<?xml version="1.0" encoding="UTF-8"?>
<xliff xmlns="urn:oasis:names:tc:xliff:document:1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.2" xsi:schemaLocation="urn:oasis:names:tc:xliff:document:1.2 http://docs.oasis-open.org/xliff/v1.2/os/xliff-core-1.2-strict.xsd">
  <file original="KidsMathExaminator/Base.lproj/Main.storyboard" source-language="en" target-language="en2" datatype="plaintext">
    <header>
      <tool tool-id="com.apple.dt.xcode" tool-name="Xcode" tool-version="12.4" build-num="12D4e"/>
    </header>
    <body>
      <trans-unit id="643-qy-ORC.title" xml:space="preserve">
        <source>Set</source>
        <target>Set</target>
        <note>Class = "UIBarButtonItem"; title = "Set"; ObjectID = "643-qy-ORC";</note>
      </trans-unit>
      <trans-unit id="AFs-sf-Axo.text" xml:space="preserve">
        <source>10</source>
        <target>10</target>
        <note>Class = "UILabel"; text = "10"; ObjectID = "AFs-sf-Axo";</note>
      </trans-unit>
    </body>
  </file>
  <file original="KidsMathExaminator/en.lproj/InfoPlist.strings" source-language="en" target-language="en" datatype="plaintext">
    <header>
      <tool tool-id="com.apple.dt.xcode" tool-name="Xcode" tool-version="12.4" build-num="12D4e"/>
    </header>
    <body>
      <trans-unit id="CFBundleName" xml:space="preserve">
        <source>KidsMath</source>
        <target>KidsMath</target>
        <note>Bundle name</note>
      </trans-unit>
    </body>
  </file>
  <file original="KidsMathExaminator/en.lproj/Localizable.strings" source-language="en" target-language="en" datatype="plaintext">
    <header>
      <tool tool-id="com.apple.dt.xcode" tool-name="Xcode" tool-version="12.4" build-num="12D4e"/>
    </header>
    <body>
      <trans-unit id="Allow addition" xml:space="preserve">
        <source>Allow addition</source>
        <target>Allow addition</target>
        <note>Are addition operation tasks allowed</note>
      </trans-unit>
      <trans-unit id="Allow division" xml:space="preserve">
        <source>Allow division</source>
        <target>Allow division</target>
        <note>Are division operation tasks allowed</note>
      </trans-unit>
    </body>
  </file>
</xliff>
"""

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTranslationMapping() throws {
        let language = try TranslationLanguage(documentURL: URL(fileURLWithPath: "/"), fileContent: enTranslationData)
        
        XCTAssertEqual(language.sourceLanguage, "en")
        XCTAssertEqual(language.targetLanguage, "en2")
        XCTAssertEqual(language.translationFiles.count, 3)
        XCTAssertEqual(language.translationFiles[0].filePath, "KidsMathExaminator/Base.lproj/Main.storyboard")
        XCTAssertEqual(language.translationFiles[0].toolId, "com.apple.dt.xcode")
        XCTAssertEqual(language.translationFiles[0].toolName, "Xcode")
        XCTAssertEqual(language.translationFiles[0].toolVersion, "12.4")
        XCTAssertEqual(language.translationFiles[0].toolBuildNumber, "12D4e")
        XCTAssertEqual(language.translationFiles[0].translationUnits.count, 2)
        XCTAssertEqual(language.translationFiles[0].translationUnits[0].unitId, "643-qy-ORC.title")
        XCTAssertEqual(language.translationFiles[0].translationUnits[0].source, "Set")
        XCTAssertEqual(language.translationFiles[0].translationUnits[0].target, "Set")
        XCTAssertEqual(language.translationFiles[0].translationUnits[0].note, "Class = \"UIBarButtonItem\"; title = \"Set\"; ObjectID = \"643-qy-ORC\";")
        XCTAssertEqual(language.translationFiles[0].translationUnits[1].unitId, "AFs-sf-Axo.text")
        XCTAssertEqual(language.translationFiles[0].translationUnits[1].source, "10")
        XCTAssertEqual(language.translationFiles[0].translationUnits[1].target, "10")
        XCTAssertEqual(language.translationFiles[0].translationUnits[1].note, "Class = \"UILabel\"; text = \"10\"; ObjectID = \"AFs-sf-Axo\";")
        XCTAssertEqual(language.translationFiles[1].filePath, "KidsMathExaminator/en.lproj/InfoPlist.strings")
        XCTAssertEqual(language.translationFiles[1].toolId, "com.apple.dt.xcode")
        XCTAssertEqual(language.translationFiles[1].toolName, "Xcode")
        XCTAssertEqual(language.translationFiles[1].toolVersion, "12.4")
        XCTAssertEqual(language.translationFiles[1].toolBuildNumber, "12D4e")
        XCTAssertEqual(language.translationFiles[1].translationUnits.count, 1)
        XCTAssertEqual(language.translationFiles[1].translationUnits[0].unitId, "CFBundleName")
        XCTAssertEqual(language.translationFiles[1].translationUnits[0].source, "KidsMath")
        XCTAssertEqual(language.translationFiles[1].translationUnits[0].target, "KidsMath")
        XCTAssertEqual(language.translationFiles[1].translationUnits[0].note, "Bundle name")
        XCTAssertEqual(language.translationFiles[2].filePath, "KidsMathExaminator/en.lproj/Localizable.strings")
        XCTAssertEqual(language.translationFiles[2].toolId, "com.apple.dt.xcode")
        XCTAssertEqual(language.translationFiles[2].toolName, "Xcode")
        XCTAssertEqual(language.translationFiles[2].toolVersion, "12.4")
        XCTAssertEqual(language.translationFiles[2].toolBuildNumber, "12D4e")
        XCTAssertEqual(language.translationFiles[2].translationUnits.count, 2)
        XCTAssertEqual(language.translationFiles[2].translationUnits[0].unitId, "Allow addition")
        XCTAssertEqual(language.translationFiles[2].translationUnits[0].source, "Allow addition")
        XCTAssertEqual(language.translationFiles[2].translationUnits[0].target, "Allow addition")
        XCTAssertEqual(language.translationFiles[2].translationUnits[0].note, "Are addition operation tasks allowed")
        XCTAssertEqual(language.translationFiles[2].translationUnits[1].unitId, "Allow division")
        XCTAssertEqual(language.translationFiles[2].translationUnits[1].source, "Allow division")
        XCTAssertEqual(language.translationFiles[2].translationUnits[1].target, "Allow division")
        XCTAssertEqual(language.translationFiles[2].translationUnits[1].note, "Are division operation tasks allowed")
    }

    func testSerialize() throws {
        let language = TranslationLanguage(documentURL: URL(fileURLWithPath: "/"), sourceLanguage: "en", targetLanguage: "ru", translationFiles: [
            TranslationFile(filePath: "test/file/path", toolId: "123", toolName: "456", toolVersion: "789", toolBuildNumber: "012", translationUnits: [
                TranslationUnit(unitId: "01", source: "test source", target: "test target", note: "test note"),
                TranslationUnit(unitId: "02", source: "test source 2", target: "test target 2", note: "test note 2")
            ]),
            TranslationFile(filePath: "test/file/path2", toolId: "123", toolName: "456", toolVersion: "789", toolBuildNumber: "012", translationUnits: [
                TranslationUnit(unitId: "03", source: "test source 3", target: "test target 3", note: "test note 3"),
                TranslationUnit(unitId: "04", source: "test source 4", target: "test target 4", note: "test note 4")
            ])
        ])
        
        let str = try language.serialize()
        let src = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n<xliff xmlns=\"urn:oasis:names:tc:xliff:document:1.2\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"1.2\" xsi:schemaLocation=\"urn:oasis:names:tc:xliff:document:1.2 http://docs.oasis-open.org/xliff/v1.2/os/xliff-core-1.2-strict.xsd\"> \n <file original=\"test/file/path\" source-language=\"en\" target-language=\"ru\" datatype=\"plaintexts\">\n  <header>\n   <tool tool-id=\"123\" tool-name=\"456\" tool-version=\"789\" build-num=\"012\" />\n  </header>\n  <body>\n   <trans-unit id=\"01\" xml:space=\"preserve\">\n    <source>test source</source>\n    <target>\n     test target\n    </target>\n    <note>\n     test note\n    </note>\n   </trans-unit>\n   <trans-unit id=\"02\" xml:space=\"preserve\">\n    <source>test source 2</source>\n    <target>\n     test target 2\n    </target>\n    <note>\n     test note 2\n    </note>\n   </trans-unit>\n  </body>\n </file>\n <file original=\"test/file/path2\" source-language=\"en\" target-language=\"ru\" datatype=\"plaintexts\">\n  <header>\n   <tool tool-id=\"123\" tool-name=\"456\" tool-version=\"789\" build-num=\"012\" />\n  </header>\n  <body>\n   <trans-unit id=\"03\" xml:space=\"preserve\">\n    <source>test source 3</source>\n    <target>\n     test target 3\n    </target>\n    <note>\n     test note 3\n    </note>\n   </trans-unit>\n   <trans-unit id=\"04\" xml:space=\"preserve\">\n    <source>test source 4</source>\n    <target>\n     test target 4\n    </target>\n    <note>\n     test note 4\n    </note>\n   </trans-unit>\n  </body>\n </file>\n</xliff>"
        XCTAssertEqual(str, src)
    }
}
