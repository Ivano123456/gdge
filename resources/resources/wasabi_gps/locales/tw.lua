-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'tw' then return end

Strings = {

    
    -- 客戶端通知
    unauthorized_title = '未經授權',
    unauthorized_message = '您無權使用此功能',
    not_on_duty_title = '不在值班',
    not_on_duty_message = '您必須在值班時間',
    gps_enabled_title = 'GPS 已啟用',
    gps_enabled_message = 'GPS 追蹤已啟用',
    gps_disabled_title = 'GPS 已停用',
    gps_disabled_message = 'GPS 追蹤已停用',
    
    -- 伺服器通知
    not_tracked_job_title = '您不在追蹤的工作中',
    not_tracked_job_message = '您無法使用此物品',
    item_not_registered_title = '此物品未註冊到您的工作',
    item_not_registered_message = '您無法使用此物品',
    item_removed_title = 'GPS 已停用',
    item_removed_message = '由於您不再擁有所需物品，GPS 已被停用',
    
    -- 標記格式
    blip_name_format = '%s (%s)', -- 玩家名稱 (工作標籤)
    blip_name_far_format = '%s (%s) [遠處]', -- 玩家名稱 (工作標籤) [遠處]
    
    -- 預設值
    default_worker_name = '工作人員 (%s)', -- 工作人員 (來源ID)
    default_job_label = '工作人員',
}
