extends Node

@onready var player: CharacterBody3D = $Player

#BACKEND

var previous_level = "none"
var is_fullscreen = false
var use_mobile = false
var move_mouse = false

#Grabpack_Related

var line_power = false
var current_powered_poles = 0
var l_launched = false
var r_launched = false
var r_pos = Vector3()
var l_pos = Vector3()
var source_hand = false
var rotating_pillar = false
var itemL_pos = Vector3()
var itemR_pos = Vector3()
var itemR_cast_point = Vector3()
var itemL_cast_point = Vector3()
var item_linear_vel
var item_position
var item_pos_transform
var left_click = false
var right_click = false
var has_mask = false
var current_pack = 0
var player_position = Vector3()
var player_transform
var camera_position = Vector3()
var can_move = true
var has_watch = false

#Hand Variables
var current_hand = 0
#Green Hand
var green_powered = false
#Flare Hand
var flare_spawn_position = Vector3()
#Dash Hand
var is_dashing = false

#Puzzle
var socket_pos = Vector3()
var socket_rot = Vector3()
