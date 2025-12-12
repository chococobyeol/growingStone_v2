extends Node2D

var is_widget_mode = true
var is_dragging = false
var drag_offset = Vector2i.ZERO # 드래그 시작 시 마우스와 창 모서리 간의 거리

@onready var stone = $Stone

func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	
	# 시작하자마자 위젯 모드로 (크기는 1152x648 고정)
	# 위치 이동 코드는 다 뺐습니다. 에디터 설정 그대로 씁니다.
	apply_widget_mode()

func _process(_delta):
	if is_dragging:
		# 1. 현재 마우스 위치 가져오기
		var current_mouse_pos = DisplayServer.mouse_get_position()
		
		# 2. "원래 가려고 했던" 창의 위치 계산
		var target_pos = current_mouse_pos - drag_offset
		
		# 3. 현재 윈도우와 화면 정보 가져오기
		var window = get_window()
		var window_size = window.size
		var screen_id = window.current_screen
		
		# [핵심] '전체 화면'이 아니라 '사용 가능 영역(Usable Rect)'을 가져옵니다.
		# (상단 메뉴바와 하단 독을 제외한 안전한 영역)
		var safe_area = DisplayServer.screen_get_usable_rect(screen_id)
		
		# 4. 가두리 양식장 계산 (돌이 화면 끝에 닿을락 말락 할 때까지만 허용)
		# 돌은 창의 정중앙(576, 324)에 있으므로, 창은 화면 밖으로 그만큼 나가야 함
		var center_x = window_size.x / 2
		var center_y = window_size.y / 2
		
		# [진동 방지 꿀팁] 안전 구역에서 1픽셀씩 더 안쪽으로 잡습니다.
		# OS가 "너 선 넘었어!" 하고 밀어내는 걸 방지하기 위함입니다.
		var min_x = safe_area.position.x - center_x + 1
		var max_x = (safe_area.position.x + safe_area.size.x) - center_x - 1
		
		var min_y = safe_area.position.y - center_y + 1
		var max_y = (safe_area.position.y + safe_area.size.y) - center_y - 1
		
		# 5. 좌표 가두기 (Clamp)
		target_pos.x = clamp(target_pos.x, min_x, max_x)
		target_pos.y = clamp(target_pos.y, min_y, max_y)
		
		# 6. 위치 적용
		window.position = target_pos
		
		# 7. 마우스 놓침 방지
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_dragging = false

func _on_stone_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if event.double_click:
					# 더블클릭이면 모드 전환
					is_dragging = false # 드래그 취소
					toggle_mode()
				else:
					# [핵심] 드래그 시작 시점의 '차이(Offset)'를 기억합니다.
					is_dragging = true
					# (현재 마우스 절대 위치) - (현재 창 위치)
					drag_offset = DisplayServer.mouse_get_position() - get_window().position
			else:
				is_dragging = false

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
	window.always_on_top = true

func apply_window_mode():
	var window = get_window()
	window.mouse_passthrough = false
	window.borderless = false
	window.transparent = false
	window.transparent_bg = false
	window.always_on_top = false