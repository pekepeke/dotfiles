```uml
@startuml

actor User

== Initial ==

User -> Client : Request Client Sign In
note right : GET /user/sign_in

activate Client
Client -> Client : Access Token?

== Authentication ==

Client -> AuthN : Redirect
note right : GET /oauth/authorize
deactivate Client

activate AuthN
AuthN -> AuthN : Current User?
AuthN -> AuthN : Redirect
note right : GET /user/sign_in
User <- AuthN : Response AuthN Sign In
deactivate AuthN

User -> AuthN : Request AuthN Sign In (ID, Pass)

activate AuthN
note right : POST /user/sign_in
AuthN -> AuthN : Redirect
note right : GET /oauth/authorize

== Authorization ==

AuthN -> AuthZ : Redirect
note right : GET /oauth/authorize
deactivate AuthN

activate AuthZ
User <- AuthZ : Response AuthZ Application
deactivate AuthZ

User -> AuthZ : Request AuthZ Application (Allow)
note right : POST /oauth/authorize

activate AuthZ
AuthZ -> AuthZ : Generate Code

Client <- AuthZ : Redirect
note right : GET /callback
deactivate AuthZ

activate Client
Client -> AuthZ : Request Access Token
note right : POST /oauth/access_token

activate AuthZ
AuthZ -> AuthZ : Authorization Code?
AuthZ -> AuthZ : Generate Token

Client <-- AuthZ : Response Access Token
deactivate AuthZ

Client -> Client : Redirect
note right : GET /user/sign_in

Client -> Client : Access Token?

== Resource ==

Client -> Resource : Request User (Access Token)
note right : GET /api/user

activate Resource
Client <-- Resource : Response User
deactivate Resource

== Final ==

Client -> Client : Redirect
note right : GET /

User <- Client : Response Client Sign In
deactivate Client

@enduml
```
