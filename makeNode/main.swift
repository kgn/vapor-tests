import Vapor

let people = 12
print("double")
print(try people.makeNode()) // ok on linux and Mac
print(Node(people)) // ok on linux and Mac

let money = 54.23
print("int")
print(money.makeNode()) // ok on linux and Mac
print(Node(money)) // ok on linux and Mac

let name = "David"
print("string")
print(name.makeNode()) // ok on linux and Mac

print("JSON")
let node = JSON([
    "name": name.makeNode(),
    "people": try people.makeNode(), // why does only double need try?
    "money": money.makeNode()
])
print(node)
