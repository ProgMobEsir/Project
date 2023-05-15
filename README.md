# Peer games
A flutter app using wifi peer to peer to play multiplayer games

# Release

[Release](https://github.com/ProgMobEsir/Project/releases/tag/StableRelease)

# Design

## Game Engine

A built in game engine able comming with colliders and renderer for images and simple shapes.
It can be used by creating a game object and adding it to the engine


## Menus
A menu contains buttons and will redirect

## GameManager
The game manager keeps the state of the app, and manage the peer to peer behaviour of the app

## Navigation Service

Navigation service permit to navigate without context in the app

# Usage

## Connect two devices 

1) select multiplayer on both devices
2) select host on a device and guest on another
3) on the host device, open a game room
4) on the guest device, search for a room and refresh the list until you found the other device.
5) select this device and click connect
6) on the host device, open the room
7) on the guest device, connect to the room
8) then on the host device, start the game

After that, the both devices will display a naming menu to name the player in multiplayer games
