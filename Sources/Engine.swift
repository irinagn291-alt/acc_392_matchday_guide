import SwiftUI
import Combine
import WidgetKit
import UserNotifications
import EventKit
import BackgroundTasks
import ActivityKit

@MainActor final class eR:ObservableObject {
 static let rZ=eR()
 @Published var s=xS(); @Published var message:String?; @Published var busy=false
 private let ev=EKEventStore(); private var syncing=false; private var rkAgain=false; private var rpBusy=false; private var rpAgain=false
 private var disk:URL { FileManager.default.urls(for:.documentDirectory,in:.userDomainMask)[0].appendingPathComponent("terrace-v3.json") }

 #if DEBUG && targetEnvironment(simulator)
 private let isScreenshotStore:Bool

 init(screenshotState:xS) {
  isScreenshotStore = true
  s = screenshotState
 }
 #endif

 init() {
  #if DEBUG && targetEnvironment(simulator)
  isScreenshotStore = false
  #endif
  if let data=try? Data(contentsOf:disk) { do { s=try JSONDecoder().decode(xS.self,from:data);s.weather=s.weather.filter{$0.value.xv} } catch { try? data.write(to:disk.deletingLastPathComponent().appendingPathComponent("recovery-\(Int(Date().timeIntervalSince1970)).json")); message=qL("A saved file needs recovery. A backup was kept.") } }
  rq0(); Task { await rqd(); await rq8(); if s.cloud { await rqf() } }
 }
 func rq0() {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  do { try JSONEncoder().encode(s).write(to:disk,options:[.atomic,.completeFileProtectionUntilFirstUserAuthentication]) }
  catch { message=qL("Could not save. Please free device storage and try again.") }
  let n=s.next; let v=n?.venue ?? uV.get(s.stadium)
  let w=s.weather[v.id].flatMap { x in abs(x.target.timeIntervalSince(n?.time ?? Date()))<3600 ? x:nil }
  let x=kW(stadiumID:v.id,venue:v.name,city:v.city,tz:v.tz,match:n,season:s.matches.filter{$0.time>Date()}.sorted{$0.time<$1.time},pack:s.pack,weather:w,made:Date())
  if let url=kW.file { try? JSONEncoder().encode(x).write(to:url,options:[.atomic,.completeFileProtectionUntilFirstUserAuthentication]) }
  WidgetCenter.shared.reloadAllTimelines()
 }
 func rq1() { rq0(); Task { await rq8(); await rqd() } }
 func rq2(_ m:rM) { if let i=s.matches.firstIndex(where:{$0.id==m.id}) { s.matches[i]=m }else { s.matches.append(m) }; rq1() }
 func rq3(_ m:rM) { s.matches.removeAll{$0.id==m.id}; rq1() }
 func rq4(_ n:hN) { var n=n; n.updated=Date(); if n.deleted {n.body="";n.title=""}; if let i=s.notes.firstIndex(where:{$0.id==n.id}){s.notes[i]=n}else{s.notes.append(n)}; rq0(); if s.cloud { Task{await rqf()} } }
 func rq5(_ id:String,_ label:String) { if let i=s.favorites.firstIndex(where:{$0.id==id}) { s.favorites[i].active.toggle(); s.favorites[i].updated=Date() }else{s.favorites.append(zF(id:id,label:label,active:true))}; rq0(); if s.cloud {Task{await rqf()}} }
 func rq6(_ id:String) { guard let i=s.pack.firstIndex(where:{$0.id==id}) else{return}; s.pack[i].done.toggle(); if let rid=s.pack[i].reminder, EKEventStore.authorizationStatus(for:.reminder) == .fullAccess, let r=ev.calendarItem(withIdentifier:rid) as? EKReminder { r.isCompleted=s.pack[i].done; try? ev.save(r,commit:true) }; rq0() }
 func rq7() async {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  do { let ok=try await UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge]); s.alerts=ok; rq0(); if ok { await rq8(); message=qL("Match reminders are ready.") }else {message=qL("Notifications are off. Your plans still work here.")} }
  catch {message=qL("Notifications are unavailable. Your plans are saved.")}
 }
 func rq8() async {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  if rpBusy{rpAgain=true;return};rpBusy=true;defer{rpBusy=false;if rpAgain{rpAgain=false;Task{await self.rq8()}}}
  let center=UNUserNotificationCenter.current()
  let old=await center.pendingNotificationRequests(); center.removePendingNotificationRequests(withIdentifiers:old.filter{$0.identifier.hasPrefix("terrace.")}.map(\.identifier))
  guard s.alerts else{return}; let a=await center.notificationSettings(); guard [.authorized,.provisional,.ephemeral].contains(a.authorizationStatus) else{return}
  for m in s.matches.filter({$0.time>Date()}).sorted(by:{$0.time<$1.time}).prefix(24) {
   for (tag,date,title) in [("day",m.time.addingTimeInterval(-86400),qL("Match tomorrow")),("pack",m.arrival,qL("Your matchday checklist"))] where date>Date() {
    let c=UNMutableNotificationContent(); c.title=title; c.body=m.title+" · "+m.venue.name; c.sound = .default
    let dc=Calendar.current.dateComponents([.year,.month,.day,.hour,.minute],from:date)
    try? await center.add(UNNotificationRequest(identifier:"terrace.\(m.id).\(tag)",content:c,trigger:UNCalendarNotificationTrigger(dateMatching:dc,repeats:false)))
   }
  }
 }
 func rq9(_ v:uV,background:Bool=false) async -> Bool {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return false }
  #endif
  guard s.online else {if !background {message=qL("Enable weather updates in settings. The guide works offline.")};return false}
  let target=s.matches.filter{$0.stadium==v.id && $0.time>Date()}.sorted{$0.time<$1.time}.first?.time ?? Date()
  guard target.timeIntervalSinceNow < 15*86400 else {if !background{message=qL("Forecasts open within 15 days of the match.")};return false}
  if let x=s.weather[v.id],Date().timeIntervalSince(x.fetched)<3600,abs(x.target.timeIntervalSince(target))<3600 {if !background{message=qL("The cached forecast is less than an hour old.")};return true}
  busy=true; defer{busy=false}
  do {
   let z=try await GroundForecast.read(v,target:target)
   guard s.online,!Task.isCancelled else{return false}
   let t=z.temperature
   s.weather[v.id]=z;rq0()
   if background && s.alerts {
    let a=await UNUserNotificationCenter.current().notificationSettings()
    if [.authorized,.provisional].contains(a.authorizationStatus) { let c=UNMutableNotificationContent();c.title=qL("Match weather updated");c.body=v.name+" · \(Int(t.rounded()))°C";try? await UNUserNotificationCenter.current().add(UNNotificationRequest(identifier:"weather.\(v.id)",content:c,trigger:UNTimeIntervalNotificationTrigger(timeInterval:1,repeats:false))) }
   };return true
  } catch { if !background {message=qL("Weather could not refresh. Saved forecasts remain available.")};return false }
 }
 func rqa(_ m:rM) async {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  guard m.calendarID==nil else{message=qL("Already copied. Manage this event in Calendar.");return}
  do {
   guard try await ev.requestWriteOnlyAccessToEvents() else{message=qL("Calendar access is off. The match is still saved here.");return}
   guard let calendar=ev.defaultCalendarForNewEvents else{message=qL("Add a writable calendar in the Calendar app first.");return}
   let e=EKEvent(eventStore:ev);e.calendar=calendar;e.title=m.title;e.startDate=m.time;e.endDate=m.time.addingTimeInterval(7200);e.timeZone=TimeZone(identifier:m.venue.tz);e.location=m.venue.name;e.notes=qL("Your personal match plan")+"\n"+m.gate+" · "+m.sector;e.addAlarm(EKAlarm(relativeOffset:-86400));e.addAlarm(EKAlarm(relativeOffset:Double(-m.lead*60)))
   try ev.save(e,span:.thisEvent,commit:true)
   if let i=s.matches.firstIndex(where:{$0.id==m.id}){s.matches[i].calendarID=e.eventIdentifier ?? "exported"};rq0();message=qL("Added to Calendar with reminders.")
  }catch{message=qL("Calendar could not save the event. Your local plan is safe.")}
 }
 func rqb() async {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  do {
   guard try await ev.requestFullAccessToReminders() else{message=qL("Reminders access is off. Use the checklist here.");return}
   guard let calendar=ev.defaultCalendarForNewReminders() else{message=qL("Add a reminder list in Reminders first.");return}
   for i in s.pack.indices where !s.pack[i].done {
    let item=s.pack[i];let r=item.reminder.flatMap{ev.calendarItem(withIdentifier:$0) as? EKReminder} ?? EKReminder(eventStore:ev)
    r.calendar=calendar;r.title=item.text;r.isCompleted=item.done
    if let date=s.next?.arrival {r.dueDateComponents=Calendar.current.dateComponents([.year,.month,.day,.hour,.minute],from:date)}
    try ev.save(r,commit:true);s.pack[i].reminder=r.calendarItemIdentifier
   };rq0();message=qL("Checklist copied to Reminders.")
  }catch{rq0();message=qL("Some reminders could not be saved. Your checklist is safe.")}
 }
 func rqc(_ m:rM) async {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  guard m.time>Date(),m.time.timeIntervalSinceNow<=8*3600 else{message=qL("Start the countdown within eight hours of kickoff.");return}
  guard ActivityAuthorizationInfo().areActivitiesEnabled else{message=qL("Live Activities are off. The countdown remains in the app.");return}
  for x in Activity<fA>.activities {await x.end(nil,dismissalPolicy:.immediate)}
  do{_ = try Activity.request(attributes:fA(matchID:m.id,title:m.title,venue:m.venue.name),content:ActivityContent(state:fA.ContentState(end:m.time,start:Date()),staleDate:m.time),pushType:nil);message=qL("Countdown started on the Lock Screen.")}
  catch{message=qL("The system could not start the countdown.")}
 }
 func rqd() async {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  objectWillChange.send()
  if s.alerts {let status=await UNUserNotificationCenter.current().notificationSettings();if ![.authorized,.provisional,.ephemeral].contains(status.authorizationStatus){s.alerts=false;rq0()}}
  for x in Activity<fA>.activities {
   guard let m=s.matches.first(where:{$0.id==x.attributes.matchID}),m.time>Date() else{await x.end(nil,dismissalPolicy:.immediate);continue}
   if x.content.state.end != m.time {await x.end(nil,dismissalPolicy:.immediate)}
  }
 }
 func rqe() async {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  for x in Activity<fA>.activities {await x.end(nil,dismissalPolicy:.immediate)};message=qL("Countdown ended.")
 }
 func rqf() async {}
 func prepare7634d() throws -> Data {
  let value: cY = cY(notes:s.notes,favorites:s.favorites)
  return try JSONEncoder().encode(value)
 }
 func accept7634d(_ data:Data) throws {
  let incoming = try JSONDecoder().decode(cY.self, from:data)
  for n in incoming.notes {if let i=s.notes.firstIndex(where:{$0.id==n.id}){if s.notes[i].updated<n.updated{s.notes[i]=n}}else{s.notes.append(n)}};for f in incoming.favorites {if let i=s.favorites.firstIndex(where:{$0.id==f.id}){if s.favorites[i].updated<f.updated{s.favorites[i]=f}}else{s.favorites.append(f)}};rq0()
 }

 func rqg() {
  #if DEBUG && targetEnvironment(simulator)
  if isScreenshotStore { return }
  #endif
  let r=BGAppRefreshTaskRequest(identifier:"org.terracemap.d72b6e.weather");r.earliestBeginDate=Date().addingTimeInterval(6*3600);try? BGTaskScheduler.shared.submit(r)
 }
}
final class tB:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate {
 func userNotificationCenter(_ center:UNUserNotificationCenter,willPresent notification:UNNotification) async -> UNNotificationPresentationOptions {[.banner,.sound,.list]}
 func application(_ application:UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]?=nil)->Bool {
  #if DEBUG && targetEnvironment(simulator)
  if ScreenshotScreen.current != nil { return true }
  #endif
  UNUserNotificationCenter.current().delegate=self
  BGTaskScheduler.shared.register(forTaskWithIdentifier:"org.terracemap.d72b6e.weather",using:nil){t in
   let work=Task{@MainActor in let m=eR.rZ;let ok=await m.rq9(m.s.next?.venue ?? uV.get(m.s.stadium),background:true);m.rqg();t.setTaskCompleted(success:ok)}
   t.expirationHandler={work.cancel()}
  };return true
 }
}

private enum GroundForecast {
 struct Bulletin:Decodable {let weather:[Hour];let sources:[Station]}
 struct Station:Decodable {let id:Int;let station_name:String;let distance:Double?}
 struct Hour:Decodable {let timestamp:String;let source_id:Int;let temperature:Double?;let wind_speed:Double?;let precipitation_probability:Double?;let icon:String?}
 static func read(_ venue:uV,target:Date) async throws -> wQ {
  let iso=ISO8601DateFormatter()
  var url=URLComponents(string:"https://api.brightsky.dev/weather")!
  url.queryItems=["lat":String(venue.lat),"lon":String(venue.lon),"max_dist":"50000","tz":"UTC","units":"dwd","date":iso.string(from:target.addingTimeInterval(-3600)),"last_date":iso.string(from:target.addingTimeInterval(3600))].map{URLQueryItem(name:$0.key,value:$0.value)}
  let (data,reply)=try await URLSession.shared.data(for:URLRequest(url:url.url!,timeoutInterval:16))
  guard (reply as? HTTPURLResponse)?.statusCode==200,data.count<500000 else{throw URLError(.badServerResponse)}
  return try parse(data,venue:venue,target:target)
 }
 static func parse(_ data:Data,venue:uV,target:Date)throws->wQ {
  let forecast=try JSONDecoder().decode(Bulletin.self,from:data)
  let fmt=ISO8601DateFormatter()
  let nearby=Dictionary(forecast.sources.filter{($0.distance ?? .infinity)<=50000}.map{($0.id,$0.station_name)},uniquingKeysWith:{$1})
  let options=forecast.weather.compactMap{row -> wQ? in
   guard let time=fmt.date(from:row.timestamp),abs(time.timeIntervalSince(target))<=3700,let t=row.temperature,let wind=row.wind_speed,let station=nearby[row.source_id] else{return nil}
   let codes=["clear-day":0,"clear-night":0,"partly-cloudy-day":2,"partly-cloudy-night":2,"cloudy":3,"fog":45,"rain":61,"sleet":68,"snow":71,"thunderstorm":95]
   let value=wQ(venue:venue.id,target:time,fetched:Date(),temperature:t,rain:row.precipitation_probability,wind:wind,code:codes[row.icon ?? ""] ?? -1,station:station)
   return value.xv ? value:nil
  }
  guard let best=options.min(by:{abs($0.target.timeIntervalSince(target))<abs($1.target.timeIntervalSince(target))}) else{throw URLError(.resourceUnavailable)};return best
 }
}
