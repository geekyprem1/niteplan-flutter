// ─────────────────────────────────────────────────────────────
// NitePlan — All App Strings
// English + Hinglish (NOT traditional Hindi)
// ─────────────────────────────────────────────────────────────

enum AppLanguage { english, hinglish }

class AppStrings {
  static const Map<String, Map<AppLanguage, String>> _strings = {

    // ── APP ──
    'app_name': {AppLanguage.english: 'NitePlan', AppLanguage.hinglish: 'NitePlan'},
    'app_tagline': {AppLanguage.english: 'Plan the night. Grow every day.', AppLanguage.hinglish: 'Raat ko plan karo. Har roz grow karo.'},

    // ── TABS ──
    'tab_plan': {AppLanguage.english: 'Plan', AppLanguage.hinglish: 'Plan'},
    'tab_focus': {AppLanguage.english: 'Focus', AppLanguage.hinglish: 'Focus'},
    'tab_reflect': {AppLanguage.english: 'Reflect', AppLanguage.hinglish: 'Reflect'},
    'tab_score': {AppLanguage.english: 'Score', AppLanguage.hinglish: 'Score'},

    // ── APP BAR TITLES ──
    'appbar_plan': {AppLanguage.english: 'Plan It', AppLanguage.hinglish: 'Plan Karo'},
    'appbar_focus': {AppLanguage.english: 'Focus Now', AppLanguage.hinglish: 'Focus Karo'},
    'appbar_reflect': {AppLanguage.english: 'Reflect', AppLanguage.hinglish: 'Reflect Karo'},
    'appbar_score': {AppLanguage.english: 'Grow', AppLanguage.hinglish: 'Grow Karo'},

    // ── SCHEDULER TAB ──
    'scheduler_section_label': {AppLanguage.english: 'PLANNING', AppLanguage.hinglish: 'PLANNING'},
    'scheduler_title': {AppLanguage.english: "Tonight's Plan", AppLanguage.hinglish: 'Aaj Raat Ka Plan'},
    'scheduler_add_task': {AppLanguage.english: 'Schedule New Task', AppLanguage.hinglish: 'Naya Kaam Schedule Karo'},
    'scheduler_task_title': {AppLanguage.english: 'Task title *', AppLanguage.hinglish: 'Kaam ka title *'},
    'scheduler_details': {AppLanguage.english: 'Details (optional)', AppLanguage.hinglish: 'Details (optional)'},
    'scheduler_life_area': {AppLanguage.english: 'Life Area', AppLanguage.hinglish: 'Life Area'},
    'scheduler_when': {AppLanguage.english: 'When?', AppLanguage.hinglish: 'Kab karna hai?'},
    'scheduler_duration': {AppLanguage.english: 'How long?', AppLanguage.hinglish: 'Kitna time lagega?'},
    'scheduler_save_btn': {AppLanguage.english: 'Plan It', AppLanguage.hinglish: 'Plan Karo'},
    'scheduler_empty_title': {AppLanguage.english: 'No plans yet', AppLanguage.hinglish: 'Aaj koi plan nahi hai'},
    'scheduler_empty_sub': {AppLanguage.english: 'Schedule tonight\'s tasks using the form above', AppLanguage.hinglish: 'Upar form se aaj raat ke liye kaam schedule karo'},
    'scheduler_pending_count': {AppLanguage.english: "Tonight's Plan", AppLanguage.hinglish: 'Aaj Ki Planning'},

    // ── FOCUS / TIMER TAB ──
    'timer_section_label': {AppLanguage.english: 'FOCUS TIMER', AppLanguage.hinglish: 'FOCUS TIMER'},
    'timer_title': {AppLanguage.english: 'Current Focus', AppLanguage.hinglish: 'Abhi Ka Focus'},
    'timer_no_task': {AppLanguage.english: 'No task running', AppLanguage.hinglish: 'Koi task running nahi'},
    'timer_no_task_sub': {AppLanguage.english: 'Start a task from the Plan tab or pick one below', AppLanguage.hinglish: 'Planning tab se kaam start karo ya niche se koi task shuru karo'},
    'timer_live': {AppLanguage.english: 'LIVE', AppLanguage.hinglish: 'LIVE'},
    'timer_target': {AppLanguage.english: 'min target', AppLanguage.hinglish: 'min target'},
    'timer_done_btn': {AppLanguage.english: 'Done! ✅', AppLanguage.hinglish: 'Ho Gaya! ✅'},
    'timer_fail_btn': {AppLanguage.english: "Couldn't finish", AppLanguage.hinglish: 'Nahi Ho Paya'},
    'timer_pending_title': {AppLanguage.english: 'Pending — Start Now', AppLanguage.hinglish: 'Pending Tasks — Shuru Karo'},
    'timer_tap_start': {AppLanguage.english: 'Tap to start', AppLanguage.hinglish: 'Tap to start'},
    'timer_today_result': {AppLanguage.english: "Today's Result", AppLanguage.hinglish: 'Aaj Ka Result'},
    'timer_running': {AppLanguage.english: 'Running...', AppLanguage.hinglish: 'Running...'},
    'timer_paused': {AppLanguage.english: 'Paused', AppLanguage.hinglish: 'Paused'},
    'timer_percent_done': {AppLanguage.english: 'done', AppLanguage.hinglish: 'done'},

    // ── REFLECTION TAB ──
    'reflect_section_label': {AppLanguage.english: 'DAILY REFLECTION', AppLanguage.hinglish: 'DAILY REFLECTION'},
    'reflect_saved': {AppLanguage.english: 'Saved', AppLanguage.hinglish: 'Saved'},
    'reflect_mood': {AppLanguage.english: 'How was your mood today?', AppLanguage.hinglish: 'Aaj ka mood kaisa tha?'},
    'reflect_q1': {AppLanguage.english: 'What went well today?', AppLanguage.hinglish: 'Aaj kya acha gaya?'},
    'reflect_q1_hint': {AppLanguage.english: 'Which tasks were completed? Any wins?', AppLanguage.hinglish: 'Kaunse kaam poore hue? Kya positive hua?'},
    'reflect_q2': {AppLanguage.english: "What didn't happen?", AppLanguage.hinglish: 'Kya nahi ho paya?'},
    'reflect_q2_hint': {AppLanguage.english: 'Which tasks were missed or incomplete?', AppLanguage.hinglish: 'Kaunse tasks miss hue ya adhure rahe?'},
    'reflect_q3': {AppLanguage.english: 'Why did it fail?', AppLanguage.hinglish: 'Kyun nahi ho paya?'},
    'reflect_q3_hint': {AppLanguage.english: 'Be honest — distraction? Fatigue? Poor planning?', AppLanguage.hinglish: 'Honest raho — distraction? Thakaan? Planning?'},
    'reflect_q4': {AppLanguage.english: 'What will I do better tomorrow?', AppLanguage.hinglish: 'Kal kya better karunga?'},
    'reflect_q4_hint': {AppLanguage.english: 'One specific thing you will improve', AppLanguage.hinglish: 'Ek specific cheez jo improve karoge'},
    'reflect_save_btn': {AppLanguage.english: 'Save Reflection', AppLanguage.hinglish: 'Reflection Save Karo'},
    'reflect_update_btn': {AppLanguage.english: 'Update Reflection', AppLanguage.hinglish: 'Update Reflection'},
    'reflect_past_title': {AppLanguage.english: 'Past Reflections', AppLanguage.hinglish: 'Pichli Reflections'},
    'reflect_past_sub': {AppLanguage.english: 'Last 30 days', AppLanguage.hinglish: 'Last 30 days'},
    'reflect_tap_read': {AppLanguage.english: 'Tap to read', AppLanguage.hinglish: 'Tap to read'},

    // ── DISCIPLINE SCORE TAB ──
    'score_section_label': {AppLanguage.english: 'DISCIPLINE SCORE', AppLanguage.hinglish: 'DISCIPLINE SCORE'},
    'score_subtitle': {AppLanguage.english: 'Mirror of your consistency', AppLanguage.hinglish: 'Aapki consistency ka mirror'},
    'score_out_of': {AppLanguage.english: 'out of 100', AppLanguage.hinglish: 'out of 100'},
    'score_breakdown': {AppLanguage.english: 'Score Breakdown', AppLanguage.hinglish: 'Score Breakdown'},
    'score_history': {AppLanguage.english: 'Score History (7 days)', AppLanguage.hinglish: 'Score History (7 days)'},
    'score_failure_title': {AppLanguage.english: 'Failure Intelligence', AppLanguage.hinglish: 'Failure Intelligence'},
    'score_failure_sub': {AppLanguage.english: 'Why do you fail?', AppLanguage.hinglish: 'Kyun fail hote ho?'},
    'score_no_failure': {AppLanguage.english: 'No failure data yet. Complete tasks and add reasons!', AppLanguage.hinglish: 'Abhi koi failure data nahi hai. Tasks complete karo aur reason dalo!'},
    'score_life_area': {AppLanguage.english: 'Life Area Performance', AppLanguage.hinglish: 'Life Area Performance'},
    'score_weekly_btn': {AppLanguage.english: 'Weekly CEO Review', AppLanguage.hinglish: 'Weekly CEO Review'},
    'score_weekly_sub': {AppLanguage.english: 'View your weekly performance report', AppLanguage.hinglish: 'Apna weekly performance report dekho'},

    // ── WEEKLY REVIEW ──
    'weekly_title': {AppLanguage.english: 'Weekly CEO Review', AppLanguage.hinglish: 'Weekly CEO Review'},
    'weekly_your_report': {AppLanguage.english: 'YOUR WEEKLY REPORT', AppLanguage.hinglish: 'AAPKI WEEKLY REPORT'},
    'weekly_tasks_done': {AppLanguage.english: 'Tasks Done', AppLanguage.hinglish: 'Tasks Done'},
    'weekly_missed': {AppLanguage.english: 'Missed', AppLanguage.hinglish: 'Missed'},
    'weekly_success_rate': {AppLanguage.english: 'Success Rate', AppLanguage.hinglish: 'Success Rate'},
    'weekly_planning_acc': {AppLanguage.english: 'Planning Accuracy', AppLanguage.hinglish: 'Planning Accuracy'},
    'weekly_plan_excellent': {AppLanguage.english: 'Excellent! You plan realistically.', AppLanguage.hinglish: 'Zabardast! Realistic plan karte ho.'},
    'weekly_plan_ok': {AppLanguage.english: 'Room to improve. Plan fewer, do more.', AppLanguage.hinglish: 'Improve karo. Kam plan karo, zyada karo.'},
    'weekly_plan_low': {AppLanguage.english: 'Over-planning detected. Start smaller.', AppLanguage.hinglish: 'Over-planning ho rahi hai. Chhote shuru karo.'},
    'weekly_best_day': {AppLanguage.english: 'Best Day', AppLanguage.hinglish: 'Best Day'},
    'weekly_worst_day': {AppLanguage.english: 'Worst Day', AppLanguage.hinglish: 'Worst Day'},
    'weekly_top_failure': {AppLanguage.english: 'Top Failure Reason', AppLanguage.hinglish: 'Top Failure Reason'},
    'weekly_failure_msg': {AppLanguage.english: 'This pattern is hurting your execution most.', AppLanguage.hinglish: 'Ye pattern execution ko sabse zyada nuksan pahunchata hai.'},
    'weekly_avg_score': {AppLanguage.english: 'Avg Discipline Score', AppLanguage.hinglish: 'Avg Discipline Score'},
    'weekly_score_strong': {AppLanguage.english: 'Strong week! Keep the momentum.', AppLanguage.hinglish: 'Strong week! Momentum raho.'},
    'weekly_score_ok': {AppLanguage.english: 'Focus on consistency this week.', AppLanguage.hinglish: 'Is hafte consistency pe focus karo.'},
    'weekly_improve_area': {AppLanguage.english: 'Improve This Week', AppLanguage.hinglish: 'Is Hafte Improve Karo'},
    'weekly_improve_msg': {AppLanguage.english: 'This life area needs your attention most.', AppLanguage.hinglish: 'Is life area pe dhyan chahiye.'},

    // ── AUTH SCREEN ──
    'auth_google_btn': {AppLanguage.english: 'Sign in with Google', AppLanguage.hinglish: 'Google Se Sign In Karo'},
    'auth_guest_btn': {AppLanguage.english: 'Continue as Guest', AppLanguage.hinglish: 'Guest Mode Se Continue Karo'},
    'auth_guest_warning': {AppLanguage.english: 'In guest mode, data stays on this device only.', AppLanguage.hinglish: 'Guest mode mein data sirf is device pe rahega.'},

    // ── ONBOARDING ──
    'onboard_start_btn': {AppLanguage.english: "Let's Begin 🚀", AppLanguage.hinglish: 'Shuru Karte Hain 🚀'},
    'onboard_lang_title': {AppLanguage.english: 'How would you like NitePlan to guide you?', AppLanguage.hinglish: 'NitePlan tumhe kaise guide kare?'},
    'onboard_lang_sub': {AppLanguage.english: 'Choose the language that feels most natural to you.', AppLanguage.hinglish: 'Jo language natural lage wo chunao.'},
    'onboard_lang_en_label': {AppLanguage.english: 'English', AppLanguage.hinglish: 'English'},
    'onboard_lang_en_sub': {AppLanguage.english: 'Everything in English', AppLanguage.hinglish: 'Everything in English'},
    'onboard_lang_hi_label': {AppLanguage.english: 'Hinglish', AppLanguage.hinglish: 'Hinglish'},
    'onboard_lang_hi_sub': {AppLanguage.english: 'English with natural Hindi coaching', AppLanguage.hinglish: 'Hindi coaching ke saath English'},
    'onboard_struggle_title': {AppLanguage.english: "What's your biggest challenge?", AppLanguage.hinglish: 'Aapki sabse badi problem kya hai?'},
    'onboard_struggle_sub': {AppLanguage.english: 'Be honest — this app will help you solve it.', AppLanguage.hinglish: 'Honest raho — ye app aapko solve karne mein help karegi.'},
    'onboard_goal_title': {AppLanguage.english: "What's your primary goal?", AppLanguage.hinglish: 'Aapka primary goal kya hai?'},
    'onboard_goal_sub': {AppLanguage.english: 'This area will get maximum focus in the app.', AppLanguage.hinglish: 'Is area pe sabse zyada focus milega.'},
    'onboard_next_btn': {AppLanguage.english: 'Continue', AppLanguage.hinglish: 'Aage Badho'},
    'onboard_account_title': {AppLanguage.english: 'Create Your Account', AppLanguage.hinglish: 'Apna Account Banao'},
    'onboard_account_sub': {AppLanguage.english: 'Cloud sync ensures your data is never lost — even if you change phones.', AppLanguage.hinglish: 'Cloud sync se aapka data kabhi nahi jayega — chahe phone badlo ya app delete karo'},

    // ── PROFILE ──
    'profile_title': {AppLanguage.english: 'Profile & Settings', AppLanguage.hinglish: 'Profile & Settings'},
    'profile_guest': {AppLanguage.english: 'Guest User', AppLanguage.hinglish: 'Guest User'},
    'profile_guest_sub': {AppLanguage.english: 'Guest Mode — Data is local only', AppLanguage.hinglish: 'Guest Mode — Data local hai'},
    'profile_cloud_off': {AppLanguage.english: '⚠️ Cloud sync off', AppLanguage.hinglish: '⚠️ Cloud sync off'},
    'profile_link_google': {AppLanguage.english: 'Link with Google', AppLanguage.hinglish: 'Google Se Link Karo'},
    'profile_link_sub': {AppLanguage.english: 'Save data to cloud — never lose it', AppLanguage.hinglish: 'Data cloud pe save hoga — kabhi nahi jayega'},
    'profile_sync_now': {AppLanguage.english: 'Sync Now', AppLanguage.hinglish: 'Abhi Sync Karo'},
    'profile_sync_sub': {AppLanguage.english: 'Manually sync with cloud', AppLanguage.hinglish: 'Manually cloud se sync karo'},
    'profile_sync_done': {AppLanguage.english: '✅ Sync complete!', AppLanguage.hinglish: '✅ Sync complete!'},
    'profile_language': {AppLanguage.english: 'Language', AppLanguage.hinglish: 'Language'},
    'profile_language_sub': {AppLanguage.english: 'Change app language anytime', AppLanguage.hinglish: 'Kabhi bhi language badlo'},
    'profile_logout': {AppLanguage.english: 'Logout', AppLanguage.hinglish: 'Logout'},
    'profile_logout_sub': {AppLanguage.english: 'Sign out of your account', AppLanguage.hinglish: 'Account se sign out karein'},
    'profile_delete': {AppLanguage.english: 'Delete Account', AppLanguage.hinglish: 'Account Delete Karo'},
    'profile_delete_sub': {AppLanguage.english: 'Permanently delete all your data', AppLanguage.hinglish: 'Sab data permanently delete ho jayega'},

    // ── DIALOGS ──
    'dialog_cancel': {AppLanguage.english: 'Cancel', AppLanguage.hinglish: 'Cancel'},
    'dialog_confirm': {AppLanguage.english: 'Confirm', AppLanguage.hinglish: 'Confirm'},
    'dialog_later': {AppLanguage.english: 'Later', AppLanguage.hinglish: 'Baad Mein'},
    'dialog_save': {AppLanguage.english: 'Save', AppLanguage.hinglish: 'Save Karo'},
    'dialog_logout_title': {AppLanguage.english: 'Logout?', AppLanguage.hinglish: 'Logout Karna Chahte Ho?'},
    'dialog_logout_guest': {AppLanguage.english: 'Guest session will end. Local data stays on device.', AppLanguage.hinglish: 'Guest session khatam. Local data device pe rahega.'},
    'dialog_logout_user': {AppLanguage.english: "You'll be signed out. Cloud data is safe.", AppLanguage.hinglish: 'Sign out ho jaoge. Cloud data safe hai.'},
    'dialog_delete_title': {AppLanguage.english: '⚠️ Delete Account?', AppLanguage.hinglish: '⚠️ Account Delete?'},
    'dialog_delete_body': {AppLanguage.english: 'All your data — tasks, reflections, scores — will be permanently deleted. This cannot be undone.', AppLanguage.hinglish: 'Aapka saara data — tasks, reflections, scores — permanently delete ho jayega. Ye wapas nahi aayega.'},

    // ── TASK FEEDBACK DIALOG ──
    'feedback_title': {AppLanguage.english: 'Task Report', AppLanguage.hinglish: 'Task Report'},
    'feedback_done': {AppLanguage.english: '✅ Done', AppLanguage.hinglish: '✅ Ho Gaya'},
    'feedback_not_done': {AppLanguage.english: '❌ Not Done', AppLanguage.hinglish: '❌ Nahi Hua'},
    'feedback_how': {AppLanguage.english: 'How did it go?', AppLanguage.hinglish: 'Kaise ho gaya?'},
    'feedback_why': {AppLanguage.english: "Why didn't it happen?", AppLanguage.hinglish: 'Kyun nahi ho paya?'},
    'feedback_write': {AppLanguage.english: 'Or write your own...', AppLanguage.hinglish: 'Ya khud likho...'},
    'feedback_save': {AppLanguage.english: 'Save', AppLanguage.hinglish: 'Save Karo'},

    // ── BANNER / SCORE LABELS ──
    'banner_streak': {AppLanguage.english: 'day streak', AppLanguage.hinglish: 'day streak'},
    'score_beginner': {AppLanguage.english: 'Beginner', AppLanguage.hinglish: 'Beginner'},
    'score_building': {AppLanguage.english: 'Building', AppLanguage.hinglish: 'Building'},
    'score_consistent': {AppLanguage.english: 'Consistent', AppLanguage.hinglish: 'Consistent'},
    'score_disciplined': {AppLanguage.english: 'Disciplined', AppLanguage.hinglish: 'Disciplined'},
    'score_elite': {AppLanguage.english: 'Elite 🔥', AppLanguage.hinglish: 'Elite 🔥'},

    // ── TASK ALERT OVERLAY ──
    'alert_title': {AppLanguage.english: 'Time for your task!', AppLanguage.hinglish: 'Kaam Ka Waqt Ho Gaya!'},
    'alert_start_btn': {AppLanguage.english: "Let's Go! 🚀", AppLanguage.hinglish: 'Chalo Shuru Karte Hain! 🚀'},
    'alert_later': {AppLanguage.english: 'Later', AppLanguage.hinglish: 'Baad mein'},

    // ── FUTURE SELF LETTERS ──
    'letter_screen_title': {AppLanguage.english: 'Future Self Letters', AppLanguage.hinglish: 'Future Self Letters'},
    'letter_intro_title': {AppLanguage.english: 'Write to your future self', AppLanguage.hinglish: 'Apne Future Self ko likho'},
    'letter_intro_sub': {AppLanguage.english: 'Write a letter today — it unlocks after 30, 90 or 180 days automatically.', AppLanguage.hinglish: 'Jo letter aaj likhoge, wo 30, 90 ya 180 din baad automatically unlock hoga.'},
    'letter_new_title': {AppLanguage.english: 'Write a New Letter', AppLanguage.hinglish: 'Naya Letter Likho'},
    'letter_title_field': {AppLanguage.english: 'Letter title', AppLanguage.hinglish: 'Letter ka title'},
    'letter_content_field': {AppLanguage.english: 'Write to your future self...', AppLanguage.hinglish: 'Apne future self ko likho...'},
    'letter_unlock_when': {AppLanguage.english: 'When should it unlock?', AppLanguage.hinglish: 'Kab unlock ho?'},
    'letter_unlocked_section': {AppLanguage.english: '📬 Unlocked Letters', AppLanguage.hinglish: '📬 Unlocked Letters'},
    'letter_locked_section': {AppLanguage.english: '🔒 Locked Letters', AppLanguage.hinglish: '🔒 Locked Letters'},
    'letter_unlocked_tap': {AppLanguage.english: 'Tap to read', AppLanguage.hinglish: 'Tap to read'},
    'letter_empty_title': {AppLanguage.english: 'No letters yet', AppLanguage.hinglish: 'Koi letter nahi likha abhi tak'},
    'letter_empty_sub': {AppLanguage.english: 'Use + button to write a message to your future self', AppLanguage.hinglish: '+ button se apne future self ko message karo'},
    'letter_lock_btn_days': {AppLanguage.english: 'Lock for', AppLanguage.hinglish: 'Lock Karo'},
    'letter_days': {AppLanguage.english: 'days', AppLanguage.hinglish: 'din ke liye'},

    // ── LANGUAGE SELECTION ──
    'lang_select_title': {AppLanguage.english: 'How would you like NitePlan to guide you?', AppLanguage.hinglish: 'How would you like NitePlan to guide you?'},
    'lang_select_sub': {AppLanguage.english: 'Choose the language that feels most natural to you.', AppLanguage.hinglish: 'Choose the language that feels most natural to you.'},
    'lang_english_label': {AppLanguage.english: 'English', AppLanguage.hinglish: 'English'},
    'lang_english_sub': {AppLanguage.english: 'Everything in English', AppLanguage.hinglish: 'Everything in English'},
    'lang_hinglish_label': {AppLanguage.english: 'Hinglish', AppLanguage.hinglish: 'Hinglish'},
    'lang_hinglish_sub': {AppLanguage.english: 'English with natural Hindi coaching', AppLanguage.hinglish: 'Hindi coaching ke saath English'},

    // ── COMMON ──
    'planned': {AppLanguage.english: 'Planned', AppLanguage.hinglish: 'Planned'},
    'done': {AppLanguage.english: 'Done', AppLanguage.hinglish: 'Done'},
    'failed': {AppLanguage.english: 'Failed', AppLanguage.hinglish: 'Failed'},
    'accuracy': {AppLanguage.english: 'Accuracy', AppLanguage.hinglish: 'Accuracy'},
    'hour': {AppLanguage.english: 'Hour', AppLanguage.hinglish: 'Hour'},
    'minute': {AppLanguage.english: 'Minute', AppLanguage.hinglish: 'Minute'},
    'save': {AppLanguage.english: 'Save', AppLanguage.hinglish: 'Save Karo'},
    'update': {AppLanguage.english: 'Update', AppLanguage.hinglish: 'Update'},
    'delete': {AppLanguage.english: 'Delete', AppLanguage.hinglish: 'Delete'},
    'cancel': {AppLanguage.english: 'Cancel', AppLanguage.hinglish: 'Cancel'},
    'later': {AppLanguage.english: 'Later', AppLanguage.hinglish: 'Baad mein'},
    'loading': {AppLanguage.english: 'Loading...', AppLanguage.hinglish: 'Loading...'},
    'error': {AppLanguage.english: 'Something went wrong', AppLanguage.hinglish: 'Kuch gadbad ho gayi'},
    'no_data': {AppLanguage.english: 'No data yet', AppLanguage.hinglish: 'Abhi koi data nahi'},
    'days_label': {AppLanguage.english: 'days', AppLanguage.hinglish: 'din'},
    'mins_label': {AppLanguage.english: 'min', AppLanguage.hinglish: 'min'},
    'hrs_label': {AppLanguage.english: 'hrs', AppLanguage.hinglish: 'hrs'},
    'link_google_success': {AppLanguage.english: '✅ Account linked! Data synced.', AppLanguage.hinglish: '✅ Account link ho gaya! Data sync hua.'},
  };

  static String get(String key, AppLanguage language) {
    final entry = _strings[key];
    if (entry == null) return key; // fallback to key itself
    return entry[language] ?? entry[AppLanguage.english] ?? key;
  }

  static List<String> get allKeys => _strings.keys.toList();
}
