import Foundation

class TWStationsParser {

    func parse(_ data: Data) -> [TWStation] {
        var stations = [TWStation]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let list = json as? [String: Any] {
                if let items = list["stations"] as? [Any] {
                    for station in items {
                        guard let info = station as? [String:Any] else { continue }

                        guard let id = info["id"] as? Int,
                                let name = info["name"] as? String,
                                let lines = info["lines"] as? [Int] else { continue }

                        stations.append(TWStation(id: id, name: name, lines: lines))
                    }
                }
            }
        } catch _ {
        }
        return stations
    }
}