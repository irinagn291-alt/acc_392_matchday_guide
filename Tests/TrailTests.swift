import XCTest

final class qJ:XCTestCase {
 var a:XCUIApplication!
 override func setUpWithError() throws {continueAfterFailure=false;a=XCUIApplication();a.launchArguments=["-AppleLanguages","(en)","-AppleLocale","en_US"];a.launch()}
 func shot(_ n:String){let x=XCTAttachment(screenshot:a.screenshot());x.name=n;x.lifetime = .keepAlways;add(x)}
 func tab(_ n:String){let b=a.tabBars.buttons[n];if b.exists{b.tap()}else{a.buttons[n].firstMatch.tap()}}
 func reveal(_ e:XCUIElement){for _ in 0..<6{if e.isHittable{return};a.swipeUp()};XCTAssertTrue(e.isHittable)}
 func test01Journey() throws {
  XCTAssertTrue(a.staticTexts["Matchday starts here."].waitForExistence(timeout:15));shot("01-Offline-guide")
  tab("Matchdays");a.buttons["add-match"].tap()
  let home=a.textFields["home"];XCTAssertTrue(home.waitForExistence(timeout:4));home.tap();home.typeText("Northside")
  let away=a.textFields["away"];away.tap();away.typeText("Riverside")
  a.buttons["save-match"].tap();XCTAssertTrue(a.buttons["match-Northside"].waitForExistence(timeout:5));shot("02-Home-season")
  a.buttons["match-Northside"].tap();XCTAssertTrue(a.staticTexts["Northside · Riverside"].waitForExistence(timeout:5));shot("03-Arrival-plan")
  a.swipeUp();let live=a.buttons["start-live"];if live.isHittable{live.tap();XCTAssertTrue(a.alerts.firstMatch.waitForExistence(timeout:5));a.alerts.buttons["OK"].tap()}
  tab("Checklist");let pass=a.buttons["pack-Admission pass"];XCTAssertTrue(pass.waitForExistence(timeout:4));pass.tap();XCTAssertEqual(pass.value as? String,"Ready");shot("04-Checklist")
  a.terminate();a.launch();tab("Checklist");XCTAssertEqual(a.buttons["pack-Admission pass"].value as? String,"Ready")
  tab("Journal");a.buttons["add-note"].tap();let title=a.textFields["note-title"];title.tap();title.typeText("Our meeting point");let body=a.textViews["note-body"];body.tap();body.typeText("Meet by the station clock. Bring the blue scarf.");a.buttons["save-note"].tap();XCTAssertTrue(a.staticTexts["Our meeting point"].waitForExistence(timeout:5));shot("05-Journal")
  a.terminate();a.launch();tab("Journal");XCTAssertTrue(a.staticTexts["Our meeting point"].waitForExistence(timeout:5));tab("Matchdays");XCTAssertTrue(a.buttons["match-Northside"].exists)
 }
 func test02Localizations() throws {
  let rows=[("de","Dein Spieltag beginnt hier."),("pt-BR","O dia de jogo começa aqui."),("fr","Le jour de match commence ici."),("es","El día de partido empieza aquí."),("it","La partita inizia qui."),("ru","Матчдэй начинается здесь.")]
  for (lang,hero) in rows {a.terminate();a.launchArguments=["-AppleLanguages","(\(lang))","-AppleLocale",lang];a.launch();XCTAssertTrue(a.staticTexts[hero].waitForExistence(timeout:10));shot("locale-"+lang)}
 }
 func test03WidgetsAndOffline() throws {
  a.buttons["settings"].tap();reveal(a.buttons["Widget previews"]);a.buttons["Widget previews"].tap();XCTAssertTrue(a.staticTexts["Previews use your saved plans."].waitForExistence(timeout:5));XCTAssertTrue(a.staticTexts["Northside · Riverside"].firstMatch.waitForExistence(timeout:5));shot("06-Widget-small-medium");a.swipeUp();shot("07-Widget-large-lock");a.terminate();a.launch()
  a.swipeUp();let refresh=a.buttons["Refresh weather"];if !refresh.isHittable{a.swipeUp()};if refresh.isHittable{refresh.tap();XCTAssertTrue(a.alerts.firstMatch.waitForExistence(timeout:5));XCTAssertTrue(a.alerts.staticTexts["Enable weather updates in settings. The guide works offline."].exists);a.alerts.buttons["OK"].tap()}
 }
 func test04PermissionDenials() throws {
  tab("Matchdays");a.buttons["match-Northside"].tap();a.swipeUp()
  let spring=XCUIApplication(bundleIdentifier:"com.apple.springboard")
  reveal(a.buttons["Add to Apple Calendar"]);a.buttons["Add to Apple Calendar"].tap()
  if spring.alerts.firstMatch.waitForExistence(timeout:4) {let no=spring.alerts.buttons["Don't Allow"];if no.exists{no.tap()}else{spring.alerts.buttons.firstMatch.tap()}}
  XCTAssertTrue(a.alerts.firstMatch.waitForExistence(timeout:6));shot("08-Calendar-result");a.alerts.buttons["OK"].tap()
  tab("Checklist");a.swipeUp();reveal(a.buttons["Copy to Reminders"]);a.buttons["Copy to Reminders"].tap()
  if spring.alerts.firstMatch.waitForExistence(timeout:4) {let no=spring.alerts.buttons["Don't Allow"];if no.exists{no.tap()}else{spring.alerts.buttons.firstMatch.tap()}}
  XCTAssertTrue(a.alerts.firstMatch.waitForExistence(timeout:6));shot("09-Reminders-result");a.alerts.buttons["OK"].tap()
  XCTAssertTrue(a.buttons["pack-Admission pass"].exists)
  tab("Guide");a.buttons["settings"].tap();reveal(a.buttons["Enable match reminders"]);a.buttons["Enable match reminders"].tap()
  if spring.alerts.firstMatch.waitForExistence(timeout:4){let no=spring.alerts.buttons["Don't Allow"];if no.exists{no.tap()}else{spring.alerts.buttons.firstMatch.tap()}}
  XCTAssertTrue(a.alerts.firstMatch.waitForExistence(timeout:6));shot("10-Notifications-result");a.alerts.buttons["OK"].tap()
 }

}
