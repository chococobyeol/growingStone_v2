extends Node2D

func _ready():
    # 맥북 윈도우 매니저가 정신 차릴 시간 벌어주기
    await get_tree().process_frame
    await get_tree().process_frame
    
    # 강제로 투명화 및 테두리 제거 재적용
    get_window().transparent_bg = true
    get_window().transparent = true
    get_window().borderless = true