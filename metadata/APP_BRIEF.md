<!-- gf-brief source=47097765654a2723cd373ce0f8b736e4f483820bd5eb12e27e81ea531eabcc69 written=2026-11-19T22:25:33+03:00 -->
# Matchday Guide

## What it is

Matchday Guide is a football matchday planner for fans attending in person. It combines an offline guide to three stadiums with personal match plans, arrival times, kickoff countdowns, a packing checklist and a journal. Fans enter their own fixtures and can opt in to stadium weather and reminders.

## Launch and onboarding

1. A fresh launch opens the “Guide” tab directly, with “Matchday Guide” in the navigation bar, “YOUR NEXT GREAT DAY” above “Matchday starts here.”, and an “OFFLINE STADIUM GUIDE” card for “Wembley Stadium”. The card reads “London · Opened 2007” and shows a stadium sketch with the north side highlighted.
2. The stadium choices are “London” / “Wembley Stadium”, “Berlin” / “Olympiastadion Berlin”, and “Saint-Denis” / “Stade de France”. The bottom tabs are “Guide”, “Matchdays”, “Checklist” and “Journal”. The top-right sliders icon is labeled “Settings” for accessibility.
3. There are no welcome pages, onboarding buttons or first-launch permission prompts. The weather card starts with “No saved forecast”, “Optional forecasts cover the next 15 days. Your stadium guide is always available.” and “Refresh weather”. Weather is off by default.

## Screens

Labels and quoted copy below are from the English interface. For icon-only controls, the quoted label is the accessibility label.

### “Guide” — “Matchday Guide”

- Tap a stadium choice to change the guide, sketch, travel information, sector advice, history and weather shown. The selection is saved. The heart labeled “Favorite stadium” adds or removes the selected stadium from “Favorites”.
- The sketch is labeled “Stadium orientation sketch” and marks “N”, “E”, “S” and “W”. “Expand stadium map” opens “Stadium map”. Under “Find your side”, the “Stadium side” selector offers “North”, “East”, “South” and “West”. Each choice highlights that side on the sketch and carries over to the expanded map. The instruction reads “Orientation only. Use the gate and sector printed on your pass.” “Read your sector” explains Wembley’s block levels, Berlin’s lettered lower-tier and numbered upper-tier blocks, and the tiers at Stade de France.
- “Getting there” gives venue-specific transit advice and says “Allow extra time after the match.” It covers Wembley Park, Wembley Stadium and Wembley Central stations for London, U2 and S3 / S9 for Berlin, and RER B and RER D for Saint-Denis.
- “Stadium weather” uses the next upcoming match at the selected stadium, or the current time if none is saved there. “Refresh weather” requests an update and becomes “Updating…” during the request. A matching forecast shows temperature in °C, “Rain” as a percentage or “—”, “Wind” in km/h, “Forecast for” with the venue-local time, and a timestamp headed “Updated” or “Saved forecast · may be out of date”. The card can show the weather station as well as the provider attribution.
- Under “Make it your matchday”, “A place with a story” shows venue history and a selectable source address. “Rituals & songbook” says “Meet your group before entering. Pick a meeting point for the journey home.” Under “Original fan verse” it shows “Together we rise, together we sing.” and “One crowd, one day, let our voices ring.” It ends with “Keep your own verses and traditions in Journal.”
- The footer reads “Guide checked November 2026. Transport and entry arrangements can change. Follow venue staff on the day.” The “Settings” icon opens the settings sheet.

### “Stadium map”

The expanded sheet shows the selected stadium name, a larger orientation sketch, the same “Stadium side” selector with “North”, “East”, “South” and “West”, the orientation instruction, transit directions and “Read your sector”. “Done” returns to “Guide”.

### “Matchdays”

- “Your home season” is followed by “Personal plans, entered by you. Confirm kickoff with your club.”
- The “Matches” selector offers “Upcoming” and “Past”. Upcoming matches are shown soonest first and past matches most recent first. The calendar icon labeled “Toggle date filter” shows the graphical “Date” picker. Choose a date to narrow the current list to that day at each match’s venue. Tap the icon again to show all dates in the current list.
- Each saved match row displays the clubs separated by “ · ”, the date, the stadium and kickoff. Tap it to open “Match plan”.
- An empty list shows “Make room for matchday” and “Add a home match to build your season, plan arrival and start a countdown.” Both the visible “Add home match” button and the top-right plus labeled “Add home match” open the match editor.

### “Add home match” / “Edit match”

- “Match” contains “Home club”, “Visiting club”, “Stadium” and “Kickoff”. “Stadium” offers “Wembley Stadium”, “Olympiastadion Berlin” and “Stade de France”. “Kickoff” uses the selected stadium’s time zone, displayed under “Venue time zone”. A new plan starts with the stadium selected in “Guide” and kickoff approximately two hours ahead. The kickoff picker spans 2000 through the start of 2100.
- “Your arrival” contains optional fields “Gate” and “Sector / seat” and the picker “Arrive before kickoff”. The choices are 30, 45, 60, 90, 120 and 180 minutes, shown as localized abbreviated durations. The default is 90 minutes.
- The editor repeats “Personal plans, entered by you. Confirm kickoff with your club.” Previously copied matches also show “Calendar copies do not follow edits. Manage copies in Calendar.”
- “Cancel” closes the sheet and discards edits. “Save” adds or updates the plan and closes the sheet. The two club names are trimmed and saved up to 80 characters each. “Gate” and “Sector / seat” are saved up to 100 characters each.

### “Match plan”

- “YOUR PERSONAL MATCH PLAN” heads the club names, venue, kickoff and venue time zone. A future match shows a timer labeled “Countdown to kickoff”. “Your arrival” shows the calculated arrival date and time, “Gate” and “Sector / seat”. Blank gate and seat values show “—”.
- “Edit” opens “Edit match”. If the selected record is unavailable, the detail shows “No match selected”.
- “Keep the day in reach” contains “Add reminders the day before and at your planned arrival time.” “Add to Apple Calendar” requests write-only access and creates a two-hour event at kickoff with the venue, gate and seat details, and reminders one day before kickoff and at planned arrival. On success the button reads “Already copied to Calendar” and is disabled. The note reads “Calendar copies do not follow edits. Manage copies in Calendar.”
- “Start Live Activity” starts the kickoff countdown on the Lock Screen and, on supported devices, in the Dynamic Island. It replaces a running countdown. The accompanying text is “Start within eight hours of kickoff. The timer runs offline; system limits apply.” Tapping the Live Activity opens “Matchdays”.
- “Favorite home club” adds the home club to “Favorites” and changes to “Remove favorite club”, which removes it.
- “Delete match” opens “Delete this local match? Calendar copies stay in Calendar.” Confirm with “Delete match” to remove the plan and return to the list, or dismiss with “Cancel”.

### “Checklist”

- “Pack. Check. Go.” shows a progress bar and a count such as “0 / 6 ready”. Tap a row under “Your matchday essentials” to change its check state. The accessibility values are “Ready” and “Not ready”. Checked rows are crossed out.
- The system “Edit” button enters list editing and changes to “Done”. Use the row deletion controls or swipe to “Delete”.
- “Add item” opens an alert titled “Add item” with an “Item” field. “Add” appends the trimmed text, up to 100 characters. “Cancel” closes the alert and clears the input.
- “Reset checks” opens “Prepare this checklist for another match?” Confirm with “Reset checks” to uncheck all items while keeping their text and order, or dismiss with “Cancel”.
- “Copy to Reminders” requests access and copies unfinished items to the default Apple Reminders list. If a next match exists, its planned arrival is used as the due time. The app reuses linked reminders when it can find them and updates their completion when the corresponding checks change. The screen says “Copy unfinished items to Apple Reminders. Access is requested only when you tap below.” and “Deleted checklist items keep their exported copies in Reminders.”

### “Journal”

- The heading reads “The traditions you take with you.” “Search notes” filters titles and note text without regard to case. Notes are ordered by most recently updated and show the title, a two-line text preview, type and stadium city.
- An empty journal or a search with no results displays “Your matchday stories” and “Save travel notes, rituals and your own songbook.”
- The compose icon labeled “New note” opens a new note sheet. Tap a saved note to open “Edit note”. Swipe a row to reveal “Delete”, which removes it.

### “New note” / “Edit note”

“Title” accepts a note title. “Type” offers “Ritual”, “Songbook”, “Travel” and “General”, with “Ritual” selected for a new note. “Stadium” offers the three guide venues and starts with the current guide stadium. “Your words” contains the editor labeled “Note text” and a character count such as “0 / 4000”. “Save” keeps the note and returns to “Journal”. “Cancel” discards unsaved input. Titles are trimmed and saved up to 100 characters, and the note body is optional.

### “Settings”

- “Weather updates” contains “Use stadium forecasts”, an off-by-default switch. The explanatory text reads “Only stadium coordinates are sent. No device location is requested. Forecasts are cached for an hour for each match time.” and “Hourly DWD forecasts via Bright Sky show the nearest available station and valid time.”
- “Local notifications” displays “The next 24 matches are scheduled when you open the app.” and “Get a reminder the day before a match and at your planned arrival. Weather notices appear only after an update. Background updates are scheduled by iOS.” “Enable match reminders” requests notification permission. Once enabled, “Match reminders” is shown as a switch. Turning it off removes pending match reminders. “End Live Activities” ends the running countdown.
- “Export file” opens the system save picker with the suggested name “Matchday Guide - Records”. It exports notes and favorites. “Import file” opens the system file picker for a compatible export and merges notes and favorites into the local collection. The newer record wins where there is a match. A successful import shows “File imported”. Failures display an error beneath the controls.
- “Favorites” lists saved stadiums and home clubs. The filled heart labeled “Remove favorite” removes that entry. An empty section reads “Save stadiums from Guide and clubs from a match plan.”
- “Widget previews” and “Privacy & data” open their respective screens. The footer reads “Matchday Guide is free. No purchases, advertising or tracking.” and “1.4.2 · 10427”. “Done” closes “Settings”.

### “Widget previews”

“Previews use your saved plans.” The screen shows small, medium, large and rectangular Lock Screen previews. “Match weather” shows saved weather when available for matchday, or “No saved forecast” or “Weather on matchday”. The plan previews show “NEXT HOME MATCH”, checklist progress and up to two unchecked items. The large preview adds “Season ahead” with up to three upcoming matches, venue and transit information, and saved weather when available. The rectangular preview shows “Next kickoff” with the match and time remaining. With no match, the plan previews show “Your season starts with a plan.” and “Add a home match”, and the rectangular preview shows “Add a home match”.

The previews are informational. The installed “Matchday Guide” widget, described as “Your home season, checklist and saved weather.”, opens “Matchdays” when tapped. Additional Lock Screen sizes show “Kickoff” with the time, or a relative countdown. The Live Activity displays “Kickoff countdown”.

### “Privacy & data”

- “On your device” explains local storage and removal of local data when the app is uninstalled.
- “Optional services” reads “When enabled, Bright Sky receives the stadium coordinates, match date and your IP address. Notes and favourites stay on this device until shared.”
- “Offline first” explains that the stadium guide, checklist, notes and personal match calendar work offline, that widgets use saved data, and that the app supplies no official fixtures or live scores.
- “Sources” lists the three stadiums with selectable venue source addresses. “Deutscher Wetterdienst · Bright Sky” opens the weather provider’s site. The system back control returns to “Settings”.

## Features

- “OFFLINE STADIUM GUIDE” for three venues, with “Getting there”, “Stadium map”, “Read your sector”, “A place with a story” and “Rituals & songbook”.
- “Stadium weather” with venue-local forecast times and saved readings.
- “Your home season” with personal “Upcoming” and “Past” match lists, a date filter, editable arrival plans and kickoff countdowns.
- “Add to Apple Calendar”, “Match reminders” and “Start Live Activity”.
- “Checklist” with packing progress, custom items, “Reset checks” and “Copy to Reminders”.
- “Journal” with searchable, editable “Ritual”, “Songbook”, “Travel” and “General” notes.
- “Favorites” for stadiums and home clubs, and “Export file” and “Import file” for favorites and notes.
- “Widget previews”, Home Screen and Lock Screen widgets, and a kickoff Live Activity.

## Behaviours that can look like bugs

- **A match disappears from the list.** A fixture moves from “Upcoming” to “Past” at kickoff. A date filter can also hide saved fixtures. Switch lists, select the venue’s match date, or tap “Toggle date filter” again. An empty filtered view still says “Make room for matchday”.
- **Match “Save” is disabled.** Enter non-whitespace text in both “Home club” and “Visiting club”.
- **Note “Save” is disabled.** Enter a non-whitespace “Title” and keep “Note text” at 4,000 characters or fewer. Creating new notes is capped at 100 active notes. Delete an existing note to free a slot. To recover notes hidden by a search, clear “Search notes”.
- **An item is not added, or “Add item” is disabled.** Blank or whitespace-only “Item” input closes the alert without adding a row. Delete an item if the checklist has reached 100. “Reset checks” is disabled when every item is already unchecked. Checking an item enables it, and confirming the reset leaves the items in place.
- **Weather stays empty or shows an older reading.** If “Refresh weather” reports “Enable weather updates in settings. The guide works offline.”, turn on “Use stadium forecasts” in “Settings”. “Forecasts open within 15 days of the match.” means the selected venue’s next match is too far away. Try again within the window. “The cached forecast is less than an hour old.” means a recent reading was reused. “Updating…” disables the button until the request ends. After six hours a matching saved reading can say “Saved forecast · may be out of date”. “Weather could not refresh. Saved forecasts remain available.” indicates a failed update. A widget can say “No saved forecast” even when the guide works, since the widget uses saved weather and fetches none itself.
- **The weather credit appears inconsistent.** The weather service is Bright Sky with German Weather Service data. “Stadium weather” still displays “MET Norway · CC BY 4.0”, as do some widget states. “Only stadium coordinates are sent.” also omits the requested time window disclosed in “Privacy & data”.
- **Calendar cannot be copied twice.** “Added to Calendar with reminders.” confirms the first export. “Already copied to Calendar” remains disabled even if the exported event is later removed in Apple Calendar. Edit or delete exported copies in Calendar. If permission is denied, the app shows “Calendar access is off. The match is still saved here.” A missing writable calendar shows “Add a writable calendar in the Calendar app first.” A save failure shows “Calendar could not save the event. Your local plan is safe.”
- **Reminders copies remain after deletion.** “Deleted checklist items keep their exported copies in Reminders.” Manage those copies in Apple Reminders. “Checklist copied to Reminders.” can appear with no new entries when every item is checked. If access is denied, the alert says “Reminders access is off. Use the checklist here.” If there is no default list, it says “Add a reminder list in Reminders first.” A partial failure says “Some reminders could not be saved. Your checklist is safe.”
- **Match notifications do not appear immediately.** “Match reminders are ready.” confirms permission and setup. The app schedules only future reminder times for up to the next 24 upcoming matches. Weather notices depend on an update that iOS schedules. The other permission results are “Notifications are off. Your plans still work here.” and “Notifications are unavailable. Your plans are saved.” If permission was denied, enable it in iOS Settings before retrying.
- **“Start Live Activity” does not start a countdown.** “Start the countdown within eight hours of kickoff.” means the match must be in the future and no more than eight hours away. “Live Activities are off. The countdown remains in the app.” points to the system setting. Success says “Countdown started on the Lock Screen.” A system failure says “The system could not start the countdown.” Changing kickoff, deleting the match, or returning after kickoff can end an existing countdown. “End Live Activities” reports “Countdown ended.”
- **An import does not replace the entire collection.** “Import file” expects a compatible Matchday Guide export. It adds new records and applies newer versions of matching records. Existing records absent from the imported copy stay in place. Choose a valid export if the picker reports an error.
- **Local save alerts.** Alerts headed “Matchday Guide” close with “OK”. “Could not save. Please free device storage and try again.” calls for freeing space and retrying. “A saved file needs recovery. A backup was kept.” can appear when saved data cannot be read on launch. There is no in-app recovery control for that backup.

## Starter content and resume

- The three venue guides are built in, with “Wembley Stadium” selected on first launch. “Rituals & songbook” includes the built-in “Original fan verse”.
- The checklist starts with six unchecked items in this order: “Admission pass”, “Scarf”, “Charged phone”, “Travel card”, “Water” and “Weather layer”.
- A fresh install has no sample matches, journal entries, favorites or saved forecast.
- Saved plans, notes, favorites, the selected stadium and partial checklist progress are available after relaunch. Cold launch opens “Guide”. Unsaved match and note drafts are discarded when the editor is canceled and are unavailable after a cold relaunch.

## Permissions

- **Calendar write-only access.** Requested when the user taps “Add to Apple Calendar”. The English usage description is “Create a calendar copy of your match with arrival and day-before reminders.”
- **Reminders full access.** Requested when the user taps “Copy to Reminders”. The English usage description is “Create and update your exported matchday checklist in Apple Reminders.”
- **Notifications.** Requested when the user taps “Enable match reminders”. The system prompt covers alerts, sounds and badges. It uses system wording with no app-supplied usage-description string.
- Live Activities depend on the system setting and have no separate app-authored permission prompt. Weather uses the selected stadium’s location and requests no device location access.

## Absent

Login or accounts, in-app purchases, ads, analytics, an account deletion flow and an App Tracking Transparency prompt are absent. Users create private match plans, checklist items and notes, and can manually share exported notes and favorites. There is no public posting, shared feed or community feature.

## Data and support

Plans, checklist progress, notes, favorites and saved weather are kept on the device. The app has no automatic cloud sync. “Export file” lets the user save a copy of notes and favorites to a destination they choose. Calendar and Reminders copies are created only after the user taps the relevant control and grants access, and those copies stay in the destination app when the local record is deleted.

With stadium forecasts enabled, Bright Sky receives the selected venue’s coordinates and requested time window, along with the connection’s IP address. The stadium guide, match planning, checklist and journal work offline. There is no on-screen “Contact” or “Support” control. “Privacy & data” contains venue and weather sources.

## Scanning and health

None.

## Platform

- Native iPhone and iPad support. Minimum iOS and iPadOS version is 17.4.
- iPhone supports portrait and both landscape orientations. iPad also supports upside-down portrait. Wider layouts can place guide cards side by side. The app uses a light appearance.
- The same three venues and features are available regardless of region. Kickoff and arrival displays use the venue’s time zone, and date and time formatting follows system locale conventions.
- The native interface is localized in English, German, Brazilian Portuguese, French, Spanish, Italian and Russian. The displayed app name is “Matchday Guide” in all seven.

## Category

Sports
