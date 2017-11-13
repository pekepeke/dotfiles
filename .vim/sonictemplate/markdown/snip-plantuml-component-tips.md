```uml
@startuml

actor "User"

node "Application" {
  [Client]
}

node "API" {
  [Resource]
}

node "Authentication" {
  [AuthN]
}

node "Authorization" {
  [AuthZ]
}


[User].[Client]
[User]..[AuthN]
[User]..[AuthZ]

[AuthN]..[AuthZ]

[Client]..[AuthN]
[Client]..[AuthZ]
[Client].[Resource]

@enduml
```
