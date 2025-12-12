extends RigidBody2D

# --- 성장 관련 변수 ---
var time_elapsed: float = 0.0 # 태어난 지 흐른 시간 (초)
var growth_speed: float = 0.5 # 성장 속도 계수 (조절 가능)
var initial_scale: float = 1.0 # 초기 크기

# --- 광물 정보 (추후 IMA 데이터와 연동될 변수들) ---
var mineral_name = "Unknown Mineral"
var crystal_structure = "Cubic" # 결정 구조 (나중에 시각적 반영)

func _ready():
	# 나중에는 여기서 원소 합성에 따라 광물 데이터를 결정합니다.
	# 지금은 랜덤하게 결정되었다고 가정하고 시작합니다.
	_init_random_mineral()

func _process(delta):
	# 1. 시간 경과 측정
	time_elapsed += delta
	
	# 2. 로그 함수 성장 공식 적용
	# 공식: 크기 = 초기크기 + (ln(시간 + 1) * 성장계수)
	# 특징: 초반엔 급격히 커지다가 시간이 갈수록 성장폭이 줄어듦
	var new_scale = initial_scale + (log(time_elapsed + 1.0) * growth_speed)
	
	# 3. 크기 적용 (Sprite2D와 충돌체 모두 적용됨)
	# scale은 Vector2 형태여야 합니다.
	self.scale = Vector2(new_scale, new_scale)

# 임시 광물 생성 (테스트용)
func _init_random_mineral():
	# 여기서는 시각적 요소(색상 등)만 랜덤으로 줍니다.
	# 추후 실제 원소 합성 로직이 들어올 자리입니다.
	var sprite = $Sprite2D
	var material = sprite.material as ShaderMaterial
	if material:
		# 랜덤 색상 부여 (나중에는 원소 비율에 따른 색상으로 변경)
		var random_color = Color(randf(), randf(), randf())
		material.set_shader_parameter("base_color", random_color)
		material.set_shader_parameter("roughness", randf_range(0.2, 0.9))
	
	print("[Mineral] 광물 생성 완료. 시간 기반 로그 성장을 시작합니다.")

	
# [추가] 외부(Main)에서 돌의 현재 실제 크기를 물어볼 때 답해주는 함수
func get_current_size() -> Vector2:
	var sprite = $Sprite2D
	if sprite and sprite.texture:
		# 이미지 원래 크기 * 현재 배율(Scale) = 실제 보이는 크기
		return sprite.texture.get_size() * self.scale
	return Vector2(100, 100) # 기본값