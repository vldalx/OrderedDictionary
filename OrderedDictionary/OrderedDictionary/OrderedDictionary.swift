//
//  OrderedDictionary.swift
//  OrderedDictionary
//
//  Created by Vladimir Kushelkov on 14/05/2017.
//  Copyright © 2017 vldalx. All rights reserved.
//

import Foundation

/// A generic collection for storing key-value pairs in an ordered manner.
///
/// Same as in a dictionary all keys in the collection are unique and have an associated value.
/// Same as in an array, all key-value pairs (elements) are kept sorted and accessible by
/// a zero-based integer index.
public struct OrderedDictionary<Key: Hashable, Value>: BidirectionalCollection {

    // ======================================================= //
    // MARK: - Type Aliases
    // ======================================================= //
    
    /// The type of the key-value pair stored in the ordered dictionary.
    public typealias Element = (key: Key, value: Value)

    /// The type of the index.
    public typealias Index = Int
    
    /// The type of the indices collection.
    public typealias Indices = CountableRange<Index>
    
    /// The type of the contiguous subrange of the ordered dictionary's elements.
    public typealias SubSequence = BidirectionalSlice<OrderedDictionary>
    
    // ======================================================= //
    // MARK: - Internal Storage
    // ======================================================= //
    
    /// The backing storage for the ordered keys.
    fileprivate var orderedKeys = NSMutableOrderedSet()
    
    /// The backing storage for the mapping of keys to values.
    fileprivate var keysToValues = [Key: Value]()
    
    // ======================================================= //
    // MARK: - Initialization
    // ======================================================= //
    
    /// Creates an empty ordered dictionary.
    public init() {
    }
    
    /// Creates an ordered dictionary from a sequence of key-value pairs.
    ///
    /// - Parameter elements: The key-value pairs that will make up the new ordered dictionary. Each key
    ///   in `elements` must be unique.
    public init<S: Sequence>(_ elements: S) where S.Iterator.Element == Element {
        for (key, value) in elements {
            precondition(!contains(key: key), "Elements sequence contains duplicate keys")
            self[key] = value
        }
    }
    
    /// Creates an ordered dictionary from a sequence of values.
    ///
    /// - Parameter elements: The values that will make up the new ordered dictionary. Each key
    ///   in `elements` must be unique.
    /// - Parameters:
    ///   - elements: The values that will make up the new ordered dictionary.
    ///   - keySelector: Selects the key from an element.
    public init<S: Sequence>(_ elements: S, keySelector: (Value) -> Key) where S.Iterator.Element == Value {
        for value in elements {
            let key = keySelector(value)
            precondition(!contains(key: key), "Elements sequence contains duplicate keys")
            self[key] = value
        }
    }
    
    // ======================================================= //
    // MARK: - Ordered Keys & Values
    // ======================================================= //
    
    /// A collection containing just the keys of the ordered dictionary in the correct order.
    public var keys: LazyMapBidirectionalCollection<OrderedDictionary, Key> {
        return self.lazy.map { $0.key }
    }
    
    /// A collection containing just the values of the ordered dictionary in the correct order.
    public var values: LazyMapBidirectionalCollection<OrderedDictionary, Value> {
        return self.lazy.map { $0.value }
    }
    
    // ======================================================= //
    // MARK: - Key-based Access
    // ======================================================= //
    
    /// Accesses the value associated with the given key for reading and writing.
    ///
    /// This *key-based* subscript returns the value for the given key if the key
    /// is found in the dictionary, or `nil` if the key is not found.
    ///
    /// When you assign a value for a key and that key already exists, the
    /// dictionary overwrites the existing value. If the dictionary doesn't
    /// contain the key, the key and value are added as a new key-value pair.
    ///
    /// If you assign `nil` as the value for the given key, the dictionary
    /// removes that key and its associated value.
    ///
    /// - Parameter key: The key to find in the dictionary.
    /// - Returns: The value associated with `key` if `key` is in the dictionary;
    ///   otherwise, `nil`.
    public subscript(key: Key) -> Value? {
        get {
            return keysToValues[key]
        }
        set {
            if let newValue = newValue {
                updateValue(newValue, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    /// Returns a Boolean value indicating whether the ordered dictionary contains the given key.
    ///
    /// - Parameter key: The key to be looked up.
    /// - Returns: `true` if the ordered dictionary contains the given key; otherwise, `false`.
    public func contains(key: Key) -> Bool {
        return orderedKeys.contains(key)
    }
 
    /// Updates the value stored in the ordered dictionary for the given key, or appends a new key-value
    /// pair if the key does not exist.
    ///
    /// - Parameter value: The new value to add to the ordered dictionary.
    /// - Parameter key: The key to associate with `value`. If `key` already exists in the ordered
    ///   dictionary, `value` replaces the existing associated value. If `key` is not already a key of the
    ///   ordered dictionary, the `(key, value)` pair is appended at the end of the ordered dictionary.
    @discardableResult
    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        if let oldValue = keysToValues.updateValue(value, forKey: key)
        {
            return oldValue
        }

        orderedKeys.add(key)
        return nil
    }
    
    /// Removes the given key and its associated value from the ordered dictionary.
    ///
    /// If the key is found in the ordered dictionary, this method returns the key's associated
    /// value. On removal, the indices of the ordered dictionary are invalidated. If the key is
    /// not found in the ordered dictionary, this method returns `nil`.
    ///
    /// - Parameter key: The key to remove along with its associated value.
    /// - Returns: The value that was removed, or `nil` if the key was not present in the
    ///   ordered dictionary.
    ///
    /// - SeeAlso: remove(at:)
    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        let index = orderedKeys.index(of: key)
        guard index != NSNotFound, let currentValue = keysToValues.removeValue(forKey: key) else { return nil }
        
        orderedKeys.removeObject(at: index)
        return currentValue
    }
    
    /// Removes all key-value pairs from the ordered dictionary and invalidates all indices.
    ///
    /// - Parameter keepCapacity: Whether the ordered dictionary should keep its underlying storage.
    ///   If you pass `true`, the operation preserves the storage capacity that the collection has,
    ///   otherwise the underlying storage is released. The default is `false`.
    public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        orderedKeys.removeAllObjects()
        keysToValues.removeAll(keepingCapacity: keepCapacity)
    }

    // ======================================================= //
    // MARK: - Index-based Access
    // ======================================================= //
    
    /// Accesses the key-value pair at the specified position.
    ///
    /// The specified position has to be a valid index of the ordered dictionary. The index-base subscript
    /// returns the key-value pair corresponding to the index.
    ///
    /// - Parameter position: The position of the key-value pair to access. `position` must be a valid
    ///   index of the ordered dictionary and not equal to `endIndex`.
    /// - Returns: A tuple containing the key-value pair corresponding to `position`.
    ///
    /// - SeeAlso: update(:at:)
    public subscript(position: Index) -> Element {
        return element(at: position)
    }
    
    /// Accesses the key-value pair at the specified position.
    ///
    /// The specified position has to be a valid index of the ordered dictionary.
    /// Returns the key-value pair corresponding to the index.
    ///
    /// - Parameter at: The position of the key-value pair to access. `at` must be a valid
    ///   index of the ordered dictionary and not equal to `endIndex`.
    /// - Returns: A tuple containing the key-value pair corresponding to `at`.
    public func element(at index: Index) -> Element {
        precondition(index < endIndex, "OrderedDictionary index is out of range")
        
        let key = orderedKeys.object(at: index) as! Key
        let value = keysToValues[key]
        
        return (key, value!)
    }
    
    /// Returns the index for the given key.
    ///
    /// - Parameter key: The key to find in the ordered dictionary.
    /// - Returns: The index for `key` and its associated value if `key` is in the ordered dictionary;
    ///   otherwise, `nil`.
    public func index(forKey key: Key) -> Index? {
        let index = orderedKeys.index(of: key)
        return index != NSNotFound ? index : nil
    }

    /// Inserts a new key-value pair at the specified position.
    ///
    /// If the key of the inserted pair already exists in the ordered dictionary, a runtime error
    /// is triggered. Use `canInsert(_:)` for performing a check first, so that this method can
    /// be executed safely.
    ///
    /// - Parameter newElement: The new key-value pair to insert into the ordered dictionary. The key
    ///   contained in the pair must not be already present in the ordered dictionary.
    /// - Parameter index: The position at which to insert the new key-value pair. `index` must be a valid
    ///   index of the ordered dictionary or equal to `endIndex` property.
    ///
    /// - SeeAlso: canInsert(_:)
    /// - SeeAlso: update(:at:)
    public mutating func insert(_ newElement: Element, at index: Index) {
        precondition(index >= startIndex && index <= endIndex, "OrderedDictionary index is out of range")
        precondition(!contains(key: newElement.key), "Cannot insert duplicate key in OrderedDictionary")

        orderedKeys.insert(newElement.key, at: index)
        keysToValues[newElement.key] = newElement.value
    }

    /// Updates the key-value pair located at the specified position.
    ///
    /// If the key of the updated pair already exists in the ordered dictionary *and* is located at
    /// a different position than the specified one, a runtime error is triggered. Use `canUpdate(_:at:)`
    /// for performing a check first, so that this method can be executed safely.
    ///
    /// - Parameter newElement: The key-value pair to be set at the specified position.
    /// - Parameter index: The position at which to set the key-value pair. `index` must be a valid index
    ///   of the ordered dictionary.
    ///
    /// - SeeAlso: canUpdate(_:at:)
    /// - SeeAlso: insert(:at:)
    @discardableResult
    public mutating func update(_ newElement: Element, at index: Index) -> Element? {
        let keyIndex = orderedKeys.index(of: newElement.key)

        precondition(keyIndex == index, "OrderedDictionary update duplicates key")
        
        let key = orderedKeys.object(at: keyIndex) as! Key
        let value = keysToValues.updateValue(newElement.value, forKey: newElement.key)
        
        orderedKeys.replaceObject(at: keyIndex, with: newElement.key)
        
        return (key, value!)
    }
    
    /// Removes and returns the key-value pair at the specified position if there is any key-value pair,
    /// or `nil` if there is none.
    ///
    /// - Parameter index: The position of the key-value pair to remove.
    /// - Returns: The element at the specified index, or `nil` if the position is not taken.
    ///
    /// - SeeAlso: removeValue(forKey:)
    @discardableResult
    public mutating func remove(at index: Index) -> Element {
        let key = orderedKeys.object(at: index) as! Key
        let value = keysToValues.removeValue(forKey: key)!
        return (key, value)
    }
    
    // ======================================================= //
    // MARK: - Sorting
    // ======================================================= //
    
    /// Sorts the ordered dictionary in place, using the given predicate as the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its first argument should be
    ///   ordered before its second argument; otherwise, `false`.
    ///
    /// - SeeAlso: MutableCollection.sort(by:), sorted(by:)
    public mutating func sort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        orderedKeys.sort(comparator: {
            (l: Any, r: Any) -> ComparisonResult in
            let lKey = l as! Key
            let rKey = r as! Key
            let lValue = keysToValues[lKey]!
            let rValue = keysToValues[rKey]!
            return areInIncreasingOrder((lKey, lValue), (rKey, rValue))
                ? .orderedAscending
                : .orderedDescending
            })
    }
    
    /// Returns a new ordered dictionary, sorted using the given predicate as the comparison between
    /// elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its first argument should be
    ///   ordered before its second argument; otherwise, `false`.
    /// - Returns: A new ordered dictionary sorted according to the predicate.
    ///
    /// - SeeAlso: MutableCollection.sorted(by:), sort(by:)
    /// - MutatingVariant: sort
    public func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> OrderedDictionary {
        let sortedElementsArray: [Element] = self.sorted(by: areInIncreasingOrder)
        return OrderedDictionary<Key, Value>(sortedElementsArray)
    }

    // ======================================================= //
    // MARK: - Slices
    // ======================================================= //
    
    /// Accesses a contiguous subrange of the ordered dictionary.
    ///
    /// - Parameter bounds: A range of the ordered dictionary's indices. The bounds of the range must be
    ///   valid indices of the ordered dictionary.
    /// - Returns: The slice view at the ordered dictionary in the specified subrange.
    public subscript(bounds: Range<Index>) -> SubSequence {
        return SubSequence(base: self, bounds: bounds)
    }
    
    // ======================================================= //
    // MARK: - Indices
    // ======================================================= //
    
    /// The indices that are valid for subscripting the ordered dictionary.
    public var indices: Indices {
        return 0..<orderedKeys.count
    }
    
    /// The position of the first key-value pair in a non-empty ordered dictionary.
    public var startIndex: Index {
        return 0
    }
    
    /// The position which is one greater than the position of the last valid key-value pair in the
    /// ordered dictionary.
    public var endIndex: Index {
        return orderedKeys.count
    }
    
    /// Returns the position immediately after the given index.
    public func index(after i: Index) -> Index {
        return i + 1
    }
    
    /// Returns the position immediately before the given index.
    public func index(before i: Index) -> Index {
        return i - 1
    }
}

// ======================================================= //
// MARK: - Literals
// ======================================================= //

extension OrderedDictionary: ExpressibleByArrayLiteral {
    
    /// Creates an ordered dictionary initialized from an array literal containing a list of
    /// key-value pairs.
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
}

extension OrderedDictionary: ExpressibleByDictionaryLiteral {
    
    /// Creates an ordered dictionary initialized from a dictionary literal.
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(elements.map { (key: $0, value: $1) })
    }
    
}

// ======================================================= //
// MARK: - Equality
// ======================================================= //

extension OrderedDictionary where Value: Equatable {
    
    /// Returns a Boolean value that indicates whether the two given ordered dictionaries with
    /// equatable values are equal.
    public static func == (lhs: OrderedDictionary, rhs: OrderedDictionary) -> Bool {
        return lhs.orderedKeys.isEqual(to: rhs.orderedKeys) && lhs.keysToValues.values.elementsEqual(rhs.keysToValues.values)
    }
    
}

