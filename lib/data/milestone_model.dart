class Milestone {
  final String id;
  final String titleKey;
  final String descKey;
  final String category;

  const Milestone({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.category,
  });
}

class MilestoneRegistry {
  static const List<Milestone> milestones = [
    // ── Promises Kept Milestones (10) ──
    Milestone(id: 'kept_1', titleKey: 'ms_kept_1_title', descKey: 'ms_kept_1_desc', category: 'kept'),
    Milestone(id: 'kept_5', titleKey: 'ms_kept_5_title', descKey: 'ms_kept_5_desc', category: 'kept'),
    Milestone(id: 'kept_10', titleKey: 'ms_kept_10_title', descKey: 'ms_kept_10_desc', category: 'kept'),
    Milestone(id: 'kept_25', titleKey: 'ms_kept_25_title', descKey: 'ms_kept_25_desc', category: 'kept'),
    Milestone(id: 'kept_50', titleKey: 'ms_kept_50_title', descKey: 'ms_kept_50_desc', category: 'kept'),
    Milestone(id: 'kept_100', titleKey: 'ms_kept_100_title', descKey: 'ms_kept_100_desc', category: 'kept'),
    Milestone(id: 'kept_150', titleKey: 'ms_kept_150_title', descKey: 'ms_kept_150_desc', category: 'kept'),
    Milestone(id: 'kept_200', titleKey: 'ms_kept_200_title', descKey: 'ms_kept_200_desc', category: 'kept'),
    Milestone(id: 'kept_300', titleKey: 'ms_kept_300_title', descKey: 'ms_kept_300_desc', category: 'kept'),
    Milestone(id: 'kept_500', titleKey: 'ms_kept_500_title', descKey: 'ms_kept_500_desc', category: 'kept'),

    // ── Promises Made Milestones (10) ──
    Milestone(id: 'made_1', titleKey: 'ms_made_1_title', descKey: 'ms_made_1_desc', category: 'made'),
    Milestone(id: 'made_5', titleKey: 'ms_made_5_title', descKey: 'ms_made_5_desc', category: 'made'),
    Milestone(id: 'made_10', titleKey: 'ms_made_10_title', descKey: 'ms_made_10_desc', category: 'made'),
    Milestone(id: 'made_25', titleKey: 'ms_made_25_title', descKey: 'ms_made_25_desc', category: 'made'),
    Milestone(id: 'made_50', titleKey: 'ms_made_50_title', descKey: 'ms_made_50_desc', category: 'made'),
    Milestone(id: 'made_100', titleKey: 'ms_made_100_title', descKey: 'ms_made_100_desc', category: 'made'),
    Milestone(id: 'made_150', titleKey: 'ms_made_150_title', descKey: 'ms_made_150_desc', category: 'made'),
    Milestone(id: 'made_200', titleKey: 'ms_made_200_title', descKey: 'ms_made_200_desc', category: 'made'),
    Milestone(id: 'made_300', titleKey: 'ms_made_300_title', descKey: 'ms_made_300_desc', category: 'made'),
    Milestone(id: 'made_500', titleKey: 'ms_made_500_title', descKey: 'ms_made_500_desc', category: 'made'),

    // ── Reflections Logged Milestones (10) ──
    Milestone(id: 'ref_1', titleKey: 'ms_ref_1_title', descKey: 'ms_ref_1_desc', category: 'reflection'),
    Milestone(id: 'ref_3', titleKey: 'ms_ref_3_title', descKey: 'ms_ref_3_desc', category: 'reflection'),
    Milestone(id: 'ref_7', titleKey: 'ms_ref_7_title', descKey: 'ms_ref_7_desc', category: 'reflection'),
    Milestone(id: 'ref_14', titleKey: 'ms_ref_14_title', descKey: 'ms_ref_14_desc', category: 'reflection'),
    Milestone(id: 'ref_30', titleKey: 'ms_ref_30_title', descKey: 'ms_ref_30_desc', category: 'reflection'),
    Milestone(id: 'ref_50', titleKey: 'ms_ref_50_title', descKey: 'ms_ref_50_desc', category: 'reflection'),
    Milestone(id: 'ref_100', titleKey: 'ms_ref_100_title', descKey: 'ms_ref_100_desc', category: 'reflection'),
    Milestone(id: 'ref_150', titleKey: 'ms_ref_150_title', descKey: 'ms_ref_150_desc', category: 'reflection'),
    Milestone(id: 'ref_200', titleKey: 'ms_ref_200_title', descKey: 'ms_ref_200_desc', category: 'reflection'),
    Milestone(id: 'ref_365', titleKey: 'ms_ref_365_title', descKey: 'ms_ref_365_desc', category: 'reflection'),

    // ── Streak Milestones (10) ──
    Milestone(id: 'streak_3', titleKey: 'ms_streak_3_title', descKey: 'ms_streak_3_desc', category: 'streak'),
    Milestone(id: 'streak_5', titleKey: 'ms_streak_5_title', descKey: 'ms_streak_5_desc', category: 'streak'),
    Milestone(id: 'streak_7', titleKey: 'ms_streak_7_title', descKey: 'ms_streak_7_desc', category: 'streak'),
    Milestone(id: 'streak_10', titleKey: 'ms_streak_10_title', descKey: 'ms_streak_10_desc', category: 'streak'),
    Milestone(id: 'streak_14', titleKey: 'ms_streak_14_title', descKey: 'ms_streak_14_desc', category: 'streak'),
    Milestone(id: 'streak_21', titleKey: 'ms_streak_21_title', descKey: 'ms_streak_21_desc', category: 'streak'),
    Milestone(id: 'streak_30', titleKey: 'ms_streak_30_title', descKey: 'ms_streak_30_desc', category: 'streak'),
    Milestone(id: 'streak_60', titleKey: 'ms_streak_60_title', descKey: 'ms_streak_60_desc', category: 'streak'),
    Milestone(id: 'streak_90', titleKey: 'ms_streak_90_title', descKey: 'ms_streak_90_desc', category: 'streak'),
    Milestone(id: 'streak_120', titleKey: 'ms_streak_120_title', descKey: 'ms_streak_120_desc', category: 'streak'),

    // ── Discipline Score Milestones (10) ──
    Milestone(id: 'score_40', titleKey: 'ms_score_40_title', descKey: 'ms_score_40_desc', category: 'score'),
    Milestone(id: 'score_45', titleKey: 'ms_score_45_title', descKey: 'ms_score_45_desc', category: 'score'),
    Milestone(id: 'score_50', titleKey: 'ms_score_50_title', descKey: 'ms_score_50_desc', category: 'score'),
    Milestone(id: 'score_55', titleKey: 'ms_score_55_title', descKey: 'ms_score_55_desc', category: 'score'),
    Milestone(id: 'score_60', titleKey: 'ms_score_60_title', descKey: 'ms_score_60_desc', category: 'score'),
    Milestone(id: 'score_65', titleKey: 'ms_score_65_title', descKey: 'ms_score_65_desc', category: 'score'),
    Milestone(id: 'score_70', titleKey: 'ms_score_70_title', descKey: 'ms_score_70_desc', category: 'score'),
    Milestone(id: 'score_75', titleKey: 'ms_score_75_title', descKey: 'ms_score_75_desc', category: 'score'),
    Milestone(id: 'score_80', titleKey: 'ms_score_80_title', descKey: 'ms_score_80_desc', category: 'score'),
    Milestone(id: 'score_90', titleKey: 'ms_score_90_title', descKey: 'ms_score_90_desc', category: 'score'),

    // ── Reliability Score Milestones (10) ──
    Milestone(id: 'rel_40', titleKey: 'ms_rel_40_title', descKey: 'ms_rel_40_desc', category: 'reliability'),
    Milestone(id: 'rel_45', titleKey: 'ms_rel_45_title', descKey: 'ms_rel_45_desc', category: 'reliability'),
    Milestone(id: 'rel_50', titleKey: 'ms_rel_50_title', descKey: 'ms_rel_50_desc', category: 'reliability'),
    Milestone(id: 'rel_55', titleKey: 'ms_rel_55_title', descKey: 'ms_rel_55_desc', category: 'reliability'),
    Milestone(id: 'rel_60', titleKey: 'ms_rel_60_title', descKey: 'ms_rel_60_desc', category: 'reliability'),
    Milestone(id: 'rel_65', titleKey: 'ms_rel_65_title', descKey: 'ms_rel_65_desc', category: 'reliability'),
    Milestone(id: 'rel_70', titleKey: 'ms_rel_70_title', descKey: 'ms_rel_70_desc', category: 'reliability'),
    Milestone(id: 'rel_75', titleKey: 'ms_rel_75_title', descKey: 'ms_rel_75_desc', category: 'reliability'),
    Milestone(id: 'rel_80', titleKey: 'ms_rel_80_title', descKey: 'ms_rel_80_desc', category: 'reliability'),
    Milestone(id: 'rel_90', titleKey: 'ms_rel_90_title', descKey: 'ms_rel_90_desc', category: 'reliability'),

    // ── Planning Accuracy Milestones (10) ──
    Milestone(id: 'plan_40', titleKey: 'ms_plan_40_title', descKey: 'ms_plan_40_desc', category: 'planning'),
    Milestone(id: 'plan_45', titleKey: 'ms_plan_45_title', descKey: 'ms_plan_45_desc', category: 'planning'),
    Milestone(id: 'plan_50', titleKey: 'ms_plan_50_title', descKey: 'ms_plan_50_desc', category: 'planning'),
    Milestone(id: 'plan_55', titleKey: 'ms_plan_55_title', descKey: 'ms_plan_55_desc', category: 'planning'),
    Milestone(id: 'plan_60', titleKey: 'ms_plan_60_title', descKey: 'ms_plan_60_desc', category: 'planning'),
    Milestone(id: 'plan_65', titleKey: 'ms_plan_65_title', descKey: 'ms_plan_65_desc', category: 'planning'),
    Milestone(id: 'plan_70', titleKey: 'ms_plan_70_title', descKey: 'ms_plan_70_desc', category: 'planning'),
    Milestone(id: 'plan_75', titleKey: 'ms_plan_75_title', descKey: 'ms_plan_75_desc', category: 'planning'),
    Milestone(id: 'plan_80', titleKey: 'ms_plan_80_title', descKey: 'ms_plan_80_desc', category: 'planning'),
    Milestone(id: 'plan_90', titleKey: 'ms_plan_90_title', descKey: 'ms_plan_90_desc', category: 'planning'),

    // ── Life Area Milestones (10) ──
    Milestone(id: 'area_health_10', titleKey: 'ms_area_health_title', descKey: 'ms_area_health_desc', category: 'area'),
    Milestone(id: 'area_business_10', titleKey: 'ms_area_business_title', descKey: 'ms_area_business_desc', category: 'area'),
    Milestone(id: 'area_career_10', titleKey: 'ms_area_career_title', descKey: 'ms_area_career_desc', category: 'area'),
    Milestone(id: 'area_learning_10', titleKey: 'ms_area_learning_title', descKey: 'ms_area_learning_desc', category: 'area'),
    Milestone(id: 'area_finance_10', titleKey: 'ms_area_finance_title', descKey: 'ms_area_finance_desc', category: 'area'),
    Milestone(id: 'area_relationships_10', titleKey: 'ms_area_rel_title', descKey: 'ms_area_rel_desc', category: 'area'),
    Milestone(id: 'area_general_10', titleKey: 'ms_area_gen_title', descKey: 'ms_area_gen_desc', category: 'area'),
    Milestone(id: 'area_balance_3', titleKey: 'ms_balance_3_title', descKey: 'ms_balance_3_desc', category: 'area'),
    Milestone(id: 'area_balance_5', titleKey: 'ms_balance_5_title', descKey: 'ms_balance_5_desc', category: 'area'),
    Milestone(id: 'area_balance_all', titleKey: 'ms_balance_all_title', descKey: 'ms_balance_all_desc', category: 'area'),

    // ── Time of Day Milestones (8) ──
    Milestone(id: 'time_morn_1', titleKey: 'ms_time_morn_1_title', descKey: 'ms_time_morn_1_desc', category: 'time'),
    Milestone(id: 'time_morn_5', titleKey: 'ms_time_morn_5_title', descKey: 'ms_time_morn_5_desc', category: 'time'),
    Milestone(id: 'time_aft_1', titleKey: 'ms_time_aft_1_title', descKey: 'ms_time_aft_1_desc', category: 'time'),
    Milestone(id: 'time_aft_5', titleKey: 'ms_time_aft_5_title', descKey: 'ms_time_aft_5_desc', category: 'time'),
    Milestone(id: 'time_eve_1', titleKey: 'ms_time_eve_1_title', descKey: 'ms_time_eve_1_desc', category: 'time'),
    Milestone(id: 'time_eve_5', titleKey: 'ms_time_eve_5_title', descKey: 'ms_time_eve_5_desc', category: 'time'),
    Milestone(id: 'time_night_1', titleKey: 'ms_time_night_1_title', descKey: 'ms_time_night_1_desc', category: 'time'),
    Milestone(id: 'time_night_5', titleKey: 'ms_time_night_5_title', descKey: 'ms_time_night_5_desc', category: 'time'),

    // ── Weekly Report Milestones (4) ──
    Milestone(id: 'week_rep_1', titleKey: 'ms_week_rep_1_title', descKey: 'ms_week_rep_1_desc', category: 'week'),
    Milestone(id: 'week_rep_5', titleKey: 'ms_week_rep_5_title', descKey: 'ms_week_rep_5_desc', category: 'week'),
    Milestone(id: 'week_rep_10', titleKey: 'ms_week_rep_10_title', descKey: 'ms_week_rep_10_desc', category: 'week'),
    Milestone(id: 'week_rep_26', titleKey: 'ms_week_rep_26_title', descKey: 'ms_week_rep_26_desc', category: 'week'),

    // ── Future Self Letters (4) ──
    Milestone(id: 'let_write_1', titleKey: 'ms_let_write_1_title', descKey: 'ms_let_write_1_desc', category: 'letter'),
    Milestone(id: 'let_write_3', titleKey: 'ms_let_write_3_title', descKey: 'ms_let_write_3_desc', category: 'letter'),
    Milestone(id: 'let_unlock_1', titleKey: 'ms_let_unlock_1_title', descKey: 'ms_let_unlock_1_desc', category: 'letter'),
    Milestone(id: 'let_unlock_3', titleKey: 'ms_let_unlock_3_title', descKey: 'ms_let_unlock_3_desc', category: 'letter'),

    // ── Special / Failure Decoding Milestones (4) ──
    Milestone(id: 'fail_dec_1', titleKey: 'ms_fail_dec_1_title', descKey: 'ms_fail_dec_1_desc', category: 'fail'),
    Milestone(id: 'fail_dec_3', titleKey: 'ms_fail_dec_3_title', descKey: 'ms_fail_dec_3_desc', category: 'fail'),
    Milestone(id: 'fail_dec_5', titleKey: 'ms_fail_dec_5_title', descKey: 'ms_fail_dec_5_desc', category: 'fail'),
    Milestone(id: 'fail_dec_10', titleKey: 'ms_fail_dec_10_title', descKey: 'ms_fail_dec_10_desc', category: 'fail'),
  ];

  static Milestone? getMilestone(String id) {
    for (final ms in milestones) {
      if (ms.id == id) return ms;
    }
    return null;
  }
}
