extends Control

@onready var email_input = $EmailInput
@onready var password_input = $PasswordInput
@onready var signin_button = $SigninButton
@onready var signup_button = $SignupButton
@onready var status_label = $StatusLabel

func _ready():
	# 로그인 화면은 크게 시작 (1152x648)
	var window = get_window()
	window.borderless = false
	window.transparent = false
	window.transparent_bg = false
	window.size = Vector2i(1152, 648)
	window.move_to_center()

	signin_button.pressed.connect(_on_signin_pressed)
	signup_button.pressed.connect(_on_signup_pressed)
	Auth.auth_success.connect(_on_auth_success)
	Auth.auth_failed.connect(_on_auth_failed)

func _on_signin_pressed():
	if _check_input():
		status_label.text = "Logging in..."
		Auth.sign_in(email_input.text, password_input.text)

func _on_signup_pressed():
	if _check_input():
		status_label.text = "Signing up..."
		Auth.sign_up(email_input.text, password_input.text)

func _check_input():
	if email_input.text == "" or password_input.text == "":
		status_label.text = "Enter email and password."
		return false
	return true

func _on_auth_success():
	status_label.text = "Success!"
	# 메인 화면으로 이동 (파일명 대소문자 주의)
	get_tree().change_scene_to_file("res://Main.tscn")

func _on_auth_failed(msg):
	status_label.text = "Error: " + str(msg)