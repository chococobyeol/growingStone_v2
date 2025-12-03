extends Node

# ▼ 본인 정보 입력 (따옴표 지우지 마세요!) ▼
const URL = "https://qrfulgjculsbtxgyfzpk.supabase.co"
const KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFyZnVsZ2pjdWxzYnR4Z3lmenBrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwMzc4MzgsImV4cCI6MjA3OTYxMzgzOH0.H1jMawnCj0p2tJtYDYQICcQkfWpVqF5OsJImrMVlDV8"
# ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲

signal auth_success
signal auth_failed(error_message)

func sign_in(email, password):
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_signin_completed.bind(http))
	
	var api_url = URL + "/auth/v1/token?grant_type=password"
	var headers = ["Content-Type: application/json", "apikey: " + KEY]
	var body = JSON.stringify({"email": email, "password": password})
	
	print("[INFO] Sending Sign In request...")
	var error = http.request(api_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("[ERROR] HTTP Request failed.")
		http.queue_free()

func sign_up(email, password):
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_signup_completed.bind(http))
	
	var api_url = URL + "/auth/v1/signup"
	var headers = ["Content-Type: application/json", "apikey: " + KEY]
	var body = JSON.stringify({"email": email, "password": password})
	
	print("[INFO] Sending Sign Up request...")
	var error = http.request(api_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("[ERROR] HTTP Request failed.")
		http.queue_free()

func _on_signin_completed(_result, response_code, _headers, body, http_node):
	var response_string = body.get_string_from_utf8()
	var response = JSON.parse_string(response_string)
	
	if response_code == 200:
		print("[SUCCESS] Sign In successful. ID: ", response.user.id)
		emit_signal("auth_success")
	elif response_code == 400:
		print("[ERROR] Sign In failed: Invalid credentials")
		emit_signal("auth_failed", "Invalid email or password")
	else:
		print("[ERROR] Server Error: ", response_code)
		emit_signal("auth_failed", "Server Error")
	http_node.queue_free()

func _on_signup_completed(_result, response_code, _headers, body, http_node):
	if response_code == 200 or response_code == 201:
		print("[SUCCESS] Sign Up successful.")
		emit_signal("auth_success")
	else:
		print("[ERROR] Sign Up failed: ", response_code)
		emit_signal("auth_failed", "Sign Up Failed")
	http_node.queue_free()
