Language = Language or {}
Language['zh'] = { -- Simplified Chinese

    -- Blip Labels
    facility_blip = '维因伍德仓储',
    unit_blip = '存储单元 %s',

    -- Target Options
    office_target = '仓储办公室',
    enter_unit = '进入单元 %s',
    exit_unit = '离开单元',
    manage_items = '管理物品',
    raid_unit = '搜查单元 %s',

    -- Progress Bars
    cutting_lock = '正在切割锁具...',

    -- Notifications
    notify_title = '存储单元',
    insufficient_funds = '您没有足够的钱来执行此操作。',
    unit_rented = '您已租用存储单元 %s，租期 %s 天。',
    rent_paid = '您已支付单元 %s 的租金。剩余 %s 天。',
    password_changed = '您已更改单元 %s 的密码。',
    incorrect_password = '您输入的密码不正确。',
    unit_overdue = '您的单元已逾期 %s 天。请支付租金以访问单元。',
    item_added = '您已向单元添加了 %sx %s。',
    item_removed = '您已从单元移除了 %sx %s。',
    unit_full = '单元没有足够的空间容纳此物品。',
    need_raid_item = '您需要断线钳来搜查单元。',
    inventory_full = '您的库存空间不足，无法携带此物品。',

    -- UI Elements
    facility = '维因伍德仓储',
    office = '仓储办公室',
    your_units = '您的单元',
    available = '可用单元',
    no_available = '没有可用单元',
    max_rented = '最大租用单元数',
    rent_unit = '租用单元',
    no_owned = '没有租用的单元',
    unit_no = '单元编号 %s',
    unit_weight = '单元重量',
    days_remain = '剩余 %s 天',
    days_over = '逾期 %s 天',
    set_password = '设置密码',
    change_password = '更改密码',
    extend_lease = '延长租期',
    make_payment = '付款',
    your_items = '您的物品',
    unit_items = '单元物品',
    no_items = '无物品',
    cancel = '取消',
    confirm = '确认',
    search = '搜索',
    sort = '排序',
    ascend = '升序',
    descend = '降序',
    name = '名称',
    count = '数量',
    weight = '重量',

    rent_confirm = '您要以 $%s 的价格租用下一个可用单元 %s 天吗？',
    pay_confirm = '您要以 $%s 的价格延长租期 %s 天吗？',

    add_item_confirm = '您确定要存储 %sx %s 吗？',
    remove_item_confirm = '您确定要取回 %sx %s 吗？',

    disabled_for_raid = '搜查单元时禁用。',

    password_specs = '仅限数字，4-8个字符。',

    -- Logging
    player_id = '玩家ID',
    username = '用户名',
    identifier = '标识符',
    rented_unit = '已租用单元',
    paid_rent = '已支付租金',
    unit_evicted = '单元被清退',
    added_item = '已添加物品',
    removed_item = '已移除物品',
    unit_number = '单元编号',
    lease_period = '租赁期',
    item = '物品',
    quantity = '数量',

    -- Console
    resource_version = '%s | v%s',
    bridge_detected = '^2桥接已检测并加载。^0',
    bridge_not_detected = '^1未检测到桥接，请确保它正在运行。^0',
    cheater_print = '你试图智取系统。系统反过来智取了你。',
    debug_enabled = '^1调试模式已开启！请勿在生产环境中运行！^0',
}