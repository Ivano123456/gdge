-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Language ~= 'hi' then return end

Strings = {

    
    -- क्लाइंट सूचनाएं
    unauthorized_title = 'अनधिकृत',
    unauthorized_message = 'आपको इसका उपयोग करने का अधिकार नहीं है',
    not_on_duty_title = 'ड्यूटी पर नहीं',
    not_on_duty_message = 'आपको ड्यूटी पर होना चाहिए',
    gps_enabled_title = 'GPS सक्षम',
    gps_enabled_message = 'GPS ट्रैकिंग सक्षम',
    gps_disabled_title = 'GPS अक्षम',
    gps_disabled_message = 'GPS ट्रैकिंग अक्षम',
    
    -- सर्वर सूचनाएं
    not_tracked_job_title = 'आप ट्रैक किए गए काम में नहीं हैं',
    not_tracked_job_message = 'आप इस वस्तु का उपयोग नहीं कर सकते',
    item_not_registered_title = 'यह वस्तु आपके काम के लिए पंजीकृत नहीं है',
    item_not_registered_message = 'आप इस वस्तु का उपयोग नहीं कर सकते',
    item_removed_title = 'GPS अक्षम',
    item_removed_message = 'GPS अक्षम कर दिया गया है क्योंकि आपके पास अब आवश्यक वस्तु नहीं है',
    
    -- ब्लिप फॉर्मेटिंग
    blip_name_format = '%s (%s)', -- खिलाड़ी का नाम (काम का लेबल)
    blip_name_far_format = '%s (%s) [दूर]', -- खिलाड़ी का नाम (काम का लेबल) [दूर]
    
    -- डिफ़ॉल्ट मान
    default_worker_name = 'कर्मचारी (%s)', -- कर्मचारी (स्रोत आईडी)
    default_job_label = 'कर्मचारी',
}
