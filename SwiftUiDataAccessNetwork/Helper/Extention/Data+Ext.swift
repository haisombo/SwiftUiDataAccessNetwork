//
//  Data+Ext.swift
//  SwiftUiDataAccessNetwork
//
//  Created by Hai Sombo on 10/14/24.
//
import Foundation

public extension Data {
    mutating func append(_ string: String) {
          if let data = string.data(using: .utf8) {
              self.append(data)
          }
      }
    // MARK: - Data
    init?(hexEncodedString string: String) {

        let strip = CharacterSet(charactersIn: " <>\n\t")
        let input = string.unicodeScalars.filter { !strip.contains($0) }.map { $0.utf16 }.joined()

        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }

        self.init(capacity: input.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in input {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }

    static func randomBytes(length: Int) -> Data {
        var data = Data(count: length)
        _ = data.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, length, bytes.baseAddress!)
        }
        return data
    }
    
    // - For Print Response Data
    var prettyPrinted: String {
        // Try to convert to dictionary or array and pretty print JSON
        return MyJson.prettyPrint(value: self.dataToJson)
    }
    
    var dataToJson: Any {
        // Try to deserialize into an array or dictionary
        if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []) {
            return jsonObject
        }
        return [:]  // Default to empty dictionary if deserialization fails
    }
    
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
public struct MyJson {
    
    enum DataError: Error {
        case invalidEncodingData
    }
    // Print JSON Data
    static func prettyPrint(value: AnyObject) -> String {
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        return ""
    }
    
    static func jsonStringToDic(_ jsonString : String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        } catch {
            #if DEBUG
            Log.e(error.localizedDescription)
            #endif
            return nil
        }
    }
    static func dicToJSONString(_ dic: [String:Any]) throws -> String {
        let data: Data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        guard let jsonString: String = String(data: data, encoding: String.Encoding.utf8) else {
            throw DataError.invalidEncodingData
        }
        
        return jsonString
    }
    // MARK: - For Convent Data from Dictionary to String Value
    func dictionaryToJSONString(_ dict: [String: Any]) -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
    static func prettyPrint(value: Any) -> String {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted),
               let prettyPrintedString = String(data: data, encoding: .utf8) {
                return prettyPrintedString
            }
            return "Invalid JSON data"
        }
}
