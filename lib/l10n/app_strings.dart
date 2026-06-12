// ─────────────────────────────────────────────────────────────
// NitePlan — All App Strings
// English + Hinglish (NOT traditional Hindi)
// ─────────────────────────────────────────────────────────────

enum AppLanguage { english, hinglish }

class AppStrings {
  static const Map<String, Map<AppLanguage, String>> _strings = {

    // ── APP ──
    'app_name': {AppLanguage.english: 'Whyly', AppLanguage.hinglish: 'Whyly'},
    'app_tagline': {AppLanguage.english: 'Discover Why You Fail. Build The Discipline To Succeed.', AppLanguage.hinglish: 'Samjho fail kyun hote ho. Success ki discipline banao.'},

    // ── TABS ──
    'tab_plan': {AppLanguage.english: 'Plan', AppLanguage.hinglish: 'Plan'},
    'tab_focus': {AppLanguage.english: 'Focus', AppLanguage.hinglish: 'Focus'},
    'tab_reflect': {AppLanguage.english: 'Understand', AppLanguage.hinglish: 'Samjho'},
    'tab_score': {AppLanguage.english: 'Patterns', AppLanguage.hinglish: 'Patterns'},

    // ── APP BAR TITLES ──
    'appbar_plan': {AppLanguage.english: 'Plan Your Move', AppLanguage.hinglish: 'Agla Move Plan Karo'},
    'appbar_focus': {AppLanguage.english: 'Keep Your Promise', AppLanguage.hinglish: 'Waada Poora Karo'},
    'appbar_reflect': {AppLanguage.english: 'Understanding Yourself', AppLanguage.hinglish: 'Apne Aap Ko Samjho'},
    'appbar_score': {AppLanguage.english: 'Your Patterns', AppLanguage.hinglish: 'Aapke Patterns'},

    // ── SCHEDULER TAB ──
    'scheduler_section_label': {AppLanguage.english: 'PLANS & PROMISES', AppLanguage.hinglish: 'PLANS & PROMISES'},
    'scheduler_title': {AppLanguage.english: 'Plan Your Next Move', AppLanguage.hinglish: 'Apna Agla Move Plan Karo'},
    'scheduler_add_task': {AppLanguage.english: 'Plan Your Next Move', AppLanguage.hinglish: 'Naya Move Plan Karo'},
    'scheduler_add_task_short': {AppLanguage.english: 'Plan Move', AppLanguage.hinglish: 'Plan Move'},
    'scheduler_task_title': {AppLanguage.english: 'What is your next move? *', AppLanguage.hinglish: 'Aapka agla move kya hai? *'},
    'scheduler_details': {AppLanguage.english: 'Details (optional)', AppLanguage.hinglish: 'Details (optional)'},
    'scheduler_life_area': {AppLanguage.english: 'Life Area', AppLanguage.hinglish: 'Life Area'},
    'scheduler_when': {AppLanguage.english: 'When?', AppLanguage.hinglish: 'Kab karna hai?'},
    'scheduler_duration': {AppLanguage.english: 'How long?', AppLanguage.hinglish: 'Kitna time lagega?'},
    'scheduler_save_btn': {AppLanguage.english: 'Commit to Plan', AppLanguage.hinglish: 'Plan Commit Karo'},
    'scheduler_empty_title': {AppLanguage.english: 'No tasks planned yet.', AppLanguage.hinglish: 'Abhi koi planned move nahi hai.'},
    'scheduler_empty_sub': {AppLanguage.english: 'Every achievement starts with a plan.', AppLanguage.hinglish: 'Har badi shuruat ek chhote plan se hoti hai.'},
    'scheduler_pending_count': {AppLanguage.english: 'Promises Made', AppLanguage.hinglish: 'Aaj Ke Waade'},

    // ── FOCUS / TIMER TAB ──
    'timer_section_label': {AppLanguage.english: 'FOCUS TIMER', AppLanguage.hinglish: 'FOCUS TIMER'},
    'timer_title': {AppLanguage.english: 'Current Focus', AppLanguage.hinglish: 'Abhi Ka Focus'},
    'timer_no_task': {AppLanguage.english: 'No active moves', AppLanguage.hinglish: 'Koi move active nahi hai'},
    'timer_no_task_sub': {AppLanguage.english: 'Select a plan below to begin execution.', AppLanguage.hinglish: 'Niche list se apna planned move select karke start karo.'},
    'timer_live': {AppLanguage.english: 'LIVE', AppLanguage.hinglish: 'LIVE'},
    'timer_target': {AppLanguage.english: 'min target', AppLanguage.hinglish: 'min target'},
    'timer_done_btn': {AppLanguage.english: 'Another Promise Kept ✅', AppLanguage.hinglish: 'Ek Aur Waada Poora Kiya ✅'},
    'timer_fail_btn': {AppLanguage.english: "Let's Understand What Happened", AppLanguage.hinglish: 'Chalo samjhein kya gadbad hui'},
    'timer_pending_title': {AppLanguage.english: 'Planned Moves — Start Now', AppLanguage.hinglish: 'Planned Moves — Shuru Karo'},
    'timer_tap_start': {AppLanguage.english: 'Tap to start', AppLanguage.hinglish: 'Tap to start'},
    'timer_today_result': {AppLanguage.english: "Today's Promises", AppLanguage.hinglish: 'Aaj Ke Waade'},
    'timer_running': {AppLanguage.english: 'Running...', AppLanguage.hinglish: 'Running...'},
    'timer_paused': {AppLanguage.english: 'Paused', AppLanguage.hinglish: 'Paused'},
    'timer_percent_done': {AppLanguage.english: 'done', AppLanguage.hinglish: 'done'},

    // ── REFLECTION TAB ──
    'reflect_section_label': {AppLanguage.english: 'UNDERSTANDING YOURSELF', AppLanguage.hinglish: 'APNE AAP KO SAMJHO'},
    'reflect_saved': {AppLanguage.english: 'Saved', AppLanguage.hinglish: 'Saved'},
    'reflect_mood': {AppLanguage.english: 'How did you feel today?', AppLanguage.hinglish: 'Aaj kaisa feel kar rahe ho?'},
    'reflect_q1': {AppLanguage.english: 'What promises did you keep today?', AppLanguage.hinglish: 'Aaj kaunse waade poore kiye?'},
    'reflect_q1_hint': {AppLanguage.english: 'Detail your successes and wins. Why did they go well?', AppLanguage.hinglish: 'Apni success aur wins likho. Kya achha raha?'},
    'reflect_q2': {AppLanguage.english: 'Where did you fail to follow through?', AppLanguage.hinglish: 'Aap kahan fail hue aaj?'},
    'reflect_q2_hint': {AppLanguage.english: 'Which tasks or plans did you miss?', AppLanguage.hinglish: 'Kaunse kaam adhure rahe ya chhut gaye?'},
    'reflect_q3': {AppLanguage.english: 'Discover why you failed.', AppLanguage.hinglish: 'Kyun fail hue? Honest raho.'},
    'reflect_q3_hint': {AppLanguage.english: 'Be completely honest — was it procrastination, distraction, low energy, or poor planning?', AppLanguage.hinglish: 'Sach bolo — phone distraction? Thakaan? Ya over-planning?'},
    'reflect_q4': {AppLanguage.english: 'How will you adjust your environment tomorrow?', AppLanguage.hinglish: 'Kal apni habits ko kaise improve karoge?'},
    'reflect_q4_hint': {AppLanguage.english: 'Write down one concrete change to build discipline.', AppLanguage.hinglish: 'Ek specific badlav jo discipline build karega.'},
    'reflect_save_btn': {AppLanguage.english: 'Save Self-Discovery Log', AppLanguage.hinglish: 'Self-Discovery Log Save Karo'},
    'reflect_update_btn': {AppLanguage.english: 'Update Self-Discovery Log', AppLanguage.hinglish: 'Self-Discovery Log Update Karo'},
    'reflect_past_title': {AppLanguage.english: 'Your Self-Discovery History', AppLanguage.hinglish: 'Aapki Self-Discovery History'},
    'reflect_past_sub': {AppLanguage.english: 'Last 30 days', AppLanguage.hinglish: 'Last 30 days'},
    'reflect_tap_read': {AppLanguage.english: 'Tap to read', AppLanguage.hinglish: 'Tap to read'},

    // ── DEDICATED REFLECTION CARD ──
    'reflect_title_card': {AppLanguage.english: 'Understanding Yourself', AppLanguage.hinglish: 'Apne Aap Ko Samjho'},
    'reflect_card_done': {AppLanguage.english: "You have completed today's self-discovery log. Keep analyzing your behavior.", AppLanguage.hinglish: 'Aapne aaj ka self-discovery log poora kiya. Apne behavior patterns ko analyze karte rahein.'},
    'reflect_card_pending': {AppLanguage.english: 'Take 30 seconds to reflect on your day and discover why you fail.', AppLanguage.hinglish: 'Apne din par 30 seconds ke liye reflect karein aur samjhein ki fail kyun hote hain.'},
    'reflect_card_cta_start': {AppLanguage.english: 'Reflect & Learn', AppLanguage.hinglish: 'Reflection Shuru Karo'},
    'reflect_card_cta_edit': {AppLanguage.english: 'Update Log', AppLanguage.hinglish: 'Log Update Karo'},

    // ── DISCIPLINE SCORE TAB ──
    'score_section_label': {AppLanguage.english: 'DISCIPLINE SCORE', AppLanguage.hinglish: 'DISCIPLINE SCORE'},
    'score_subtitle': {AppLanguage.english: 'Your self-improvement index', AppLanguage.hinglish: 'Aapki consistency ka mirror'},
    'score_out_of': {AppLanguage.english: 'out of 100', AppLanguage.hinglish: 'out of 100'},
    'score_breakdown': {AppLanguage.english: 'Score Breakdown', AppLanguage.hinglish: 'Score Breakdown'},
    'score_history': {AppLanguage.english: 'Score History (7 days)', AppLanguage.hinglish: 'Score History (7 days)'},
    'score_failure_title': {AppLanguage.english: 'Failure Intelligence', AppLanguage.hinglish: 'Failure Intelligence'},
    'score_failure_sub': {AppLanguage.english: 'Discover why you fail.', AppLanguage.hinglish: 'Aap fail kyun hote ho?'},
    'score_no_failure': {AppLanguage.english: "Your behavior tells a story. Let's collect enough data to understand it.", AppLanguage.hinglish: 'Aapka behavior ek kahani batata hai. Samajhne ke liye thoda data collect hone dein.'},
    'score_life_area': {AppLanguage.english: 'Life Area Performance', AppLanguage.hinglish: 'Life Area Performance'},
    'score_weekly_btn': {AppLanguage.english: 'Your Weekly Self-Discovery Report', AppLanguage.hinglish: 'Aapki Weekly Self-Discovery Report'},
    'score_weekly_sub': {AppLanguage.english: 'Analyze why you succeeded and why you failed', AppLanguage.hinglish: 'Dekho is hafte kahan safal hue aur kahan asafal'},
    'score_execution': {AppLanguage.english: '⚡ Execution Rate', AppLanguage.hinglish: '⚡ Execution Rate'},
    'score_consistency': {AppLanguage.english: '📅 Consistency', AppLanguage.hinglish: '📅 Consistency'},
    'score_planning': {AppLanguage.english: '🎯 Planning Accuracy', AppLanguage.hinglish: '🎯 Planning Accuracy'},
    'score_reflection': {AppLanguage.english: '🔍 Reflection', AppLanguage.hinglish: '🔍 Reflection'},

    // ── WEEKLY REVIEW ──
    'weekly_title': {AppLanguage.english: 'Weekly Self-Discovery Report', AppLanguage.hinglish: 'Weekly Self-Discovery Report'},
    'weekly_your_report': {AppLanguage.english: 'YOUR DISCOVERY REPORT', AppLanguage.hinglish: 'AAPKI DISCOVERY REPORT'},
    'weekly_tasks_done': {AppLanguage.english: 'Promises Kept', AppLanguage.hinglish: 'Waade Poore Kiye'},
    'weekly_missed': {AppLanguage.english: 'Promises Broken', AppLanguage.hinglish: 'Waade Adhure Rahe'},
    'weekly_success_rate': {AppLanguage.english: 'Execution Rate', AppLanguage.hinglish: 'Execution Rate'},
    'weekly_planning_acc': {AppLanguage.english: 'Planning Realism', AppLanguage.hinglish: 'Planning Realism'},
    'weekly_plan_excellent': {AppLanguage.english: 'Excellent! You set realistic commitments.', AppLanguage.hinglish: 'Bohot badhiya! Aap realistic plans banate ho.'},
    'weekly_plan_ok': {AppLanguage.english: 'Failing due to over-planning. Set fewer, higher-quality goals.', AppLanguage.hinglish: 'Over-planning se fail ho rahe ho. Kam aur solid goals rakho.'},
    'weekly_plan_low': {AppLanguage.english: 'Severe over-commitment. Reduce your plans by half to succeed.', AppLanguage.hinglish: 'Bohot zyada over-commitment. Apne plans ko aadha kar do.'},
    'weekly_best_day': {AppLanguage.english: 'Best Day', AppLanguage.hinglish: 'Best Day'},
    'weekly_worst_day': {AppLanguage.english: 'Worst Day', AppLanguage.hinglish: 'Worst Day'},
    'weekly_top_failure': {AppLanguage.english: 'Why You Failed Most', AppLanguage.hinglish: 'Failure Ka Sabse Bada Reason'},
    'weekly_failure_msg': {AppLanguage.english: 'This behavioral pattern is blocking your discipline.', AppLanguage.hinglish: 'Ye behavioral pattern aapki discipline ko rok raha hai.'},
    'weekly_avg_score': {AppLanguage.english: 'Avg Discipline Score', AppLanguage.hinglish: 'Avg Discipline Score'},
    'weekly_score_strong': {AppLanguage.english: 'Strong week! Keep the momentum.', AppLanguage.hinglish: 'Strong week! Momentum raho.'},
    'weekly_score_ok': {AppLanguage.english: 'Focus on consistency this week.', AppLanguage.hinglish: 'Is hafte consistency pe focus karo.'},
    'weekly_improve_area': {AppLanguage.english: 'Adjust Next Week', AppLanguage.hinglish: 'Adjust Next Week'},
    'weekly_improve_msg': {AppLanguage.english: 'Focus on improving this life area.', AppLanguage.hinglish: 'Is life area pe focus karo.'},

    // ── AUTH SCREEN ──
    'auth_google_btn': {AppLanguage.english: 'Sign in with Google', AppLanguage.hinglish: 'Google Se Sign In Karo'},
    'auth_guest_btn': {AppLanguage.english: 'Continue as Guest', AppLanguage.hinglish: 'Guest Mode Se Continue Karo'},
    'auth_guest_warning': {AppLanguage.english: 'In guest mode, data stays on this device only.', AppLanguage.hinglish: 'Guest mode mein data sirf is device pe rahega.'},

    // ── ONBOARDING ──
    'onboard_start_btn': {AppLanguage.english: "Let's Begin 🚀", AppLanguage.hinglish: 'Shuru Karte Hain 🚀'},
    'onboard_lang_title': {AppLanguage.english: 'How would you like Whyly to guide you?', AppLanguage.hinglish: 'Whyly tumhe kaise guide kare?'},
    'onboard_lang_sub': {AppLanguage.english: 'Choose the language that feels most natural to you.', AppLanguage.hinglish: 'Jo language natural lage wo chunao.'},
    'onboard_lang_en_label': {AppLanguage.english: 'English', AppLanguage.hinglish: 'English'},
    'onboard_lang_en_sub': {AppLanguage.english: 'Everything in English', AppLanguage.hinglish: 'Everything in English'},
    'onboard_lang_hi_label': {AppLanguage.english: 'Hinglish', AppLanguage.hinglish: 'Hinglish'},
    'onboard_lang_hi_sub': {AppLanguage.english: 'English with natural Hindi coaching', AppLanguage.hinglish: 'Hindi coaching ke saath English'},
    'onboard_struggle_title': {AppLanguage.english: 'What is your biggest failure trigger?', AppLanguage.hinglish: 'Aapka sabse bada failure trigger kya hai?'},
    'onboard_struggle_sub': {AppLanguage.english: "Most people know what to do. The problem is understanding why they don't do it.", AppLanguage.hinglish: 'Sabko pata hota hai kya karna hai. Problem ye hai ki hum karte kyun nahi.'},
    'onboard_goal_title': {AppLanguage.english: 'Where do you want to build discipline?', AppLanguage.hinglish: 'Aap kis area me discipline banana chahte hain?'},
    'onboard_goal_sub': {AppLanguage.english: 'This life area will be analyzed for consistency patterns.', AppLanguage.hinglish: 'Is area pe sabse zyada focus milega.'},
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
    'alert_title': {AppLanguage.english: 'Time to keep your promise', AppLanguage.hinglish: 'Waada poora karne ka waqt'},
    'alert_start_btn': {AppLanguage.english: 'Keep Promise 🚀', AppLanguage.hinglish: 'Waada Poora Karo 🚀'},
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
    'lang_select_title': {AppLanguage.english: 'How would you like Whyly to guide you?', AppLanguage.hinglish: 'How would you like Whyly to guide you?'},
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
    'home_progress_title': {AppLanguage.english: "Today's Promises", AppLanguage.hinglish: 'Aaj Ke Waade'},
    'home_planned': {AppLanguage.english: 'Committed', AppLanguage.hinglish: 'Committed'},
    'home_completed': {AppLanguage.english: 'Kept', AppLanguage.hinglish: 'Kept'},
    'home_remaining': {AppLanguage.english: 'Remaining', AppLanguage.hinglish: 'Remaining'},
    'home_insight_title': {AppLanguage.english: 'DAILY BEHAVIORAL INSIGHT', AppLanguage.hinglish: 'DAILY BEHAVIORAL INSIGHT'},
    'home_tasks_title': {AppLanguage.english: "TODAY'S PROMISES", AppLanguage.hinglish: 'AAJ KE WAADE'},
    'home_action_new': {AppLanguage.english: 'Plan Move', AppLanguage.hinglish: 'Plan Move'},
    'home_action_reflect': {AppLanguage.english: 'Understand', AppLanguage.hinglish: 'Understand'},
    'home_action_weekly': {AppLanguage.english: 'Discovery Report', AppLanguage.hinglish: 'Discovery Report'},
    'home_reflect_reminder': {AppLanguage.english: 'Take 30 seconds to reflect on your day and discover why you fail.', AppLanguage.hinglish: 'Apne din par reflect karo aur samjho ki kahan galti hui.'},
    'home_reflect_cta': {AppLanguage.english: 'Reflect & Learn', AppLanguage.hinglish: 'Reflection Shuru Karo'},
    'home_trend_title': {AppLanguage.english: 'this week', AppLanguage.hinglish: 'is hafte'},
    'home_trend_no_data': {AppLanguage.english: 'No history yet', AppLanguage.hinglish: 'Abhi koi history nahi'},

    // Onboarding struggles descriptions
    'onboard_struggle_procrastination_desc': {AppLanguage.english: 'Putting off promises for tomorrow', AppLanguage.hinglish: 'Apne waadon ko kal pe dalta rehta hoon'},
    'onboard_struggle_distraction_desc': {AppLanguage.english: 'Losing focus to phone & social media', AppLanguage.hinglish: 'Phone aur social media me dhyan bhatakna'},
    'onboard_struggle_consistency_desc': {AppLanguage.english: 'Starting strong, breaking chains early', AppLanguage.hinglish: 'Shuruat achhi karna, par consistency jaldi todna'},
    'onboard_struggle_time_management_desc': {AppLanguage.english: 'Planning too much and running out of time', AppLanguage.hinglish: 'Zyada commit karna aur waqt ki kami hona'},
    'onboard_struggle_focus_desc': {AppLanguage.english: 'Getting easily distracted while working', AppLanguage.hinglish: 'Kaam karte waqt dhyan bhatakta hai'},

    // Onboarding goals descriptions
    'onboard_goal_health_desc': {AppLanguage.english: 'Fit body, exercise, diet consistency', AppLanguage.hinglish: 'Health, fitness, and diet discipline'},
    'onboard_goal_business_desc': {AppLanguage.english: 'Discipline to build and grow my business', AppLanguage.hinglish: 'Business ko grow karne ki discipline'},
    'onboard_goal_career_desc': {AppLanguage.english: 'Skills advancement and focus at work', AppLanguage.hinglish: 'Career aur skills me focus badhana'},
    'onboard_goal_learning_desc': {AppLanguage.english: 'Consistent reading, learning, and courses', AppLanguage.hinglish: 'Padhai aur learning me regular rehna'},
    'onboard_goal_finance_desc': {AppLanguage.english: 'Financial discipline, savings, and investment', AppLanguage.hinglish: 'Paisa bachane aur invest karne ki discipline'},

    // Success Reasons
    'reason_success_focused': {AppLanguage.english: 'Fully Focused', AppLanguage.hinglish: 'Puri tarah focused (Fully Focused)'},
    'reason_success_early': {AppLanguage.english: 'Finished Early', AppLanguage.hinglish: 'Time se pehle khatam (Finished Early)'},
    'reason_success_easy': {AppLanguage.english: 'Easy Task', AppLanguage.hinglish: 'Asan kaam tha (Easy Task)'},
    'reason_success_energy': {AppLanguage.english: 'High Energy', AppLanguage.hinglish: 'Energy high thi (High Energy)'},
    'reason_success_no_distract': {AppLanguage.english: 'No Distractions', AppLanguage.hinglish: 'Koi distraction nahi thi (No Distractions)'},

    // Failure Reasons
    'reason_fail_distracted': {AppLanguage.english: 'Phone/Social Media', AppLanguage.hinglish: 'Phone/Social Media (Distracted)'},
    'reason_fail_tired': {AppLanguage.english: 'Tired/Sleepy', AppLanguage.hinglish: 'Thaka hua tha (Tired/Sleepy)'},
    'reason_fail_external': {AppLanguage.english: 'Urgent Work/External Event', AppLanguage.hinglish: 'Urgent kaam aa gaya (External Event)'},
    'reason_fail_planning': {AppLanguage.english: 'Poor Planning', AppLanguage.hinglish: 'Kaam zyada bada tha (Poor Planning)'},
    'reason_fail_motivation': {AppLanguage.english: 'Motivation Low', AppLanguage.hinglish: 'Mann nahi tha (Motivation Low)'},
    'reason_fail_time': {AppLanguage.english: 'Time Issues', AppLanguage.hinglish: 'Time nahi mila (Time Issues)'},

    // ── ONBOARDING & EMPTY STATES UX IMPROVEMENTS ──
    'app_tagline_premium': {AppLanguage.english: 'Discover Why You Fail', AppLanguage.hinglish: 'Samjho Fail Kyun Hote Ho'},
    'score_empty_level': {AppLanguage.english: 'Level 1 • Beginning Your Journey', AppLanguage.hinglish: 'Level 1 • Safar Ki Shuruat'},
    'score_empty_title': {AppLanguage.english: 'Your growth journey starts today.', AppLanguage.hinglish: 'Aapki growth journey aaj se shuru hoti hai.'},
    'score_empty_body': {AppLanguage.english: 'Complete your first task to unlock insights.', AppLanguage.hinglish: 'Insights unlock karne ke liye apna pehla task poora karo.'},
    'score_insight_strongest_prefix': {AppLanguage.english: 'Your strongest area is ', AppLanguage.hinglish: 'Aapka strongest area '},
    'score_insight_strongest_suffix': {AppLanguage.english: '. Keep it up!', AppLanguage.hinglish: ' hai. Aise hi karte raho!'},
    'score_insight_consistency': {AppLanguage.english: 'Your consistency is improving. Keep the momentum going!', AppLanguage.hinglish: 'Aapki consistency improve ho rahi hai. Momentum banaye rakho!'},
    'score_insight_milestone_prefix': {AppLanguage.english: "You've completed ", AppLanguage.hinglish: 'Aapne ab tak '},
    'score_insight_milestone_suffix': {AppLanguage.english: ' tasks so far. Great going!', AppLanguage.hinglish: ' tasks poore kiye hain. Bohot badhiya!'},
    'insight_empty_title': {AppLanguage.english: "We're still learning about you.", AppLanguage.hinglish: 'Hum seekh rahe hain.'},
    'insight_empty_body_1': {AppLanguage.english: "Complete a few tasks and Whyly will start discovering your patterns.", AppLanguage.hinglish: 'Kuch tasks complete karo aur Whyly aapke behavior patterns discover karna shuru karega.'},
    'insight_empty_body_2': {AppLanguage.english: "Your behavior tells a story. Let's collect enough data to understand it.", AppLanguage.hinglish: 'Aapka behavior ek kahani batata hai. Samajhne ke liye thoda data collect hone dein.'},
    'progress_empty_label': {AppLanguage.english: 'Commit to your moves', AppLanguage.hinglish: 'Plans set karo'},
    'progress_empty_body': {AppLanguage.english: 'Plan your first move to start building discipline.', AppLanguage.hinglish: 'Discipline shuru karne ke liye apna pehla planned move schedule karo.'},
    'tasks_empty_title': {AppLanguage.english: 'No tasks planned yet.', AppLanguage.hinglish: 'Abhi koi planned move nahi hai.'},
    'tasks_empty_desc': {AppLanguage.english: 'Every achievement starts with a plan.', AppLanguage.hinglish: 'Har badi shuruat ek chhote plan se hoti hai.'},
    'tasks_empty_cta': {AppLanguage.english: 'Plan Your Next Move', AppLanguage.hinglish: 'Naya Move Plan Karo'},
    'area_health': {AppLanguage.english: 'Health', AppLanguage.hinglish: 'Health'},
    'area_business': {AppLanguage.english: 'Business', AppLanguage.hinglish: 'Business'},
    'area_career': {AppLanguage.english: 'Career', AppLanguage.hinglish: 'Career'},
    'area_learning': {AppLanguage.english: 'Learning', AppLanguage.hinglish: 'Learning'},
    'area_finance': {AppLanguage.english: 'Finance', AppLanguage.hinglish: 'Finance'},
    'area_relationships': {AppLanguage.english: 'Relationships', AppLanguage.hinglish: 'Relationships'},
    'area_general': {AppLanguage.english: 'General', AppLanguage.hinglish: 'General'},

    // Failure category dynamic translations
    'fail_cat_distraction': {AppLanguage.english: 'Distraction', AppLanguage.hinglish: 'Distraction'},
    'fail_cat_lowEnergy': {AppLanguage.english: 'Low Energy', AppLanguage.hinglish: 'Thakaan (Low Energy)'},
    'fail_cat_timeIssues': {AppLanguage.english: 'Time Issues', AppLanguage.hinglish: 'Time Issues'},
    'fail_cat_poorPlanning': {AppLanguage.english: 'Poor Planning', AppLanguage.hinglish: 'Kaam Zyada Bada Tha (Poor Planning)'},
    'fail_cat_motivation': {AppLanguage.english: 'Low Motivation', AppLanguage.hinglish: 'Mann Nahi Tha (Low Motivation)'},
    'fail_cat_external': {AppLanguage.english: 'External Event', AppLanguage.hinglish: 'Urgent Kaam (External Event)'},
    'fail_cat_none': {AppLanguage.english: '', AppLanguage.hinglish: ''},
  };

  static String get(String key, AppLanguage language) {
    final entry = _strings[key];
    if (entry == null) return key; // fallback to key itself
    return entry[language] ?? entry[AppLanguage.english] ?? key;
  }

  static List<String> get allKeys => _strings.keys.toList();
}
