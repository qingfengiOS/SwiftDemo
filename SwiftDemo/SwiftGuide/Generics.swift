//
//  Generics.swift
//  SwiftDemo
//
//  Created by liyiping on 2018/5/30.
//  Copyright © 2018年 情风. All rights reserved.
//
/**
 泛型代码让你能够根据自定义的需求，编写出适用于任意类型、灵活可重用的函数及类型。它能让你避免代码的重复，用一种清晰和抽象的方式来表达代码的意图。
 
 泛型是 Swift 最强大的特性之一，许多 Swift 标准库是通过泛型代码构建的。事实上，泛型的使用贯穿了整本语言手册，只是你可能没有发现而已。例如，Swift的Array和Dictionary都是泛型集合。你可以创建一个Int数组，也可创建一个String数组，甚至可以是任意其他Swift 类型的数组。同样的，你也可以创建存储任意指定类型的字典。
 */
import UIKit

class Generics: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        var someInt = 3
        var anotherInt = 107
        swapTwoValues(&someInt, &anotherInt)// someInt 现在 107, and anotherInt 现在 3
        print("someInt = \(someInt), anotherInt = \(anotherInt)")
        
        var someString = "hello"
        var anotherString = "world"
        swapTwoValues(&someString, &anotherString)// someString 现在 "world", and anotherString 现在 "hello"
        print("someString = \(someString), anotherString = \(anotherString)")
        
        var stackOfStrings = Stack<String>()
        stackOfStrings.push("first")
        stackOfStrings.push("second")
        stackOfStrings.push("third")
        stackOfStrings.push("fourth")
        let formTop = stackOfStrings.pop()
        print("formTop is \(formTop)")
        
        
        if let topItem = stackOfStrings.topItem {
            print("The top item on the stack is \(topItem).")
        }
        
        let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
        if let foundIndex = findIndex(ofString: "llama", in: strings) {
            print("The index of llama is \(foundIndex)")
        }
        
        let doubleIndex = findIndex(array: [3.14159, 0.1, 0.25], 9.3)
        let stringIndex = findIndex(array: ["Mike", "Malcolm", "Andrea"], "Andrea")
        print(doubleIndex as Any, stringIndex as Any)
        
        var stack2OfStrings = Stack2<String>()
        stack2OfStrings.push("uno")
        stack2OfStrings.push("dos")
        stack2OfStrings.push("tres")
        
        let arrayOfStrings = ["uno", "dos", "tres"]
        if allItemsMatch(stack2OfStrings, arrayOfStrings) {
            print("All items match.")
        } else {
            print("Not all items match.")
        }
     
        if stack2OfStrings.isTop("tres") {
            print("Top element is tres.")
        } else {
            print("Top element is something else.")
        }
        
        //如果试图在一个元素不是equatable的Stack上调用isTop(:)方法，会得到一个编译器错误
        struct NotEquatable { }
        var notEquatableStack = Stack<NotEquatable>()
        let notEquatableValue = NotEquatable()
        notEquatableStack.push(notEquatableValue)
//        notEquatableStack.isTop(notEquatableValue)  // Error（Value of type 'Stack<NotEquatable>' has no member 'isTop'）

        if [9, 9, 9].startsWith(42) {
            print("Starts with 42.")
        } else {
            print("Starts with something else.")
        }
        
        print([10.0, 150.0, 98.6, 37.0].average())
        
        
    }

    //MARK:-泛型所解决的问题
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    func swapTwoStrings(_ a: inout String, _ b: inout String) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    //MARK:-泛型函数
//    泛型函数可以适用于任何类型，下面的 swapTwoValues(_:_:) 函数是上面三个函数的泛型版本:
    func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
        let temporaryA = a
        a = b
        b = temporaryA
        
        /*
         这个函数的泛型版本使用了占位类型名(在这里用字母 T 来表示)来代替实际类型名(例如 Int、String或 Double )。占位类型名没有指明 T 必须是什么类型，但是它指明了 a 和 b 必须是同一类型 T ，无论 T 代表什么类型。只有 swapTwoValues(_:_:) 函数在调用时，才能根据所传入的实际类型决定 T 所代表的类型。
         
         另外一个不同之处在于这个泛型函数名( swapTwoValues(_:_:) )后面跟着占位类型名( T )，并用尖括号括起 来( <T> )。这个尖括号告诉 Swift 那个 T 是 swapTwoValues(_:_:) 函数定义内的一个占位类型名，因此 S wift 不会去查找名为 T 的实际类型。
         */
    }
    
    //MARK:-类型参数
    /*
    在上面的例子中，占位类型T是类型参数的一个例子。类型参数指定并命名一个占位类型，并且紧随在函数名后面，使用一对尖括号括起来(例如<T>)。
     
    一旦一个类型参数被指定，你可以用它来定义一个函数的参数类型(例如swapTwoValues(_:_:)函数中的参数a和b)，或者作为函数的返回类型，还可以用作函数主体中的注释类型。在这些情况下，类型参数会在函数 调用时被实际类型所替换。(在上面的swapTwoValues(_:_:)例子中，当函数第一次被调用时，T被Int替
    换，第二次调用时，T被String替换。) 你可提供多个类型参数，将它们都写在尖括号中，用逗号分开。
     */
    
    //MARK:-命名类型参数
    /*
    在大多数情况下，类型参数具有一个描述性名字，例如Dictionary<Key, Value>中的Key和   Value，以及Array<Element>中的Element，这可以告诉阅读代码的人这些类型参数和泛型函数之间的关系。然而，当它们之间没有有意义的关系时，通常使用单个字母来命名，例如  T, U,V，正如上面演示的swapTwoValues(_:_:)函数中的T一样。
     */
    
    
    //MARK:-类型约束
    /*
     swapTwoValues(_:_:)函数和Stack类型可以作用于任何类型。不过，有的时候如果能将使用在泛型函数和泛 型类型中的类型添加一个特定的类型约束，将会是非常有用的。类型约束可以指定一个类型参数必须继承自指定 类，或者符合一个特定的协议或协议组合。
     
     类型约束语法:
     你可以在一个类型参数名后面放置一个类名或者协议名，并用冒号进行分隔，来定义类型约束，它们将成为类型参数列表的一部分。对泛型函数添加类型约束的基本语法如下所示(作用于泛型类型时的语法与之相同)
     */
    func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U)  {
        
    }
    
    func findIndex<T: Equatable>(array: [T], _ valueToFind: T) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
    //MARK:-类型约束实践
    func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }

    //MARK:-泛型 Where 语句
    /*
     为关联类型定义约束也是非常有用的。你可以在参数列表中通过 where 子句为关联类型定义约束。你能通过 w here 子句要求一个关联类型遵从某个特定的协议，以及某个特定的类型参数和关联类型必须类型相同。你可以通 过将 where 关键字紧跟在类型参数列表后面来定义 where 子句，where 子句后跟一个或者多个针对关联类 型的约束，以及一个或多个类型参数和关联类型间的相等关系。你可以在函数体或者类型的大括号之前添加 wher e 子句。
     
     下面的例子定义了一个名为 allItemsMatch 的泛型函数，用来检查两个 Container 实例是否包含相同顺序的 相同元素。如果所有的元素能够匹配，那么返回 true ，否则返回 false 。
     
     被检查的两个 Container 可以不是相同类型的容器(虽然它们可以相同)，但它们必须拥有相同类型的元 素。这个要求通过一个类型约束以及一个 where 子句来表示:
     */
    func allItemsMatch<C1: Container, C2: Container>(_ someContainer:C1, _ antherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
            // 检查两个容器含有相同数量的元素
            if someContainer.count != antherContainer.count {
                return false
            }
            
            //检查对应元素
            for i in 0...someContainer.count {
                if someContainer[i] != antherContainer[i] {
                    return false
                }
            }
            return true
        
        /*
         This function takes two arguments called someContainer and anotherContainer. The someContainer argument is of type C1, and the anotherContainer argument is of type C2. Both C1 and C2 are type parameters for two container types to be determined when the function is called.
         这个函数的类型参数列表还定义了对两个类型参数的要求:
         
         • C1必须符合Container协议(写作C1: Container)。
         • C2必须符合Container协议(写作C2: Container)。
         • C1 的 ItemType 必须和 C2 的 ItemType 类型相同(写作 C1.ItemType == C2.ItemType )。
         • C1 的 ItemType 必须符合 Equatable 协议(写作 C1.ItemType: Equatable )。
         
         第三个和第四个要求被定义为一个 where 子句，写在关键字 where 后面，它们也是泛型函数类型参数列表的 一部分。
         • someContainer 是一个 C1 类型的容器。
         • anotherContainer 是一个 C2 类型的容器。
         • someContainer 和 anotherContainer 包含相同类型的元素。
         • someContainer 中的元素可以通过不等于操作符(!=)来检查它们是否彼此不同。
         */
        
    }
    
    
}

//MARK:-泛型类型
//一个非泛型版本的栈，以 Int 型的栈为例:
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

//相同代码的泛型版本:
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element)  {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

//MARK:-扩展一个泛型类型
/*
 当你扩展一个泛型类型的时候，你并不需要在扩展的定义中提供类型参数列表。原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。
 
 下面的例子扩展了泛型类型Stack，为其添加了一个名为topItem的只读计算型属性，它将会返回当前栈顶端 的元素而不会将其从栈中移除:
 */
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

//MARK:-关联类型
/*
 定义一个协议时，有的时候声明一个或者多个关联类型作为协议定义的一部分将会非常有用。关联类型为协议中的某个类型提供了一个占位明（别名），其代表的时机类型在协议被采纳时才会被指定，你可以通过associatedtype关键字来指定关联类型
 */

//关联类型实践
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    /*
     Container 协议定义了三个任何采纳了该协议的类型(即容器)必须提供的功能:
     • 必须可以通过 append(_:) 方法添加一个新元素到容器里。
     • 必须可以通过 count 属性获取容器中元素的数量，并返回一个 Int 值。
     • 必须可以通过索引值类型为 Int 的下标检索到容器中的每一个元素。
     */
}

struct IntStack2: Container {
    
    // original IntStack implementation
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    
    typealias Item = Int

    mutating func append(_ item: Int) {
        self.push(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
    
}

struct Stack2<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
    /*
     占位类型参数 Element 被用作 append(_:) 方法的 item 参数和下标的返回类型。Swift 可以据此 推断出 Element 的类型即是 ItemType 的类型。
     */
}

//通过扩展一个存在的类型来指定关联类型
//Swift 的 Array 类型已经提供 append(_:) 方法，一个 count 属性，以及一个接受 Int 类型索引值的下 标用以检索其元素。这三个功能都符合 Container 协议的要求，也就意味着你只需简单地声明 Array 采纳该 协议就可以扩展 Array ，使其遵从 Container 协议。你可以通过一个空扩展来实现这点
extension Array: Container {
//    如同上面的泛型 Stack 结构体一样， Array 的 append(_:) 方法和下标确保了 Swift 可以推断出itemTupe的类型。定义了这个扩展后，你可以将任意 Array 当作 Container 来使用。
}

//MARK:-通用的Where子句的扩展
/*
 您还可以使用一个通用的where子句作为一个扩展的一部分。下面的例子扩展了通用的Stack2结构从前面的例子添加一个isTop(_:)方法。
 */
extension Stack2 where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}

//MARK:-相关类型的通用Where子句
protocol Container3 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

extension Container3 {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}


