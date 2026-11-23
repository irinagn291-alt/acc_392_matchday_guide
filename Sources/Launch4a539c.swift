import SwiftUI
import Combine
#if DEBUG && targetEnvironment(simulator)
import UIKit
#endif

let nB=Color(red:0.043,green:0.122,blue:0.227)
let cB=Color(red:0.145,green:0.388,blue:0.922)
let iB=Color(red:0.22,green:0.74,blue:0.97)

@main struct vU:App {
 @UIApplicationDelegateAdaptor(tB.self) var d
 @StateObject private var a:eR
 @Environment(\.scenePhase) var phase

 @MainActor init() {
  #if DEBUG && targetEnvironment(simulator)
  if let screen = ScreenshotScreen.current {
   UIView.setAnimationsEnabled(false)
   _a = StateObject(wrappedValue:eR(screenshotState:screen.demoState()))
   return
  }
  #endif
  _a = StateObject(wrappedValue:eR.rZ)
 }

 @ViewBuilder private var root:some View {
  #if DEBUG && targetEnvironment(simulator)
  if let screen = ScreenshotScreen.current {
   bV(screenshot:screen, state:a.s)
    .environment(\.locale, ScreenshotScreen.locale)
    .transaction { $0.disablesAnimations = true }
  } else {
   bV()
  }
  #else
  bV()
  #endif
 }

 var body:some Scene {WindowGroup{
   WebsiteGate {
    root.environmentObject(a).tint(cB).preferredColorScheme(.light).onReceive(Timer.publish(every:60,on:.main,in:.common).autoconnect()){_ in if phase == .active {a.objectWillChange.send()}}.onChange(of:phase){_,p in if p == .background {a.rqg()};if p == .active {Task{await a.rqd();await a.rq8()}}}
   }
  }}
}
struct bV:View {
 @EnvironmentObject var a:eR
 @State var tab=0;@State var settings=false

 #if DEBUG && targetEnvironment(simulator)
 private var screenshot:ScreenshotScreen? = nil
 @State private var matchPath:[String] = []
 @State private var notePath:[String] = []

 init(screenshot:ScreenshotScreen, state:xS) {
  self.screenshot = screenshot
  _tab = State(initialValue:screenshot.tab)
  switch screenshot {
  case .matchPlan, .matchEditor:
   _matchPath = State(initialValue:state.matches.prefix(1).map(\.id))
  case .noteEditor:
   _notePath = State(initialValue:state.notes.prefix(1).map(\.id))
  default:
   break
  }
 }
 #endif

 init() {}

 @ViewBuilder private var guide:some View {
  #if DEBUG && targetEnvironment(simulator)
  if screenshot == .stadiumMap {
   jV(expanded:true, side:1)
  } else {
   jV()
  }
  #else
  jV()
  #endif
 }

 @ViewBuilder private var matchdays:some View {
  #if DEBUG && targetEnvironment(simulator)
  if screenshot == .matchPlan || screenshot == .matchEditor {
   NavigationStack(path:$matchPath) {
    mV().navigationDestination(for:String.self) { id in
     dV(id:id, opensScreenshotEditor:screenshot == .matchEditor)
    }
   }
  } else {
   NavigationStack{mV()}
  }
  #else
  NavigationStack{mV()}
  #endif
 }

 @ViewBuilder private var journal:some View {
  #if DEBUG && targetEnvironment(simulator)
  if screenshot == .noteEditor {
   NavigationStack(path:$notePath) {
    nV().navigationDestination(for:String.self) { id in
     if let note = a.s.notes.first(where:{$0.id == id && !$0.deleted}) {
      aV(original:note)
     }
    }
   }
  } else {
   NavigationStack{nV()}
  }
  #else
  NavigationStack{nV()}
  #endif
 }

 var body:some View {
  TabView(selection:$tab){
   NavigationStack{guide.toolbar{ToolbarItem(placement:.topBarTrailing){Button{settings=true}label:{Image(systemName:"slider.horizontal.3")}.accessibilityLabel(qL("Settings")).accessibilityIdentifier("settings")}}}.tabItem{Label(qL("Guide"),systemImage:"map")}.tag(0)
   matchdays.tabItem{Label(qL("Matchdays"),systemImage:"calendar")}.tag(1)
   NavigationStack{kV()}.tabItem{Label(qL("Checklist"),systemImage:"checklist")}.tag(2)
   journal.tabItem{Label(qL("Journal"),systemImage:"book.closed")}.tag(3)
  }.sheet(isPresented:$settings){NavigationStack{sV()}.environmentObject(a)}
  .alert(qL("Matchday Guide"),isPresented:Binding(get:{a.message != nil},set:{if !$0{a.message=nil}})){Button(qL("OK")){a.message=nil}}message:{Text(a.message ?? "")}
  .onWebsiteAppLink{u in if u.scheme == "terracemap" {switch u.host {case "checklist":tab=2;case "matches":tab=1;case "journal":tab=3;default:tab=0}}}
 }
}

#if DEBUG && targetEnvironment(simulator)
enum ScreenshotScreen:String, CaseIterable {
 // The order matches the factory's zero-based App Store screenshot indices.
 case stadiumGuide = "stadium-guide"
 case stadiumMap = "stadium-map"
 case homeSeason = "home-season"
 case matchPlan = "match-plan"
 case packingChecklist = "packing-checklist"
 case journal
 case matchEditor = "match-editor"
 case noteEditor = "note-editor"

 static let locale = Locale(identifier:"en")
 static let localizationBundle = Bundle.main.url(forResource:"en",withExtension:"lproj")
  .flatMap { Bundle(url:$0) }

 static let current:ScreenshotScreen? = {
  let process = ProcessInfo.processInfo
  let arguments = process.arguments
  let environment = process.environment

  func value(after flag:String) -> String? {
   guard let position = arguments.firstIndex(of:flag), position + 1 < arguments.count else { return nil }
   return arguments[position + 1]
  }

  if arguments.contains("-ReviewScreen") {
   return value(after:"-ReviewScreen").flatMap { ScreenshotScreen(rawValue:$0) }
  }
  let environmentEnabled = ["1", "true"].contains(environment["APPSTORE_SCREENSHOTS"]?.lowercased() ?? "")
  guard arguments.contains("-AppStoreScreenshots") || environmentEnabled else { return nil }
  let selection = value(after:"-AppStoreScreenshotScreen") ?? environment["APPSTORE_SCREENSHOT_SCREEN"] ?? "0"
  guard let index = Int(selection), allCases.indices.contains(index) else { return nil }
  return allCases[index]
 }()

 var tab:Int {
  switch self {
  case .stadiumGuide, .stadiumMap: return 0
  case .homeSeason, .matchPlan, .matchEditor: return 1
  case .packingChecklist: return 2
  case .journal, .noteEditor: return 3
  }
 }

 func demoState(now:Date = Date()) -> xS {
  var state = xS()
  switch self {
  case .stadiumGuide:
   let venue = uV.get("wem")
   state.stadium = venue.id
   state.favorites = [zF(id:"venue." + venue.id, label:venue.name, active:true, updated:now)]
  case .stadiumMap:
   state.stadium = "oly"
  case .homeSeason, .matchPlan, .matchEditor:
   let kickoff = now.addingTimeInterval(2 * 3600)
   state.matches = [rM(home:"Northside FC", away:"Riverside Athletic", stadium:"wem", time:kickoff,
                       gate:"Gate C", sector:"Block 112 · Row 18 · Seat 24", lead:90)]
   if self == .homeSeason {
    state.matches.append(rM(home:"East Borough", away:"Union Park", stadium:"oly", time:kickoff.addingTimeInterval(7 * 86400)))
    state.matches.append(rM(home:"Saint-Denis Sporting", away:"Canal City", stadium:"sdf", time:kickoff.addingTimeInterval(14 * 86400)))
   }
  case .packingChecklist:
   let ready = ["Admission pass", "Scarf", "Charged phone", "Travel card"]
   for index in state.pack.indices {
    state.pack[index].done = ready.contains(state.pack[index].title)
   }
   state.pack.append(pK(title:"Portable battery"))
  case .journal, .noteEditor:
   let meetingPoint = "Meet by the station clock 90 minutes before kickoff. Bring the blue scarf."
   if self == .journal {
    state.notes = [
     hN(title:"Return train plan", body:"Check the last RER before leaving and agree on a backup route.", kind:"Travel", venue:"sdf", updated:now.addingTimeInterval(-120)),
     hN(title:"Our terrace chorus", body:"Blue scarves high, we sing together until the final whistle.", kind:"Songbook", venue:"oly", updated:now.addingTimeInterval(-60)),
     hN(title:"Our meeting point", body:meetingPoint, kind:"Ritual", venue:"wem", updated:now)
    ]
   } else {
    state.notes = [hN(title:"Our meeting point", body:meetingPoint + " After the match, regroup outside Wembley Park before heading home.",
                      kind:"Ritual", venue:"wem", updated:now)]
   }
  }
  return state
 }
}
#endif

struct hV<Z:View>:View {
 var title:String;var icon:String;@ViewBuilder var content:()->Z
 var body:some View {VStack(alignment:.leading,spacing:14){Label(qL(title),systemImage:icon).font(.headline).foregroundStyle(nB);content()}.padding(20).frame(maxWidth:.infinity,alignment:.leading).background(.white,in:RoundedRectangle(cornerRadius:24))}
}
struct oV:View {
 var title:String;var value:String;var body:some View{VStack(alignment:.leading,spacing:5){Text(qL(title)).font(.caption).foregroundStyle(.secondary);Text(value).font(.subheadline.weight(.semibold)).foregroundStyle(nB)}.frame(maxWidth:.infinity,alignment:.leading)}
}
struct jV:View {
 @EnvironmentObject var a:eR;@State var expanded=false;@State var side=0
 var v:uV {uV.get(a.s.stadium)}
 var body:some View{
  ScrollView{
   VStack(alignment:.leading,spacing:22){
    HStack(alignment:.bottom){VStack(alignment:.leading,spacing:5){Text(qL("YOUR NEXT GREAT DAY")).font(.caption2.weight(.bold)).tracking(2).foregroundStyle(cB);Text(qL("Matchday starts here.")).font(.system(size:34,weight:.bold,design:.rounded)).foregroundStyle(nB)};Spacer()}.padding(.top,8)
    VStack(alignment:.leading,spacing:8){
     HStack{Label(qL("OFFLINE STADIUM GUIDE"),systemImage:"checkmark.seal.fill").font(.caption2.weight(.bold)).tracking(1);Spacer();Button{a.rq5("venue."+v.id,v.name)}label:{Image(systemName:a.s.favorites.contains{$0.id=="venue."+v.id && $0.active} ? "heart.fill":"heart").font(.title3)}.accessibilityLabel(qL("Favorite stadium"))}
     zV(side:side).frame(height:170).accessibilityLabel(qL("Stadium orientation sketch"))
     HStack(alignment:.bottom){VStack(alignment:.leading,spacing:5){Text(v.name).font(.title2.bold());Text(qL(v.city)+" · "+qL("Opened")+" \(v.opened.formatted(.number.grouping(.never)))").font(.subheadline).foregroundStyle(.white.opacity(0.75))};Spacer();Button{expanded=true}label:{Image(systemName:"arrow.up.left.and.arrow.down.right").padding(12).background(.white.opacity(0.16),in:Circle())}.accessibilityLabel(qL("Expand stadium map"))}
    }.padding(22).foregroundStyle(.white).background(LinearGradient(colors:[nB,Color(red:0.07,green:0.26,blue:0.55)],startPoint:.topLeading,endPoint:.bottomTrailing),in:RoundedRectangle(cornerRadius:28))
    ScrollView(.horizontal,showsIndicators:false){HStack(spacing:10){ForEach(uV.all){x in Button{a.s.stadium=x.id;a.rq0()}label:{VStack(alignment:.leading,spacing:3){Text(qL(x.city)).font(.subheadline.bold());Text(x.name).font(.caption).lineLimit(1)}.padding(.horizontal,16).padding(.vertical,12).foregroundStyle(a.s.stadium==x.id ? .white:nB).background(a.s.stadium==x.id ? cB:Color.white,in:RoundedRectangle(cornerRadius:16))}.buttonStyle(.plain).accessibilityIdentifier("venue-"+x.id)}}}
    ViewThatFits(in:.horizontal){HStack(alignment:.top,spacing:18){route.frame(minWidth:310);weather.frame(minWidth:280)};VStack(spacing:18){route;weather}}
    hV(title:"Find your side",icon:"square.dashed"){Picker(qL("Stadium side"),selection:$side){ForEach(0..<4){i in Text(qL(["North","East","South","West"][i])).tag(i)}}.pickerStyle(.segmented);Text(qL("Orientation only. Use the gate and sector printed on your pass.")).font(.subheadline).foregroundStyle(.secondary);Divider();Text(qL("Read your sector")).font(.subheadline.bold());Text(qL(v.sectors)).font(.subheadline).foregroundStyle(.secondary)}
    HStack{Text(qL("Make it your matchday")).font(.title3.bold()).foregroundStyle(nB);Spacer()}
    ViewThatFits(in:.horizontal){HStack(alignment:.top,spacing:18){history.frame(minWidth:310);ritual.frame(minWidth:280)};VStack(spacing:18){history;ritual}}
    Text(qL("Guide checked November 2026. Transport and entry arrangements can change. Follow venue staff on the day.")).font(.caption).foregroundStyle(.secondary)
   }.padding(20).frame(maxWidth:1000).frame(maxWidth:.infinity)
  }.background(Color(red:0.94,green:0.96,blue:0.99)).navigationTitle(qL("Matchday Guide")).navigationBarTitleDisplayMode(.inline)
  .sheet(isPresented:$expanded){NavigationStack{ScrollView{VStack(spacing:24){Text(v.name).font(.title.bold());zV(side:side).frame(height:320).padding(24).background(nB,in:RoundedRectangle(cornerRadius:28));Picker(qL("Stadium side"),selection:$side){ForEach(0..<4){i in Text(qL(["North","East","South","West"][i])).tag(i)}}.pickerStyle(.segmented);Text(qL("Orientation only. Use the gate and sector printed on your pass."));Text(qL(v.transit));Text(qL("Read your sector")).font(.headline);Text(qL(v.sectors))}.padding(24).frame(maxWidth:900)}.navigationTitle(qL("Stadium map")).toolbar{ToolbarItem(placement:.confirmationAction){Button(qL("Done")){expanded=false}}}}}
 }
 var route:some View {hV(title:"Getting there",icon:"tram.fill"){Text(qL(v.transit)).font(.subheadline).lineSpacing(5);Label(qL("Allow extra time after the match."),systemImage:"clock").font(.caption).foregroundStyle(.secondary)}}
 var history:some View {hV(title:"A place with a story",icon:"building.2.crop.circle"){Text(qL(v.history)).font(.subheadline).lineSpacing(5);Text(v.source).font(.caption2).foregroundStyle(.secondary).textSelection(.enabled)}}
 var ritual:some View {hV(title:"Rituals & songbook",icon:"music.note.list"){Text(qL("Meet your group before entering. Pick a meeting point for the journey home.")).font(.subheadline);Text(qL("Original fan verse")).font(.caption.weight(.bold)).foregroundStyle(cB);Text(qL("Together we rise, together we sing.\nOne crowd, one day, let our voices ring.")).font(.system(.body,design:.serif)).italic();Text(qL("Keep your own verses and traditions in Journal.")).font(.caption).foregroundStyle(.secondary)}}
 var weather:some View {hV(title:"Stadium weather",icon:"cloud.sun.fill"){
  let target=a.s.matches.filter{$0.stadium==v.id && $0.time>Date()}.sorted{$0.time<$1.time}.first?.time ?? Date()
  if let w=a.s.weather[v.id],abs(w.target.timeIntervalSince(target))<3700 {
   HStack{Image(systemName:w.symbol).symbolRenderingMode(.multicolor).font(.largeTitle);Text("\(Int(w.temperature.rounded()))°C").font(.system(size:36,weight:.bold,design:.rounded));Spacer()}
   HStack{oV(title:"Rain",value:w.rain.map{"\(Int($0))%"} ?? "—");oV(title:"Wind",value:"\(Int(w.wind)) km/h")}
   Text(w.station.map{"Deutscher Wetterdienst · "+$0} ?? "MET Norway · CC BY 4.0").font(.caption).foregroundStyle(.secondary);Text(qL("Forecast for")+" "+qF(w.target,v.tz)).font(.caption);Text(qL(w.stale ? "Saved forecast · may be out of date":"Updated")+" "+qF(w.fetched)).font(.caption).foregroundStyle(.secondary)
  }else {Text(qL("No saved forecast")).font(.headline);Text(qL("Optional forecasts cover the next 15 days. Your stadium guide is always available.")).font(.subheadline).foregroundStyle(.secondary)}
  Button{Task{_ = await a.rq9(v)}}label:{Label(qL(a.busy ? "Updating…":"Refresh weather"),systemImage:"arrow.clockwise")}.disabled(a.busy).font(.subheadline.bold())
  Text("MET Norway · CC BY 4.0").font(.caption2).foregroundStyle(.secondary)
 }}
}
struct zV:View {
 var side:Int=0
 var body:some View {GeometryReader{g in let w=g.size.width;let h=g.size.height
  ZStack{
   RoundedRectangle(cornerRadius:30).stroke(Color.white.opacity(0.2),lineWidth:26).padding(20)
   if side==1 {RoundedRectangle(cornerRadius:30).trim(from:0.887,to:1).stroke(iB,lineWidth:26).padding(20);RoundedRectangle(cornerRadius:30).trim(from:0,to:0.113).stroke(iB,lineWidth:26).padding(20)}else{let a:CGFloat = [0.625,0,0.125,0.375][side];RoundedRectangle(cornerRadius:30).trim(from:a+0.012,to:a+0.238).stroke(iB,lineWidth:26).padding(20)}
   RoundedRectangle(cornerRadius:8).fill(Color(red:0.13,green:0.55,blue:0.54)).frame(width:w*0.52,height:h*0.50)
   RoundedRectangle(cornerRadius:2).stroke(.white.opacity(0.7),lineWidth:1.2).frame(width:w*0.46,height:h*0.40)
   Path{p in p.move(to:CGPoint(x:w/2,y:h*0.30));p.addLine(to:CGPoint(x:w/2,y:h*0.70))}.stroke(.white.opacity(0.65),lineWidth:1)
   Circle().stroke(.white.opacity(0.7),lineWidth:1).frame(width:h*0.15,height:h*0.15)
   VStack{Text(qL("N")).font(.caption2.bold());Spacer();Text(qL("S")).font(.caption2.bold())}.padding(.vertical,4).foregroundStyle(.white)
   HStack{Text(qL("W")).font(.caption2.bold());Spacer();Text(qL("E")).font(.caption2.bold())}.padding(.horizontal,5).foregroundStyle(.white)
  }
 }}
}
