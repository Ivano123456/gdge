-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'cn' then return end

Strings = {
    
    -- 客户端通知
    unauthorized_title = '未经授权',
    unauthorized_message = '您无权使用此功能',
    not_on_duty_title = '未在值班',
    not_on_duty_message = '您必须在值班时间',
    gps_enabled_title = 'GPS已启用',
    gps_enabled_message = 'GPS追踪已启用',
    gps_disabled_title = 'GPS已禁用',
    gps_disabled_message = 'GPS追踪已禁用',
    
    -- 服务器通知
    not_tracked_job_title = '您不在被追踪的工作中',
    not_tracked_job_message = '您无法使用此物品',
    item_not_registered_title = '此物品未在您的工作中注册',
    item_not_registered_message = '您无法使用此物品',
    item_removed_title = 'GPS已禁用',
    item_removed_message = '由于您不再拥有所需物品，GPS已被禁用',
    
    -- 标记格式
    blip_name_format = '%s (%s)', -- 玩家名称 (工作标签)
    blip_name_far_format = '%s (%s) [远处]', -- 玩家名称 (工作标签) [远处]
    
    -- 默认值
    default_worker_name = '工作者 (%s)', -- 工作者 (来源ID)
    default_job_label = '工作者',
}
