import SwiftUI
import EventKit
import UserNotifications
import WidgetKit

struct mV:View {
 @EnvironmentObject var a:eR;@State var add=false;@State var past=false;@State var day=false;@State var selected=Date()
 var rows:[rM] {a.s.matches.filter{(past ? $0.time<=Date():$0.time>Date()) && (!day || $0.xg(selected))}.sorted{past ? $0.time>$1.time:$0.time<$1.time}}
 var body:some View {
  ScrollView{VStack(alignment:.leading,spacing:20){
   Text(qL("Your home season")).font(.largeTitle.bold()).foregroundStyle(nB)
   Text(qL("Personal plans, entered by you. Confirm kickoff with your club.")).font(.subheadline).foregroundStyle(.secondary)
   HStack{Picker(qL("Matches"),selection:$past){Text(qL("Upcoming")).tag(false);Text(qL("Past")).tag(true)}.pickerStyle(.segmented);Button{day.toggle()}label:{Image(systemName:day ? "list.bullet":"calendar")}.accessibilityLabel(qL("Toggle date filter"))}
   if day {DatePicker(qL("Date"),selection:$selected,displayedComponents:.date).datePickerStyle(.graphical).padding(12).background(.white,in:RoundedRectangle(cornerRadius:20))}
   if rows.isEmpty {VStack(alignment:.leading,spacing:18){Image(systemName:"calendar.badge.plus").font(.system(size:45)).foregroundStyle(cB);Text(qL("Make room for matchday")).font(.title2.bold());Text(qL("Add a home match to build your season, plan arrival and start a countdown.")).foregroundStyle(.secondary);Button{add=true}label:{Label(qL("Add home match"),systemImage:"plus")}.buttonStyle(.borderedProminent).accessibilityIdentifier("add-first-match")}.padding(24).frame(maxWidth:.infinity,alignment:.leading).background(.white,in:RoundedRectangle(cornerRadius:24))}
   ForEach(rows){m in NavigationLink{dV(id:m.id)}label:{VStack(alignment:.leading,spacing:16){HStack{Text(qD(m.time,m.venue.tz)).font(.caption.weight(.bold)).foregroundStyle(cB);Spacer();Image(systemName:"chevron.right").foregroundStyle(.secondary)};Text(m.title).font(.title3.bold()).foregroundStyle(nB);HStack{Label(m.venue.name,systemImage:"mappin.and.ellipse").lineLimit(2);Spacer();Text(qF(m.time,m.venue.tz)).font(.caption)}.font(.caption).foregroundStyle(.secondary)}.padding(22).background(.white,in:RoundedRectangle(cornerRadius:22))}.buttonStyle(.plain).accessibilityIdentifier("match-"+m.home)}
  }.padding(20).frame(maxWidth:900).frame(maxWidth:.infinity)}.background(Color(red:0.94,green:0.96,blue:0.99)).navigationTitle(qL("Matchdays")).navigationBarTitleDisplayMode(.inline)
  .toolbar{ToolbarItem(placement:.topBarTrailing){Button{add=true}label:{Image(systemName:"plus")}.accessibilityLabel(qL("Add home match")).accessibilityIdentifier("add-match")}}
  .sheet(isPresented:$add){NavigationStack{eV(original:nil)}}
 }
}
struct eV:View {
 @EnvironmentObject var a:eR;@Environment(\.dismiss) var dismiss
 var original:rM?
 @State var home="";@State var away="";@State var venue="wem";@State var date=Date().addingTimeInterval(7200);@State var gate="";@State var sector="";@State var lead=90
 var valid:Bool{!home.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty && !away.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty}
 var body:some View{Form{
  Section(qL("Match")){TextField(qL("Home club"),text:$home).accessibilityIdentifier("home");TextField(qL("Visiting club"),text:$away).accessibilityIdentifier("away");Picker(qL("Stadium"),selection:$venue){ForEach(uV.all){v in Text(v.name).tag(v.id)}};DatePicker(qL("Kickoff"),selection:$date,in:Date(timeIntervalSince1970:946684800)...Date(timeIntervalSince1970:4102444800)).environment(\.timeZone,TimeZone(identifier:uV.get(venue).tz)!);Text(qL("Venue time zone")+": "+uV.get(venue).tz).font(.caption).foregroundStyle(.secondary)}
  Section(qL("Your arrival")){TextField(qL("Gate"),text:$gate);TextField(qL("Sector / seat"),text:$sector);Picker(qL("Arrive before kickoff"),selection:$lead){ForEach([30,45,60,90,120,180],id:\.self){v in Text(Duration.seconds(v*60).formatted(.units(allowed:[.hours,.minutes],width:.abbreviated))).tag(v)}}}
  Section{Text(qL("Personal plans, entered by you. Confirm kickoff with your club.")).font(.caption);if original?.calendarID != nil {Text(qL("Calendar copies do not follow edits. Manage copies in Calendar.")).font(.caption)}}
 }.navigationTitle(qL(original == nil ? "Add home match":"Edit match")).toolbar{ToolbarItem(placement:.cancellationAction){Button(qL("Cancel")){dismiss()}};ToolbarItem(placement:.confirmationAction){Button(qL("Save")){
  let m=rM(id:original?.id ?? UUID().uuidString,home:String(home.trimmingCharacters(in:.whitespacesAndNewlines).prefix(80)),away:String(away.trimmingCharacters(in:.whitespacesAndNewlines).prefix(80)),stadium:venue,time:date,gate:String(gate.prefix(100)),sector:String(sector.prefix(100)),lead:lead,calendarID:original?.calendarID);a.rq2(m);dismiss()
 }.disabled(!valid).accessibilityIdentifier("save-match")}}
 .onAppear{if let m=original{home=m.home;away=m.away;venue=m.stadium;date=m.time;gate=m.gate;sector=m.sector;lead=m.lead}else{venue=a.s.stadium}}
 }
}
struct dV:View {
 @EnvironmentObject var a:eR;@Environment(\.dismiss) var dismiss;var id:String;@State var edit=false;@State var deleting=false

 #if DEBUG && targetEnvironment(simulator)
 @State private var opensScreenshotEditor = false

 init(id:String, opensScreenshotEditor:Bool = false) {
  self.id = id
  _opensScreenshotEditor = State(initialValue:ScreenshotScreen.current == .matchEditor && opensScreenshotEditor)
 }
 #endif

 var m:rM? {a.s.matches.first{$0.id==id}}
 private var plan:some View{Group{if let m {
  ScrollView{VStack(alignment:.leading,spacing:20){
   VStack(alignment:.leading,spacing:16){Text(qL("YOUR PERSONAL MATCH PLAN")).font(.caption2.bold()).tracking(1.4);Text(m.title).font(.largeTitle.bold());Label(m.venue.name,systemImage:"sportscourt.fill");Text(qF(m.time,m.venue.tz)).font(.headline);Text(m.venue.tz).font(.caption).foregroundStyle(.white.opacity(0.7));if m.time>Date(){Text(timerInterval:Date()...m.time,countsDown:true).font(.system(size:38,weight:.bold,design:.rounded)).monospacedDigit().accessibilityLabel(qL("Countdown to kickoff"))}}.padding(24).frame(maxWidth:.infinity,alignment:.leading).foregroundStyle(.white).background(nB,in:RoundedRectangle(cornerRadius:26))
   hV(title:"Your arrival",icon:"figure.walk"){Text(qF(m.arrival,m.venue.tz)).font(.title3.bold());HStack{oV(title:"Gate",value:m.gate.isEmpty ? "—":m.gate);oV(title:"Sector / seat",value:m.sector.isEmpty ? "—":m.sector)}}
   hV(title:"Keep the day in reach",icon:"bell.badge"){
    Text(qL("Add reminders the day before and at your planned arrival time.")).font(.subheadline).foregroundStyle(.secondary)
    Button{Task{await a.rqa(m)}}label:{Label(qL(m.calendarID == nil ? "Add to Apple Calendar":"Already copied to Calendar"),systemImage:"calendar.badge.plus")}.disabled(m.calendarID != nil)
    Text(qL("Calendar copies do not follow edits. Manage copies in Calendar.")).font(.caption).foregroundStyle(.secondary)
    Button{Task{await a.rqc(m)}}label:{Label(qL("Start Live Activity"),systemImage:"timer")}.accessibilityIdentifier("start-live")
    Text(qL("Start within eight hours of kickoff. The timer runs offline; system limits apply.")).font(.caption).foregroundStyle(.secondary)
   }
   Button{a.rq5("club."+m.home.lowercased(),m.home)}label:{Label(qL(a.s.favorites.contains{$0.id=="club."+m.home.lowercased() && $0.active} ? "Remove favorite club":"Favorite home club"),systemImage:"heart")}.buttonStyle(.bordered)
   Button(role:.destructive){deleting=true}label:{Label(qL("Delete match"),systemImage:"trash")}.padding(.top)
  }.padding(20).frame(maxWidth:850).frame(maxWidth:.infinity)}.background(Color(red:0.94,green:0.96,blue:0.99))
 }else{ContentUnavailableView(qL("No match selected"),systemImage:"calendar")}}.navigationTitle(qL("Match plan")).navigationBarTitleDisplayMode(.inline).toolbar{ToolbarItem(placement:.topBarTrailing){Button(qL("Edit")){edit=true}}}
 .sheet(isPresented:$edit){NavigationStack{eV(original:m)}}
 .confirmationDialog(qL("Delete this local match? Calendar copies stay in Calendar."),isPresented:$deleting,titleVisibility:.visible){Button(qL("Delete match"),role:.destructive){if let m{a.rq3(m)};dismiss()}}
 }

 var body:some View {
  #if DEBUG && targetEnvironment(simulator)
  if ScreenshotScreen.current == .matchEditor {
   plan.onAppear {
    guard opensScreenshotEditor, m != nil else { return }
    opensScreenshotEditor = false
    // Present from the restored detail on the next main-queue turn.
    DispatchQueue.main.async { edit = true }
   }
  } else {
   plan
  }
  #else
  plan
  #endif
 }
}
struct kV:View {
 @EnvironmentObject var a:eR;@State var add=false;@State var title="";@State var reset=false
 var body:some View{List{
  Section{VStack(alignment:.leading,spacing:12){Text(qL("Pack. Check. Go.")).font(.largeTitle.bold()).foregroundStyle(nB);ProgressView(value:Double(a.s.pack.filter(\.done).count),total:Double(max(1,a.s.pack.count))).tint(cB);Text("\(a.s.pack.filter(\.done).count) / \(a.s.pack.count) "+qL("ready")).font(.subheadline).foregroundStyle(.secondary)}.padding(.vertical,10)}.listRowBackground(Color.clear)
  Section(qL("Your matchday essentials")){ForEach(a.s.pack){p in Button{a.rq6(p.id)}label:{HStack(spacing:14){Image(systemName:p.done ? "checkmark.circle.fill":"circle").font(.title2).foregroundStyle(p.done ? cB:Color.secondary);Text(p.text).foregroundStyle(nB).strikethrough(p.done);Spacer()}.padding(.vertical,5)}.accessibilityIdentifier("pack-"+p.title).accessibilityValue(qL(p.done ? "Ready":"Not ready"))}.onDelete{idx in a.s.pack.remove(atOffsets:idx);a.rq0()}}
  Section{Button{add=true}label:{Label(qL("Add item"),systemImage:"plus")}.disabled(a.s.pack.count>=100);Button{reset=true}label:{Label(qL("Reset checks"),systemImage:"arrow.counterclockwise")}.disabled(a.s.pack.allSatisfy{!$0.done})}
  Section{Text(qL("Copy unfinished items to Apple Reminders. Access is requested only when you tap below.")).font(.subheadline).foregroundStyle(.secondary);Button{Task{await a.rqb()}}label:{Label(qL("Copy to Reminders"),systemImage:"checklist")};Text(qL("Deleted checklist items keep their exported copies in Reminders.")).font(.caption).foregroundStyle(.secondary)}
 }.navigationTitle(qL("Checklist")).toolbar{ToolbarItem(placement:.topBarTrailing){EditButton()}}.alert(qL("Add item"),isPresented:$add){TextField(qL("Item"),text:$title);Button(qL("Add")){let t=title.trimmingCharacters(in:.whitespacesAndNewlines);if !t.isEmpty{a.s.pack.append(pK(title:String(t.prefix(100))));a.rq0()};title=""};Button(qL("Cancel"),role:.cancel){title=""}}
 .confirmationDialog(qL("Prepare this checklist for another match?"),isPresented:$reset,titleVisibility:.visible){Button(qL("Reset checks")){for id in a.s.pack.filter(\.done).map(\.id){a.rq6(id)}}}
 }
}
struct nV:View {
 @EnvironmentObject var a:eR;@State var add=false;@State var query=""
 var rows:[hN]{a.s.notes.filter{!$0.deleted && (query.isEmpty || ($0.title+" "+$0.body).localizedCaseInsensitiveContains(query))}.sorted{$0.updated>$1.updated}}
 var body:some View{List{
  Section{Text(qL("The traditions you take with you.")).font(.title2.bold()).foregroundStyle(nB).padding(.vertical,8)}.listRowBackground(Color.clear)
  if rows.isEmpty {ContentUnavailableView(qL("Your matchday stories"),systemImage:"book.closed",description:Text(qL("Save travel notes, rituals and your own songbook.")))}
  ForEach(rows){n in NavigationLink{aV(original:n)}label:{VStack(alignment:.leading,spacing:7){Text(n.title).font(.headline);Text(n.body).lineLimit(2).font(.subheadline).foregroundStyle(.secondary);Text(qL(n.kind)+" · "+qL(uV.get(n.venue).city)).font(.caption).foregroundStyle(cB)}}.swipeActions{Button(qL("Delete"),role:.destructive){var x=n;x.deleted=true;a.rq4(x)}}}
 }.navigationTitle(qL("Journal")).searchable(text:$query,prompt:qL("Search notes")).toolbar{ToolbarItem(placement:.topBarTrailing){Button{add=true}label:{Image(systemName:"square.and.pencil")}.accessibilityLabel(qL("New note")).accessibilityIdentifier("add-note")}}.sheet(isPresented:$add){NavigationStack{aV(original:nil)}}
 }
}
struct aV:View {
 @EnvironmentObject var a:eR;@Environment(\.dismiss) var dismiss;var original:hN?
 @State var title="";@State var bodyText="";@State var kind="Ritual";@State var venue="wem"
 var body:some View{Form{Section{TextField(qL("Title"),text:$title).accessibilityIdentifier("note-title");Picker(qL("Type"),selection:$kind){ForEach(["Ritual","Songbook","Travel","General"],id:\.self){Text(qL($0)).tag($0)}};Picker(qL("Stadium"),selection:$venue){ForEach(uV.all){Text($0.name).tag($0.id)}}};Section(qL("Your words")){TextEditor(text:$bodyText).frame(minHeight:240).accessibilityLabel(qL("Note text")).accessibilityIdentifier("note-body");Text("\(bodyText.count) / 4000").font(.caption).foregroundStyle(.secondary)}}.navigationTitle(qL(original == nil ? "New note":"Edit note")).toolbar{ToolbarItem(placement:.cancellationAction){Button(qL("Cancel")){dismiss()}};ToolbarItem(placement:.confirmationAction){Button(qL("Save")){a.rq4(hN(id:original?.id ?? UUID().uuidString,title:String(title.trimmingCharacters(in:.whitespacesAndNewlines).prefix(100)),body:String(bodyText.prefix(4000)),kind:kind,venue:venue));dismiss()}.disabled(title.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || bodyText.count>4000 || (original == nil && a.s.notes.filter{!$0.deleted}.count>=100)).accessibilityIdentifier("save-note")}}.onAppear{if let n=original{title=n.title;bodyText=n.body;kind=n.kind;venue=n.venue}else{venue=a.s.stadium}}
 }
}
struct sV:View {
 @EnvironmentObject var a:eR;@Environment(\.dismiss) var dismiss
 var body:some View{Form{
  Section(qL("Weather updates")){Toggle(qL("Use MET Norway forecasts"),isOn:Binding(get:{a.s.online},set:{a.s.online=$0;a.rq0()}));Text(qL("Only stadium coordinates are sent. No device location is requested. Forecasts are cached for an hour for each match time.")).font(.caption);Text(qL("MET Norway free access is for non-commercial use. Data: CC BY 4.0. Forecasts are estimates.")).font(.caption)}
  Section(qL("Local notifications")){Text(qL("The next 24 matches are scheduled when you open the app.")).font(.caption);Text(qL("Get a reminder the day before a match and at your planned arrival. Weather notices appear only after an update. Background updates are scheduled by iOS.")).font(.subheadline);if a.s.alerts {Toggle(qL("Match reminders"),isOn:Binding(get:{a.s.alerts},set:{a.s.alerts=$0;a.rq1()}))}else{Button(qL("Enable match reminders")){Task{await a.rq7()}}};Button(qL("End Live Activities")){Task{await a.rqe()}}}
   F7634d(encode: a.prepare7634d, apply: a.accept7634d)
  Section(qL("Favorites")){let fs=a.s.favorites.filter(\.active);if fs.isEmpty{Text(qL("Save stadiums from Guide and clubs from a match plan.")).font(.subheadline).foregroundStyle(.secondary)};ForEach(fs){f in HStack{Label(f.label,systemImage:f.id.hasPrefix("club.") ? "sportscourt":"building.2");Spacer();Button{a.rq5(f.id,f.label)}label:{Image(systemName:"heart.fill")}.accessibilityLabel(qL("Remove favorite"))}}}
  Section{NavigationLink(qL("Widget previews")){wV()};NavigationLink(qL("Privacy & data")){pV()}}
  Section{Text(qL("Matchday Guide is free. No purchases, advertising or tracking.")).font(.caption);Text("1.4.2 · 10427").font(.caption2).foregroundStyle(.secondary)}
 }.navigationTitle(qL("Settings")).toolbar{ToolbarItem(placement:.confirmationAction){Button(qL("Done")){dismiss()}}}
 }
}
struct pV:View {
 var body:some View{List{
  Section(qL("On your device")){Text(qL("Plans, checklists, notes and weather caches are stored locally. Removing the app removes local data. No analytics or advertising SDKs are included."))}
  Section(qL("Optional services")){Text(qL("Weather requests send a stadium coordinate to MET Norway; the provider receives your IP address. Private iCloud sync sends only favorites and notes to your Apple account. Calendar and Reminders are accessed only after your action and permission."))}
  Section(qL("Offline first")){Text(qL("The stadium guide, checklist, notes and personal calendar work without a connection. Widgets use saved data and never request weather themselves. No official fixtures or live scores are supplied."))}
  Section(qL("Sources")){ForEach(uV.all){v in VStack(alignment:.leading,spacing:8){Text(v.name).font(.headline);Text(v.source).font(.caption).textSelection(.enabled)}};Link("Deutscher Wetterdienst · Bright Sky",destination:URL(string:"https://brightsky.dev/")!)}
 }.navigationTitle(qL("Privacy & data"))}
}
struct wV:View {
 var body:some View{ScrollView{VStack(spacing:24){Text(qL("Previews use your saved plans.")).font(.caption).foregroundStyle(.secondary);gV(x:kW.read(),family:.systemSmall).frame(width:170,height:170);gV(x:kW.read(),family:.systemMedium).frame(width:340,height:170);gV(x:kW.read(),family:.systemLarge).frame(width:340,height:360);gV(x:kW.read(),family:.accessoryRectangular).frame(width:160,height:75)}.padding(24)}.background(Color.gray.opacity(0.1)).navigationTitle(qL("Widget previews"))}
}

import UniformTypeIdentifiers

private struct F7634d:View {
 let encode:() throws -> Data
 let apply:(Data) throws -> Void
 @Environment(\.locale) private var language
 @State private var exporting=false
 @State private var importing=false
 @State private var document:Envelope?
 @State private var status=""
 private var labels:[String] {
  let words:[String:[String]]=["en":["Export file","Import file","File imported"],"de":["Datei exportieren","Datei importieren","Datei importiert"],"fr":["Exporter un fichier","Importer un fichier","Fichier importé"],"es":["Exportar archivo","Importar archivo","Archivo importado"],"pt":["Exportar arquivo","Importar arquivo","Arquivo importado"],"it":["Esporta file","Importa file","File importato"],"ru":["Экспортировать файл","Импортировать файл","Файл импортирован"]]
  return words[language.language.languageCode?.identifier ?? "en"] ?? words["en"]!
 }
 private struct Envelope:FileDocument {
  static var readableContentTypes:[UTType]{[.json]}
  let contents:Data
  init(contents:Data){self.contents=contents}
  init(configuration:ReadConfiguration)throws{guard let data=configuration.file.regularFileContents else{throw CocoaError(.fileReadCorruptFile)};contents=data}
  func fileWrapper(configuration:WriteConfiguration)throws->FileWrapper{FileWrapper(regularFileWithContents:contents)}
 }
 var body:some View {
  VStack(alignment:.leading,spacing:12){
   Button {do {let payload=try encode();let obj=try JSONSerialization.jsonObject(with:payload,options:[.fragmentsAllowed])
    document=Envelope(contents:try JSONSerialization.data(withJSONObject:["format":"org.terracemap.d72b6e/1","payload":obj]));status="";exporting=true
   }catch{status=error.localizedDescription}} label:{Label(labels[0],systemImage:"square.and.arrow.up")}.buttonStyle(.borderless)
   Button {importing=true} label:{Label(labels[1],systemImage:"square.and.arrow.down")}.buttonStyle(.borderless)
   if !status.isEmpty{Text(status).font(.footnote).foregroundStyle(.secondary)}
  }.fileExporter(isPresented:$exporting,document:document,contentType:.json,defaultFilename:"Matchday Guide - Records"){
   if case .failure(let error)=$0{status=error.localizedDescription}
  }.fileImporter(isPresented:$importing,allowedContentTypes:[.json]){
   do {let url=try $0.get();let scoped=url.startAccessingSecurityScopedResource();defer{if scoped{url.stopAccessingSecurityScopedResource()}}
    guard let size=try url.resourceValues(forKeys:[.fileSizeKey]).fileSize,size>0,size<100_000_000 else{throw CocoaError(.fileReadTooLarge)}
    let raw=try JSONSerialization.jsonObject(with:Data(contentsOf:url))
    guard let envelope=raw as? [String:Any],envelope["format"] as? String=="org.terracemap.d72b6e/1",let payload=envelope["payload"] else{throw CocoaError(.fileReadCorruptFile)}
    try apply(JSONSerialization.data(withJSONObject:payload,options:[.fragmentsAllowed]));status=labels[2]
   }catch{status=error.localizedDescription}
  }
 }
}
