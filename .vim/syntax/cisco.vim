" Vim syntax file
" Language:     Cisco IOS config file
" Last Change:  2008-07-16
"
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

setlocal iskeyword+=-

syn match ciscoComment	"^\s*!.*$"
hi def link ciscoComment Comment

syn match ciscoIpAddr /\<\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\>/
hi def link ciscoIpAddr	Number

syntax match ciscoIfName /\<\(Loopback\|Tunnel\|Dialer\)[0-9][0-9]*\>/
syn match ciscoIfName +\<\(Ethernet\|FastEthernet\)[0-9][0-9]*/[0-9][0-9]*\(/[0-9][0-9]*\)\?\(\.[0-9][0-9]*\)\?\>+
syn match ciscoIfName +\<ATM[0-9][0-9]*\(/[0-9][0-9]*\)*\(\.[0-9][0-9]*\)\?\>+
hi def link ciscoIfName Identifier

syn match ciscoWord contained +[a-zA-Z0-9-_]*+
hi def link ciscoWord String

syn region ciscoUsernames start=+^username\s+ skip=+^username\s+ end=+^\S+me=s-1 fold
syn region ciscoIpHosts start=+^ip host\s+ skip=+^ip host\s+ end=+^\S+me=s-1 fold

syn region ciscoInterfaces start=+^interface\s+ skip=+^\(!\n\)\?interface\s+ end=+^\S+me=s-1 fold contains=ciscoInterfaceRegion
syn region ciscoInterfaceRegion contained start=+^interface\s+ end=+^\S+me=s-1 fold contains=ciscoIpAddr,ciscoIfName,ciscoComment

syn region ciscoRouters start=+^router\s+ skip=+^\(!\n\)\?router\s+ end=+^\S+me=s-1 fold contains=ciscoRouterRegion
syn region ciscoRouterRegion start=+^router\s+ end=+^\S+me=s-1 contained fold contains=ciscoIpAddr,ciscoIfName,ciscoComment

syn region ciscoIpRoutes start=+^ip route\s+ end=+^\(ip route\)\@!+me=s-1 fold contains=ciscoIpRoute
syn match ciscoIpRoute +^ip route.*$+ contained skipwhite contains=ciscoIpAddr,ciscoNumber,ciscoIfName

syn region ciscoIpAccessLists start=+^ip access-list\s+ skip=+^\(!\n\)\?ip access-list\s+ end=+^\S+me=s-1 fold contains=ciscoIpAccessList
syn region ciscoIpAccessList contained start=+^ip access-list\s+ end=+^\S+me=s-1 fold contains=ciscoIpAccessListNamed,ciscoIpAddr,ciscoIfName,ciscoComment,ciscoAclKeywords,ciscoAclOperator
syn match ciscoIpAccessListNamed +^ip access-list \(standard\|extended\) + contained nextgroup=ciscoWord skipwhite
syn keyword ciscoAclKeywords contained skipwhite host any
syn keyword ciscoAclOperator contained skipwhite eq ne
hi def link ciscoAclKeywords Keyword
hi def link ciscoAclOperator Special

syn region ciscoAccessLists start=+^access-list\s+ skip=+^access-list\s+ end=+^\S+me=s-1 fold contains=ciscoAccessList
syn region ciscoAccessList start=+^access-list \z(\d\+\)\ + skip=+^access-list \z1 + end=+^\S+me=s-1 contained fold contains=ciscoIpAddr,ciscoIfName

syn region ciscoRouteMaps start=+^route-map\s+ skip=+^\(!\n\)\?route-map\s+ end=+^\S+me=s-1 fold contains=ciscoRouteMap
syn region ciscoRouteMap contained start=+^route-map\s+ end=+^\S+me=s-1 fold contains=ciscoIpAddr,ciscoIfName,ciscoComment

syn region ciscoCryptoIsakmp start=+^crypto isakmp\s+ end=+^\S+me=s-1 fold

syn region ciscoCryptoIsakmpKeys start=+^crypto isakmp key\s+ skip=+^crypto isakmp key\s+ end=+^\S+me=s-1 fold

syn region ciscoCryptoIpsecTses start=+^crypto ipsec transform-set\s+ skip=+^crypto ipsec transform-set\s+ end=+^\S+me=s-1 fold contains=ciscoCryptoIpsecTs
syn match ciscoCryptoIpsecTs contained +^crypto ipsec transform-set + nextgroup=ciscoWord skipwhite

syn region ciscoCryptoMaps start=+^crypto map\s+ skip=+^crypto map\s+ end=+^\S+me=s-1 fold contains=ciscoCryptoMap
syn region ciscoCryptoMap start=+^crypto map \z(\S\+\)\ + skip=+^crypto map \z1 + end=+^\S+me=s-1 contained fold contains=ciscoCryptoMapEntry
syn region ciscoCryptoMapEntry contained start=+^crypto map\s+ end=+^\S+me=s-1 fold contains=ciscoCryptoMapName,ciscoIpAddr
syn match ciscoCryptoMapName contained +^crypto map + nextgroup=ciscoWord skipwhite

set foldmethod=syntax

let b:current_syntax = "ciscoconfig"

" vim: set ts=4
