-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'ko' then return end

Strings = {

    
    -- 클라이언트 알림
    unauthorized_title = '권한 없음',
    unauthorized_message = '이 기능을 사용할 권한이 없습니다',
    not_on_duty_title = '근무 중이 아님',
    not_on_duty_message = '근무 중이어야 합니다',
    gps_enabled_title = 'GPS 활성화됨',
    gps_enabled_message = 'GPS 추적이 활성화되었습니다',
    gps_disabled_title = 'GPS 비활성화됨',
    gps_disabled_message = 'GPS 추적이 비활성화되었습니다',
    
    -- 서버 알림
    not_tracked_job_title = '추적되는 직업이 아닙니다',
    not_tracked_job_message = '이 아이템을 사용할 수 없습니다',
    item_not_registered_title = '이 아이템은 당신의 직업에 등록되지 않았습니다',
    item_not_registered_message = '이 아이템을 사용할 수 없습니다',
    item_removed_title = 'GPS 비활성화됨',
    item_removed_message = '필요한 아이템이 없어 GPS가 비활성화되었습니다',
    
    -- 블립 형식
    blip_name_format = '%s (%s)', -- 플레이어 이름 (직업 라벨)
    blip_name_far_format = '%s (%s) [멀리]', -- 플레이어 이름 (직업 라벨) [멀리]
    
    -- 기본값
    default_worker_name = '작업자 (%s)', -- 작업자 (소스 ID)
    default_job_label = '작업자',
}
