import Foundation

public final class Key<ValueType: Codable> {
    fileprivate let _key: String
    public init(_ key: String) {
        _key = key
    }
}

public protocol IKeyValueStorage {
    func clear<ValueType>(_ key: Key<ValueType>)
    func has<ValueType>(_ key: Key<ValueType>) -> Bool
    func get<ValueType>(for key: Key<ValueType>) -> ValueType?
    func set<ValueType>(_ value: ValueType, for key: Key<ValueType>)
    func removeAll(bundle: Bundle)
    func get<ValueType: RawRepresentable>(for key: Key<ValueType>) -> ValueType? where ValueType.RawValue: Codable
    func set<ValueType: RawRepresentable>(_ value: ValueType, for key: Key<ValueType>) where ValueType.RawValue: Codable
}

public final class Defaults: IKeyValueStorage {
    private var userDefaults: UserDefaults
        
    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    public func clear<ValueType>(_ key: Key<ValueType>) {
        userDefaults.set(nil, forKey: key._key)
        userDefaults.synchronize()
    }
    
    public func has<ValueType>(_ key: Key<ValueType>) -> Bool {
        return userDefaults.value(forKey: key._key) != nil
    }
    
    public func get<ValueType>(for key: Key<ValueType>) -> ValueType? {
        guard let data = userDefaults.data(forKey: key._key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ValueType.self, from: data)
            return decoded
        } catch {
            #if DEBUG
                print(error)
            #endif
        }

        return nil
    }

    public func set<ValueType>(_ value: ValueType, for key: Key<ValueType>) {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(value)
            userDefaults.set(encoded, forKey: key._key)
            userDefaults.synchronize()
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    public func removeAll(bundle: Bundle = Bundle.main) {
        guard let name = bundle.bundleIdentifier else { return }
        self.userDefaults.removePersistentDomain(forName: name)
    }
    
    public func get<ValueType: RawRepresentable>(for key: Key<ValueType>) -> ValueType?
        where ValueType.RawValue: Codable {
        let convertedKey = Key<ValueType.RawValue>(key._key)
        if let raw = get(for: convertedKey) {
            return ValueType(rawValue: raw)
        }
        return nil
    }
    
    public func set<ValueType: RawRepresentable>(_ value: ValueType, for key: Key<ValueType>)
        where ValueType.RawValue: Codable {
        let convertedKey = Key<ValueType.RawValue>(key._key)
        set(value.rawValue, for: convertedKey)
    }
}
