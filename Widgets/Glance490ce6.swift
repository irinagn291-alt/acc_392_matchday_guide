import SwiftUI
import WidgetKit
import ActivityKit

struct vE:TimelineEntry {var date:Date;var x:kW}
struct yP:TimelineProvider {
 func placeholder(in context:Context)->vE {vE(date:Date(),x:kW())}
 func getSnapshot(in context:Context,completion:@escaping(vE)->Void){completion(vE(date:Date(),x:kW.read()))}
 func getTimeline(in context:Context,completion:@escaping(Timeline<vE>)->Void){
  let x=kW.read();let now=Date();var ds=[now,now.addingTimeInterval(3600)]
  for m in x.season.prefix(12) where m.time>now {ds.append(m.time);ds.append(m.time.addingTimeInterval(1))}
  let entries=ds.sorted().map{date -> vE in var z=x;z.season=x.season.filter{$0.time>date};z.match=x.season.filter{$0.time>date}.sorted{$0.time<$1.time}.first;if let m=z.match{z.stadiumID=m.stadium;z.venue=m.venue.name;z.city=m.venue.city;z.tz=m.venue.tz;if z.weather?.venue != m.stadium || abs((z.weather?.target ?? .distantPast).timeIntervalSince(m.time))>3700{z.weather=nil}}else{z.weather=nil};return vE(date:date,x:z)}
  completion(Timeline(entries:entries,policy:.after(now.addingTimeInterval(3600))))
 }
}
struct gV:View {
 var x:kW;var family:WidgetFamily;var at:Date=Date()
 private let b=Color(red:0.043,green:0.122,blue:0.227)
 private let c=Color(red:0.145,green:0.388,blue:0.922)
 var sameDay:Bool {guard let m=x.match else{return false};var cal=Calendar(identifier:.gregorian);cal.timeZone=TimeZone(identifier:x.tz) ?? .current;return cal.isDate(m.time,inSameDayAs:at)}
 var body:some View{
  Group{switch family {
   case .accessoryInline: if let m=x.match{Text(qL("Kickoff")+" "+m.time.formatted(date:.omitted,time:.shortened))}else{Text(qL("Add a home match"))}
   case .accessoryCircular:VStack{Image(systemName:"sportscourt");if let m=x.match{Text(m.time,style:.relative).font(.caption2).minimumScaleFactor(0.6)}else{Text("—")}}
   case .accessoryRectangular:VStack(alignment:.leading,spacing:4){Label(qL("Next kickoff"),systemImage:"timer").font(.caption2.bold());if let m=x.match{Text(m.title).font(.caption).lineLimit(1);Text(m.time,style:.relative).font(.headline).monospacedDigit()}else{Text(qL("Add a home match")).font(.caption)}}
   case .systemSmall:VStack(alignment:.leading,spacing:8){Label(qL("Match weather"),systemImage:"cloud.sun").font(.caption2.bold()).foregroundStyle(c);Text(x.venue).font(.caption.weight(.semibold)).lineLimit(2);if sameDay,let w=x.weather{HStack{Image(systemName:w.symbol).symbolRenderingMode(.multicolor);Text("\(Int(w.temperature.rounded()))°C").font(.title.bold())};Text(qL(w.stale ? "Saved forecast":"Updated")+" "+w.fetched.formatted(date:.omitted,time:.shortened)).font(.system(size:9));Text("MET Norway · CC BY 4.0").font(.system(size:8))}else{Spacer(minLength:0);Image(systemName:"cloud.sun").font(.title).foregroundStyle(c);Text(qL(sameDay ? "No saved forecast":"Weather on matchday")).font(.caption);Spacer(minLength:0)}}.padding(14).frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading).background(.white).foregroundStyle(b)
   default: VStack(alignment:.leading,spacing:family == .systemLarge ? 9:10){
    HStack{Label(qL("NEXT HOME MATCH"),systemImage:"sportscourt.fill").font(.system(size:10,weight:.bold)).foregroundStyle(c);Spacer();Text("\(x.pack.filter(\.done).count)/\(x.pack.count)").font(.caption2.bold()).foregroundStyle(.secondary)}
    if let m=x.match {Text(m.title).font(.headline).lineLimit(1);Text(qF(m.time,m.venue.tz)).font(.caption).foregroundStyle(.secondary)}else{Text(qL("Your season starts with a plan.")).font(.headline);Text(qL("Add a home match")).font(.caption).foregroundStyle(.secondary)}
    HStack(spacing:10){ForEach(Array(x.pack.filter{!$0.done}.prefix(2))){p in Label(p.text,systemImage:"circle").font(.caption2).lineLimit(1)}}
    if family == .systemLarge {
     Divider();Text(qL("Season ahead")).font(.caption.bold()).foregroundStyle(c)
     ForEach(Array(x.season.filter{$0.time>at}.prefix(3))){m in HStack{Text(m.home).lineLimit(1);Spacer();Text(qD(m.time,m.venue.tz)).foregroundStyle(.secondary)}.font(.caption)}
     Spacer(minLength:0);HStack{Image(systemName:"mappin.circle.fill").font(.title).foregroundStyle(c);VStack(alignment:.leading,spacing:4){Text(x.venue).font(.caption.bold());Text(qL(uV.get(x.stadiumID).transit)).font(.caption2).lineLimit(2)}}
     if let w=x.weather{HStack{Image(systemName:w.symbol);Text("\(Int(w.temperature.rounded()))°C");Text(qL(w.stale ? "Saved forecast":"Updated")+" "+w.fetched.formatted(date:.omitted,time:.shortened)).font(.caption2)}.font(.caption);Text("MET Norway · CC BY 4.0").font(.system(size:8))}
    }
   }.padding(16).frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading).background(.white).foregroundStyle(b)
  }}.clipShape(RoundedRectangle(cornerRadius:family == .systemSmall || family == .systemMedium || family == .systemLarge ? 20:0))
 }
}
struct jW:Widget {
 var body:some WidgetConfiguration{StaticConfiguration(kind:"terrace.saved",provider:yP()){e in fV(x:e.x,at:e.date).containerBackground(.white,for:.widget)}.configurationDisplayName(qL("Matchday Guide")).description(qL("Your home season, checklist and saved weather.")).supportedFamilies([.systemSmall,.systemMedium,.systemLarge,.accessoryInline,.accessoryCircular,.accessoryRectangular]).contentMarginsDisabled()}
}
struct fV:View {@Environment(\.widgetFamily) var f;var x:kW;var at:Date;var body:some View{gV(x:x,family:f,at:at).widgetURL(URL(string:"terracemap://matches"))}}
struct lW:Widget {
 var body:some WidgetConfiguration{ActivityConfiguration(for:fA.self){context in
  HStack(spacing:16){Image(systemName:"sportscourt.fill").font(.largeTitle).foregroundStyle(.cyan);VStack(alignment:.leading,spacing:6){Text(context.attributes.title).font(.headline).lineLimit(1);Text(context.attributes.venue).font(.caption).lineLimit(1);Text(qL("Kickoff countdown")).font(.caption2)};Spacer();Text(timerInterval:context.state.start...max(context.state.start,context.state.end),countsDown:true).font(.title2.bold()).monospacedDigit().frame(maxWidth:130)}.padding(20).activityBackgroundTint(Color(red:0.043,green:0.122,blue:0.227)).activitySystemActionForegroundColor(.white).foregroundStyle(.white).widgetURL(URL(string:"terracemap://matches"))
 } dynamicIsland:{context in DynamicIsland {
  DynamicIslandExpandedRegion(.leading){Image(systemName:"sportscourt.fill").foregroundStyle(.cyan)}
  DynamicIslandExpandedRegion(.trailing){Text(timerInterval:context.state.start...max(context.state.start,context.state.end),countsDown:true).monospacedDigit().frame(width:100)}
  DynamicIslandExpandedRegion(.bottom){VStack{Text(context.attributes.title).font(.headline);Text(context.attributes.venue).font(.caption)}}
 } compactLeading:{Image(systemName:"sportscourt.fill").foregroundStyle(.cyan)} compactTrailing:{Text(timerInterval:context.state.start...max(context.state.start,context.state.end),countsDown:true).monospacedDigit().frame(width:65)} minimal:{Image(systemName:"timer").foregroundStyle(.cyan)}.widgetURL(URL(string:"terracemap://matches"))}
 }
}
#if TERRACE_WIDGET
@main struct aW:WidgetBundle {var body:some Widget{jW();lW()}}
#endif
