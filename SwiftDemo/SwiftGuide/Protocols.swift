//
//  Protocols.swift
//  SwiftDemo
//
//  Created by liyiping on 2018/5/26.
//  Copyright © 2018年 情风. All rights reserved.
//
/*
 协议 定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。类、结构体 或枚举都可以遵循协议，并为协议定义的这些要求提供具体实现。某个类型能够满足某个协议的要求，就可以说 该类型遵循这个协议。
 
 除了遵循协议的类型必须实现的要求外，还可以对协议进行扩展，通过扩展来实现一部分要求或者实现一些附加功能，这样遵循协议的类型就能够使用这些功能。
 */
import UIKit

//MARK:-协议语法
protocol SomeProtocol {//协议的定义方式与类、结构体和枚举的定义非常相似
    // 这里是协议的定义部分
}

protocol OtherProtocol {
    
}

//要让自定义类型遵循某个协议，在定义类型时，需要在类型名称后加上协议名称，中间以冒号( : )分隔。遵循 多个协议时，各协议之间用逗号( , )分隔:
struct SomeStruct2: SomeProtocol, OtherProtocol {
    
}

class SomeSuperClass {//父类
    
}

class SomeClass2: SomeSuperClass, SomeProtocol, OtherProtocol {
    // 这里是类的定义部分
}

//MARK:-属性要求
/*
 协议可以要求遵循协议的类型提供特定名称和类型的实例属性或类型属性。协议不指定属性是存储型属性还是计算型属性，它只指定属性的名称和类型。此外，协议还指定属性是可读的还是可读可写的。
 
 如果协议要求属性是可读可写的，那么该属性不能是常量属性或只读的计算型属性。如果协议只要求属性是可读的，那么该属性不仅可以是可读的，如果代码需要的话，还可以是可写的。
 
 协议总是用 var 关键字来声明变量属性，在类型声明后加上 { set get } 来表示属性是可读可写的，可读属性则用 { get 来表示:
 */
protocol ProtocolProperty {
    var mustBeSettable: Int { set get }
    var doesNotNeedToBesettable: Int {get}
}

/*
 协议中定义类型属性时，总是使用 static 关键字作为前缀。当类类型遵循协议时，除了 static 关键 字，还可以使用 class 关键字来声明类型属性:
 */
protocol AnotherProtocol {
    static var someTypeProperty: Int {set get}
    
}

//这是个只含有一个实例属性要求的协议:
protocol FullyNamed {
    var fullName: String { get }
    //FullyNamed 协议除了要求遵循协议的类型提供 fullName 属性外，并没有其他特别的要求。这个协议表示，任 何遵循 FullyNamed 的类型，都必须有一个可读的 String 类型的实例属性 fullName 。
}


//下面是一个遵循 FullyNamed 协议的简单结构体:
struct Person: FullyNamed {
    var fullName: String
    //Person 结构体的每一个实例都有一个 String 类型的存储型属性 fullName 。这正好满足了 FullyNamed 协 议的要求，也就意味着 Person 结构体正确地符合了协议。(如果协议要求未被完全满足，在编译时会报错。
}

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : " ") + name
    }
}

//MARK:-方法要求
/*
 协议可以要求遵循协议的类型实现某些指定的实例方法或类方法。这些方法作为协议的一部分，像普通方法一样放在协议的定义中，但是不需要大括号和方法体。可以在协议中定义具有可变参数的方法，和普通方法的定义方式相同。但是，不支持为协议中的方法的参数提供默认值。
 
 正如属性要求中所述，在协议中定义类方法的时候，总是使用 static 关键字作为前缀。当类类型遵循协议 时，除了 static 关键字，还可以使用 class 关键字作为前缀:
 */
protocol MethodProtocol {
    static func someTypeMethod()
}

protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3887.0
    let c = 2973.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }
}

//MARK:-Mutating 方法要求
/*
 有时需要在方法中改变方法所属的实例。例如，在值类型(即结构体和枚举)的实例方法中，将 mutating 关键 字作为方法的前缀，写在 func 关键字之前，表示可以在该方法中修改它所属的实例以及实例的任意属性的 值。
 
 如果你在协议中定义了一个实例方法，该方法会改变遵循该协议的类型的实例，那么在定义协议时需要在方法前 加 mutating 关键字。这使得结构体和枚举能够遵循此协议并满足此方法要求。
 */
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case Off, On
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        case .On:
            self = .Off
        }
    }
}

//MARK:-构造器要求
/*
 协议可以要求遵循协议的类型实现指定的构造器。你可以像编写普通构造器那样，在协议的定义里写下构造器的声明，但不需要写花括号和构造器的实体
 */
protocol InitializeProtocol {
    init(someParamter: Int)
}

/*
 构造器要求在类中的实现
 
 你可以在遵循协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器。无论哪种情况，你都必须 为构造器实现标上 required 修饰符:
*/
class InitializeProtocolClass: InitializeProtocol {
    required init(someParamter: Int) {
        // 这里是构造器的实现部分
        //使用 required 修饰符可以确保所有子类也必须提供此构造器实现，从而也能符合协议。
    }
}
//如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标 注 required 和 override 修饰符:
protocol SomesProtocol {
    init()
}
class SomesSuperClass {
    init() {
        // 这里是构造器的实现部分
    }
}
class SomesSubClass: SomesSuperClass, SomesProtocol {
    // 因为遵循协议，需要加上 required
    // 因为继承自父类，需要加上 override
    required override init() {
        // 这里是构造器的实现部分
    }
}
//可失败构造器要求
//遵循协议的类型可以通过可失败构造器( init? )或非可失败构造器( init )来满足协议中定义的可失败构造器 要求。协议中定义的非可失败构造器要求可以通过非可失败构造器( init )或隐式解包可失败构造器( init! )来满足

//MARK:-协议作为类型
/*
 尽管协议本身并未实现任何功能，但是协议可以被当做一个成熟的类型来使用。
 
 协议可以像其他普通类型一样使用，使用场景如下:
 
 • 作为函数、方法或构造器中的参数类型或返回值类型
 • 作为常量、变量或属性的类型
 • 作为数组、字典或其他容器中的元素类型
 
 协议是一种类型，因此协议类型的名称应与其他类型(例如 Int ， Double ， String )的写法相同，使用大写 字母开头的驼峰式写法，例如(FullyNamed 和RandomNumberGenerator)。
 */
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(side: Int, generator: RandomNumberGenerator) {
        self.sides = side
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

//MARK:-委托(代理)模式
/*
 委托是一种设计模式，它允许类或结构体将一些需要它们负责的功能委托给其他类型的实例。委托模式的实现很简单:定义协议来封装那些需要被委托的功能，这样就能确保遵循协议的类型能提供这些功能。委托模式可以用来响应特定的动作，或者接收外部数据源提供的数据，而无需关心外部数据源的类型。
 下面的例子定义了两个基于骰子游戏的协议:
 */
protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
    /*
     DiceGame 协议可以被任意涉及骰子的游戏遵循。DiceGameDelegate 协议可以被任意类型遵循，用来追踪 Game 的游戏过程。
     */
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(side: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                break gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
    /*
     This version of the game is wrapped up as a class called SnakesAndLadders, which adopts the DiceGame protocol. It provides a gettable dice property and a play() method in order to conform to the protocol. (The dice property is declared as a constant property because it doesn’t need to change after initialization, and the protocol only requires that it must be gettable.)
     
     The Snakes and Ladders game board setup takes place within the class’s init() initializer. All game logic is moved into the protocol’s play method, which uses the protocol’s required dice property to provide its dice roll values.
     
     Note that the delegate property is defined as an optional DiceGameDelegate, because a delegate isn’t required in order to play the game. Because it’s of an optional type, the delegate property is automatically set to an initial value of nil. Thereafter, the game instantiator has the option to set the property to a suitable delegate. Because the DiceGameDelegate protocol is class-only, you can declare the delegate to be weak to prevent reference cycles.
     
     DiceGameDelegate provides three methods for tracking the progress of a game. These three methods have been incorporated into the game logic within the play() method above, and are called when a new game starts, a new turn begins, or the game ends.
     
     Because the delegate property is an optional DiceGameDelegate, the play() method uses optional chaining each time it calls a method on the delegate. If the delegate property is nil, these delegate calls fail gracefully and without error. If the delegate property is non-nil, the delegate methods are called, and are passed the SnakesAndLadders instance as a parameter.
     */
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }

    /*
     DiceGameTracker实现了DiceGameDelegate协议要求的三个方法用来记录游戏已经进行的轮数。当游戏开始时，numberOfTurn属性被赋值为0，然后在每一轮中递增，游戏结束之后，打印游戏的总轮数
     
     gameDidStart(_:)方法从game参数获取游戏信息并且打印。game参数是DiceGame类型，而不是SnakeAndLadders类型，所以在gameDidStart(_:)发方法中只能访问DiceGame协议中的内容。当然，SnakeAdnLadders的方法也可以在类型转换之后调用。在上例代码中，通过is操作符game是否为SnakeAndLadders类型的实例，如果是，则打印出相应的消息。
     
     无论当前进行的是何种游戏，由于game符合DiceGame协议，可以确保game含有dice属性。因此，在gameDidStart(_:)方法中可以通过传入的game参数类访问dice属性，进而打印dice的sides属性的值。
     */
}

//MARK:-通过扩展添加协议一致性
/*
 即便无法修改源代码，依然可以通过扩展令已有类型遵循并符合协议。扩展可以为已有类型添加属性、方法、下标以及构造器，因此可以符合协议中的相应要求
 
 下面这个 TextRepresentable 协议，任何想要通过文本表示一些内容的类型都可以实现该协议。这些想要表 示的内容可以是实例本身的描述，也可以是实例当前状态的文本描述:
 */
protocol TextRepresentable {
    var textualDescription: String { get }
}

//可以通过扩展，令先前提到的 Dice 类遵循并符合 TextRepresentable 协议:
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides) - sided dice"
    }
}

//MARK:-通过扩展遵循协议
//当一个类型已经符合了某个协议中的所有要求，却还没有声明遵循该协议时，可以通过空扩展体的扩展来遵循该协议
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}

extension Hamster: TextRepresentable{
    //从现在起，Hamster 的实例可以作为 TextRepresentable 类型使用:
}

//MARK:-协议的继承
//协议能够继承一个或多个其他协议，可以在继承的协议的基础上增加新的要求。协议的继承语法与类的继承相似，多个被继承的协议间用逗号分隔

//MARK:-Main ViewController
class Protocols: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let john = Person(fullName: "John Applessed")
        print(john.fullName)
        
        let ncc1701 = Starship(name: "Enterprise", prefix: "USS")
        print(ncc1701.fullName)
        
        let generator = LinearCongruentialGenerator()
        for i in 0...10 {
            print("the \(i) random number is:\(generator.random()) ")
        }
        
        var lightSwitch = OnOffSwitch.Off
        lightSwitch.toggle()
        if lightSwitch == .On {
            print("On")
        } else {
            print("Off")
        }
    
        lightSwitch.toggle()
        if lightSwitch == .On {
            print("On")
        } else {
            print("Off")
        }
        
        let d6 = Dice(side: 6, generator: LinearCongruentialGenerator())
        for _ in 1...5 {
            print("Random dice roll is \(d6.roll())")
        }
        
        let tracker = DiceGameTracker()
        let game = SnakesAndLadders()
        game.delegate = tracker
        game.play()
        
        let d12 = Dice(side: 12, generator: LinearCongruentialGenerator())
        print(d12.textualDescription)
        
        let simonTheHanster = Hamster(name: "Simon")
        let somethingTextRepresentable: TextRepresentable = simonTheHanster
        print(somethingTextRepresentable.textualDescription)
        print("------------------------------------------")
        //MARK:-协议类型的集合
        //协议类型可以在数组或者字典这样的集合中使用，下面的例子创建了一个 元素类型为 TextRepresentable 的数组:
        let things: [TextRepresentable] = [d12, simonTheHanster]
        for thing in things {
            print(thing.textualDescription)
        }
        
    }
    
  
}










