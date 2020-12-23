//
//  ContentView.swift
//  api to coredata
//
//  Created by addin on 23/12/20.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: HaditsDB.entity(), sortDescriptors: []) var hadits: FetchedResults<HaditsDB>
    @ObservedObject var net = Networking()
    
    var body: some View {
        NavigationView {
            List {
            ForEach(hadits) { h in
                Text(h.terjemah!)
            }.onDelete(perform: deleteItems)
            }
            .navigationBarItems(trailing: Button("test") { print(hadits)})
            .onAppear {
                net.getHadits()
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5)  {
                    
                    for h in net.hadits {
                        let haditss = HaditsDB(context: self.moc)
                        haditss.id = h.id
                        haditss.haditsId = h.haditsId
                        haditss.nass = h.nass
                        haditss.terjemah = h.terjemah
                        try? self.moc.save()
                    
                }
                    
                }
            }
        }
    }
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let h = hadits[index]
            moc.delete(h)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Networking: ObservableObject  {
    
    @Environment(\.managedObjectContext) var moc
    @Published var hadits = [Hadits]()
    
    func getHadits() {
        let id = 1...5
        for i in id {
            let url = "http://api.carihadis.com/?kitab=Shahih_Bukhari&id=\(i)"
            AF.request(url)
                .responseDecodable(of: HaditsContainer.self) { response in
                    guard let data = response.value else { return }
                    let h = data.data.the1
                    let newHadits = Hadits(haditsId: String(i), nass: h.nass, terjemah: h.terjemah)
                    self.hadits.append(newHadits)
                    
                    
                }
            print("get hadits")
            
            
            
        }
        
        
        
    }
    
}


