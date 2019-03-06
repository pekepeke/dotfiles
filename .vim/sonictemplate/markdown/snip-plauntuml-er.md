```uml
@startuml
package default {
    entity "attribute symbol" {
        + green circle
        - red square
        # yellow diamond
        ~ blue triangle
        * black circle
        nothing
    }
    
    entity entity1 {
        id
    }
    entity entity2 {
        id
    }
    entity1 -ri- entity2 : one >
    entity1 -ri-o| entity2 : zero or one >
    entity1 -ri-o{ entity2 : zero or many >
    entity1 -ri-|| entity2 : one and only one >
    entity1 -ri-|{ entity2 : one or many >
    entity1 -ri-{ entity2 : many >
}
@enduml
```
