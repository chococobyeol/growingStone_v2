extends Node2D

var is_widget_mode = true
@onready var stone = $Stone

func _ready():
	print("[DEBUG] Main 씬 진입 (물리 신호 방식 복구)")
	
	# 맥북 윈도우 안정화 대기
	await get_tree().process_frame
	await get_tree().process_frame
	
	# 시작하자마자 위젯 모드 적용
	apply_widget_mode()

# ▼▼▼ [정석] 물리 객체 신호로 감지 (이제 콜리전이 커져서 잘 될 겁니다!) ▼▼▼
func _on_stone_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# 더블클릭 감지
			if event.double_click:
				print("[입력] 더블 클릭 감지 -> 모드 전환")
				toggle_mode()
			else:
				# (나중에 여기에 '돌 키우기' 기능이 들어갑니다)
				print("[입력] 한번 클릭 (쓰다듬기)")

func toggle_mode():
	is_widget_mode = !is_widget_mode
	if is_widget_mode:
		apply_widget_mode()
	else:
		apply_window_mode()

func apply_widget_mode():
	var window = get_window()
	window.mouse_passthrough = false
	window.transparent_bg = true
	window.transparent = true
	window.borderless = true
	window.size = Vector2i(300, 300)
	window.always_on_top = true
	
	# 물리 서버를 통해 위치 강제 이동 (깜빡임 방지)
	if stone:
		PhysicsServer2D.body_set_state(
			stone.get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D(0, Vector2(150, 150))
		)
		PhysicsServer2D.body_set_state(stone.get_rid(), PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, Vector2.ZERO)

func apply_window_mode():
	var window = get_window()
	window.mouse_passthrough = false
	window.borderless = false
	window.transparent = false
	window.transparent_bg = false
	window.size = Vector2i(1152, 648)
	window.always_on_top = false
	window.move_to_center()
	
	# 큰 화면 중앙으로 이동
	if stone:
		PhysicsServer2D.body_set_state(
			stone.get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D(0, Vector2(1152.0/2, 648.0/2))
		)
		PhysicsServer2D.body_set_state(stone.get_rid(), PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, Vector2.ZERO)