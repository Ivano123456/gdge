-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'jp' then return end

Strings = {

    
    -- クライアント通知
    unauthorized_title = '権限なし',
    unauthorized_message = 'これを使用する権限がありません',
    not_on_duty_title = '勤務外',
    not_on_duty_message = '勤務中である必要があります',
    gps_enabled_title = 'GPS オン',
    gps_enabled_message = 'GPS追跡が有効になりました',
    gps_disabled_title = 'GPS オフ',
    gps_disabled_message = 'GPS追跡が無効になりました',
    
    -- サーバー通知
    not_tracked_job_title = '追跡対象の仕事についていません',
    not_tracked_job_message = 'このアイテムは使用できません',
    item_not_registered_title = 'このアイテムはあなたの仕事に登録されていません',
    item_not_registered_message = 'このアイテムは使用できません',
    item_removed_title = 'GPS オフ',
    item_removed_message = '必要なアイテムがないため、GPSが無効になりました',
    
    -- ブリップ形式
    blip_name_format = '%s (%s)', -- プレイヤー名 (職業ラベル)
    blip_name_far_format = '%s (%s) [遠方]', -- プレイヤー名 (職業ラベル) [遠方]
    
    -- デフォルト値
    default_worker_name = '作業員 (%s)', -- 作業員 (ソースID)
    default_job_label = '作業員',
}
