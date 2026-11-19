import Foundation
import ActivityKit

let qG = "group.org.terracemap.d72b6e"
let qC = "iCloud.org.terracemap.d72b6e"
func qL(_ s:String)->String {
 #if DEBUG && targetEnvironment(simulator) && !TERRACE_WIDGET
 if ScreenshotScreen.current != nil, let bundle = ScreenshotScreen.localizationBundle {
  return bundle.localizedString(forKey:s,value:nil,table:nil)
 }
 #endif
 return NSLocalizedString(s, comment: "")
}

func qF(_ d:Date,_ tz:String? = nil)->String {
 let f=DateFormatter()
 #if DEBUG && targetEnvironment(simulator) && !TERRACE_WIDGET
 if ScreenshotScreen.current != nil { f.locale = ScreenshotScreen.locale }
 #endif
 f.dateStyle = .medium
 f.timeStyle = .short
 if let tz { f.timeZone=TimeZone(identifier:tz) }
 return f.string(from:d)
}

func qD(_ d:Date,_ tz:String)->String {
 let f=DateFormatter()
 #if DEBUG && targetEnvironment(simulator) && !TERRACE_WIDGET
 if ScreenshotScreen.current != nil { f.locale = ScreenshotScreen.locale }
 #endif
 f.dateStyle = .medium
 f.timeStyle = .none
 f.timeZone=TimeZone(identifier:tz)
 return f.string(from:d)
}

struct uV: Identifiable, Codable, Equatable {
 var id:String; var name:String; var city:String; var tz:String; var lat:Double; var lon:Double; var opened:Int; var transit:String; var history:String; var source:String
 var sectors:String {id+".sectors"}
 static let all:[uV] = [
 .init(id:"wem",name:"Wembley Stadium",city:"London",tz:"Europe/London",lat:51.556,lon:-0.2796,opened:2007,transit:"wem.travel",history:"wem.history",source:"https://www.wembleystadium.com/plan-your-visit/getting-to-wembley"),
 .init(id:"oly",name:"Olympiastadion Berlin",city:"Berlin",tz:"Europe/Berlin",lat:52.5147,lon:13.2395,opened:1936,transit:"oly.travel",history:"oly.history",source:"https://olympiastadion.berlin/en/directions/"),
 .init(id:"sdf",name:"Stade de France",city:"Saint-Denis",tz:"Europe/Paris",lat:48.9244,lon:2.3601,opened:1998,transit:"sdf.travel",history:"sdf.history",source:"https://www.stadefrance.com/en/practical-information/how-to-get-there")]
 static func get(_ s:String)->uV { all.first{$0.id==s} ?? all[0] }
}
struct pK:Codable,Identifiable,Equatable {
 var id:String=UUID().uuidString; var title:String; var localized:Bool=false; var done:Bool=false; var reminder:String?=nil
 var text:String { localized ? qL(title):title }
 static var defaults:[pK] { ["Admission pass","Scarf","Charged phone","Travel card","Water","Weather layer"].map{pK(title:$0,localized:true)} }
}
struct rM:Codable,Identifiable,Equatable {
 var id:String=UUID().uuidString; var home:String; var away:String; var stadium:String; var time:Date; var gate:String=""; var sector:String=""; var lead:Int=90; var calendarID:String?=nil
 var title:String { home+" · "+away }
 var venue:uV { uV.get(stadium) }
 var arrival:Date { time.addingTimeInterval(Double(-lead*60)) }
 func xg(_ d:Date)->Bool {let c=Calendar.current;let a=c.dateComponents([.year,.month,.day],from:d);var v=c;v.timeZone=TimeZone(identifier:venue.tz) ?? .current;let b=v.dateComponents([.year,.month,.day],from:time);return a.year==b.year && a.month==b.month && a.day==b.day}
}
struct hN:Codable,Identifiable,Equatable {
 var id:String=UUID().uuidString; var title:String; var body:String; var kind:String; var venue:String; var updated:Date=Date(); var deleted:Bool=false
}
struct zF:Codable,Identifiable,Equatable {
 var id:String; var label:String; var active:Bool; var updated:Date=Date()
}
struct wQ:Codable,Equatable {
 var venue:String; var target:Date; var fetched:Date; var temperature:Double; var rain:Double?; var wind:Double; var code:Int;var station:String?=nil
 var xv:Bool { temperature.isFinite && wind.isFinite && (-100.0...70.0).contains(temperature) && (rain.map{(0.0...100.0).contains($0)} ?? true) && (0.0...500.0).contains(wind) }
 var stale:Bool { Date().timeIntervalSince(fetched)>21600 }
 var symbol:String { switch code { case -1:return "thermometer.medium";case 68:return "cloud.sleet.fill";case 0: return "sun.max.fill"; case 1...3:return "cloud.sun.fill"; case 45,48:return "cloud.fog.fill"; case 71...77,85,86:return "cloud.snow.fill"; case 95...99:return "cloud.bolt.rain.fill"; default:return "cloud.rain.fill" } }
}
struct xS:Codable {
 var matches:[rM]=[]; var pack:[pK]=pK.defaults; var notes:[hN]=[]; var favorites:[zF]=[]; var stadium:String="wem"; var weather:[String:wQ]=[:]; var alerts:Bool=false; var cloud:Bool=false; var online:Bool=false
 var next:rM? { matches.filter{$0.time>Date()}.sorted{$0.time<$1.time}.first }
}
struct kW:Codable {
 var stadiumID:String="wem"; var venue:String="Wembley Stadium"; var city:String="London"; var tz:String="Europe/London"; var match:rM?=nil; var season:[rM]=[]; var pack:[pK]=[]; var weather:wQ?=nil; var made:Date=Date()
 static var file:URL? { FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:qG)?.appendingPathComponent("glance.json") }
 static func read()->kW { guard let f=file,let d=try? Data(contentsOf:f),var s=try? JSONDecoder().decode(kW.self,from:d) else{return kW()}; if s.weather?.xv == false{s.weather=nil};return s }
}
struct fA:ActivityAttributes {
 struct ContentState:Codable,Hashable { var end:Date; var start:Date }
 var matchID:String; var title:String; var venue:String
}
struct cY:Codable { var notes:[hN]; var favorites:[zF] }
