import '../l10n/app_strings.dart';

class MotivationMessages {
  // ── 100 Beginner Messages (Focus: Self-observation, non-judgmental reflection) ──
  static final List<Map<AppLanguage, String>> beginner = [
    {
      AppLanguage.english: "Failure is not a personal flaw. It's just a pattern waiting to be understood.",
      AppLanguage.hinglish: "Asafalta koi kami nahi hai. Ye sirf ek pattern hai jise samajhna baaki hai."
    },
    {
      AppLanguage.english: "Be honest with yourself today. What did you learn from the plans you missed?",
      AppLanguage.hinglish: "Aaj apne sath honest raho. Jo plans chhut gaye, unse kya seekha?"
    },
    {
      AppLanguage.english: "Don't force consistency yet. First, study the friction that stops it.",
      AppLanguage.hinglish: "Consistency ke liye zabardasti mat karo. Pehle us friction ko samjho jo ise rokta hai."
    },
    {
      AppLanguage.english: "A broken plan is not a defeat. It is a data point.",
      AppLanguage.hinglish: "Ek toota hua plan haar nahi hai. Ye seekhne ke liye ek data point hai."
    },
    {
      AppLanguage.english: "You are not lazy. You are just repeating patterns you haven't decoded yet.",
      AppLanguage.hinglish: "Aap aalsi nahi hain. Aap sirf un patterns ko dohra rahe hain jo abhi decode nahi hue."
    },
    {
      AppLanguage.english: "Observe your energy today. When did you feel the strongest urge to drift?",
      AppLanguage.hinglish: "Aaj apni energy ko observe karo. Sabse zyada dhyan bhatakne ka mann kab kiya?"
    },
    {
      AppLanguage.english: "Every honest reflection builds the foundation of self-awareness.",
      AppLanguage.hinglish: "Har ek sachhi reflection self-awareness ki buniyaad banti hai."
    },
    {
      AppLanguage.english: "Stop looking at the checklist. Start looking at your environment.",
      AppLanguage.hinglish: "Checklist ko chhodkar, apne aaspass ke environment ko dekho."
    },
    {
      AppLanguage.english: "Why did you skip today's task? Write down the raw, unfiltered reason.",
      AppLanguage.hinglish: "Aaj ka task kyun chhuta? Uska bilkul sachha aur bina filter ka reason likho."
    },
    {
      AppLanguage.english: "Self-improvement begins with self-compassion. Forgive today's slip.",
      AppLanguage.hinglish: "Self-improvement ki shuruat khud pe reham karne se hoti hai. Aaj ki galti ko maaf karo."
    },
    // Adding templates to generate 100 high-quality variations dynamically
    ...List.generate(90, (i) {
      final templates = [
        (
          "Notice how [trigger] affects your [area] plans. Awareness is the first step.",
          "Observe karo ki [trigger] tumhare [area] plans ko kaise rokti hai. Samjhna hi pehla step hai."
        ),
        (
          "When you fail at [area] plans, is it due to [reason], or are you over-committing?",
          "Jab tum [area] plans me fail hote ho, toh kya wajah [reason] hai, ya tum over-commit kar rahe ho?"
        ),
        (
          "A simple reflection on [area] today will help you adjust your environment tomorrow.",
          "[area] par aaj ki ek chhoti si reflection, kal tumhare environment ko adjust karne me help karegi."
        ),
        (
          "You made a promise to improve [area]. If it broke, ask yourself: what was the silent blocker?",
          "Tumne [area] ko improve karne ka waada kiya tha. Agar wo toota, toh khud se pucho: silent blocker kya tha?"
        ),
        (
          "Do not shame yourself for procrastination in [area]. Just note down the distraction trigger.",
          "[area] me procrastination ke liye khud ko dosh mat do. Bas distraction ke trigger ko note kar lo."
        ),
      ];

      final triggers = ["phone notifications", "low morning energy", "late-night fatigue", "social scrolling", "unclear goals"];
      final areas = ["Health", "Business", "Career", "Learning", "Finance", "Relationships"];
      final reasons = ["procrastination", "unexpected distractions", "sudden drop in energy", "poor time planning"];

      final t = templates[i % templates.length];
      final trigger = triggers[i % triggers.length];
      final area = areas[(i + 1) % areas.length];
      final reason = reasons[(i + 2) % reasons.length];

      final en = t.$1.replaceAll("[trigger]", trigger).replaceAll("[area]", area).replaceAll("[reason]", reason);
      final hi = t.$2.replaceAll("[trigger]", trigger).replaceAll("[area]", area).replaceAll("[reason]", reason);

      return {AppLanguage.english: en, AppLanguage.hinglish: hi};
    })
  ];

  // ── 100 Intermediate Messages (Focus: Rebuilding self-trust, reducing over-commitment) ──
  static final List<Map<AppLanguage, String>> intermediate = [
    {
      AppLanguage.english: "Every promise kept is a stone laid in the foundation of your self-trust.",
      AppLanguage.hinglish: "Har ek poora kiya hua waada, self-trust ki buniyaad me ek pathar jaisa hai."
    },
    {
      AppLanguage.english: "Reduce your commitments today. It is better to do one thing perfectly than to fail at five.",
      AppLanguage.hinglish: "Aaj apne commitments ko kam karo. Paanch me fail hone se achha hai ek kaam perfect karna."
    },
    {
      AppLanguage.english: "Adjust your environment, not your willpower. Willpower is a failing system.",
      AppLanguage.hinglish: "Apne environment ko adjust karo, willpower ko nahi. Willpower humesha sath nahi deti."
    },
    {
      AppLanguage.english: "Consistency isn't about doing everything. It's about not breaking the promises that matter.",
      AppLanguage.hinglish: "Consistency har kaam karne me nahi hai. Ye un waadon ko na todne me hai jo sach me zaroori hain."
    },
    {
      AppLanguage.english: "When you feel the urge to quit, check if your planning was too optimistic.",
      AppLanguage.hinglish: "Jab chhodne ka mann kare, toh check karo ki kya tumne planning bohot unrealistic ki thi."
    },
    {
      AppLanguage.english: "You are building a reputation with yourself. Keep the promise you made this morning.",
      AppLanguage.hinglish: "Aap khud ki nazron me apni reputation bana rahe hain. Jo waada subah kiya tha, use poora karo."
    },
    {
      AppLanguage.english: "Are you planning for a robot or a human? Plan for your tired self, not your ideal self.",
      AppLanguage.hinglish: "Kya aap kisi robot ke liye plan kar rahe hain? Apni thaki hui state ko dhyan me rakh ke plan banao."
    },
    {
      AppLanguage.english: "Real discipline is built by saying 'no' to over-planning.",
      AppLanguage.hinglish: "Asli discipline over-planning ko 'no' kehne se aata hai."
    },
    {
      AppLanguage.english: "Look at your reliability score. It is a direct reflection of your consistency.",
      AppLanguage.hinglish: "Apne reliability score ko dekho. Ye aapki consistency ka direct mirror hai."
    },
    {
      AppLanguage.english: "Procrastination is just fear in disguise. Break the task down into a smaller move.",
      AppLanguage.hinglish: "Procrastination sirf ek darr hai. Apne task ko ek chhote move me divide kar do."
    },
    ...List.generate(90, (i) {
      final templates = [
        (
          "Your reliability score in [area] is growing. Keep designing your environment around [adjustment].",
          "[area] me aapka reliability score badh raha hai. Apne environment ko [adjustment] ke according adjust karte raho."
        ),
        (
          "To keep your [area] promises, you must drop [distraction] before you begin.",
          "[area] ke waadon ko poora karne ke liye, kaam shuru karne se pehle [distraction] ko chhodna hoga."
        ),
        (
          "Planning realism check: Can you complete your [area] move in less time, or do you need to reschedule?",
          "Planning check: Kya aap apna [area] move kam time me kar sakte hain, ya schedule change karna hoga?"
        ),
        (
          "You avoided failure by adjusting your [area] plans yesterday. This is behavioral intelligence.",
          "Tumne kal [area] plans ko adjust karke failure ko taala. Ise hi behavioral intelligence kehte hain."
        ),
        (
          "Every time you log a failure in [area], you reveal a pattern. Study it and conquer it.",
          "Jab bhi aap [area] me failure log karte hain, ek pattern bahar aata hai. Ise samjho aur jeeto."
        ),
      ];

      final adjustments = ["putting phone away", "starting 30 mins earlier", "planning only 1 major move", "breaking tasks into parts"];
      final areas = ["Health", "Business", "Career", "Learning", "Finance", "Relationships"];
      final distractions = ["phone notifications", "social media scrolling", "multitasking", "unnecessary breaks"];

      final t = templates[i % templates.length];
      final adj = adjustments[i % adjustments.length];
      final area = areas[(i + 1) % areas.length];
      final dist = distractions[(i + 2) % distractions.length];

      final en = t.$1.replaceAll("[adjustment]", adj).replaceAll("[area]", area).replaceAll("[distraction]", dist);
      final hi = t.$2.replaceAll("[adjustment]", adj).replaceAll("[area]", area).replaceAll("[distraction]", dist);

      return {AppLanguage.english: en, AppLanguage.hinglish: hi};
    })
  ];

  // ── 100 Advanced Messages (Focus: Elite execution, resilience, self-mastery) ──
  static final List<Map<AppLanguage, String>> advanced = [
    {
      AppLanguage.english: "You are aligning who you are with what you do. Keep this quiet discipline.",
      AppLanguage.hinglish: "Aap jo hain aur jo aap karte hain, unhe ek line me la rahe hain. Is shanti se discipline ko banaye rakho."
    },
    {
      AppLanguage.english: "Consistency is not about perfection. It is about how quickly you return after a break.",
      AppLanguage.hinglish: "Consistency perfection nahi hai. Ye isme hai ki aap break ke baad kitni jaldi wapas aate hain."
    },
    {
      AppLanguage.english: "Execution is the highest form of self-respect.",
      AppLanguage.hinglish: "Plans ko execute karna hi khud ke liye sabse bada self-respect hai."
    },
    {
      AppLanguage.english: "You have decoded your patterns. Now, design your environment to make failure impossible.",
      AppLanguage.hinglish: "Aapne apne patterns decode kar liye hain. Ab apne environment ko aisa banao ki fail hona impossible ho."
    },
    {
      AppLanguage.english: "Elite discipline is silent. It doesn't need external rewards or cheers.",
      AppLanguage.hinglish: "Elite discipline bilkul shant hota hai. Ise kisi bahari praise ya reward ki zaroorat nahi hoti."
    },
    {
      AppLanguage.english: "A high reliability score is not a game score; it is the metric of your self-trust.",
      AppLanguage.hinglish: "Ek high reliability score koi game ke points nahi hain; ye aapke self-trust ka sabboot hai."
    },
    {
      AppLanguage.english: "You plan realistically because you know your limits. This is true strength.",
      AppLanguage.hinglish: "Aap realistic planning karte hain kyunki aapko apni limits pata hain. Yahi asli taqat hai."
    },
    {
      AppLanguage.english: "Resilience is keeping your promises when your motivation is at absolute zero.",
      AppLanguage.hinglish: "Resilience tab waada poora karne me hai jab motivation bilkul zero ho."
    },
    {
      AppLanguage.english: "You don't need motivation anymore. Your systems protect your execution.",
      AppLanguage.hinglish: "Ab aapko motivation ki zaroorat nahi hai. Aapke systems hi aapki execution ko protect karte hain."
    },
    {
      AppLanguage.english: "Every failure decoded makes you more bulletproof. You are mastering your behavior.",
      AppLanguage.hinglish: "Har ek failure ko decode karna aapko aur mazboot banata hai. Aap apne behavior ke master ban rahe hain."
    },
    ...List.generate(90, (i) {
      final templates = [
        (
          "Your planning accuracy is [stat]% in [area]. You have aligned execution with reality.",
          "[area] me aapki planning accuracy [stat]% hai. Aapne execution ko reality ke sath jod diya hai."
        ),
        (
          "Maintain your elite momentum in [area]. Protect your discipline score of [score].",
          "[area] me apna elite momentum banaye rakho. Apne [score] ke discipline score ko protect karo."
        ),
        (
          "You are executing [area] promises with absolute clarity. The noise has faded.",
          "Aap pure focus ke sath [area] ke waadon ko execute kar rahe hain. Baaki sab noise gayab ho chuki hai."
        ),
        (
          "When executing [area], you notice resistance immediately and adjust. This is mastery.",
          "[area] ko execute karte waqt, aap resistance ko turant samajh kar adjust kar lete hain. Yahi mastery hai."
        ),
        (
          "Elite self-trust: You said you would improve [area], and your reliability score proves it.",
          "Elite self-trust: Tumne [area] ko behtar banane ke liye kaha tha, aur aapka reliability score iska sabboot hai."
        ),
      ];

      final stats = ["82", "85", "88", "90", "94"];
      final areas = ["Health", "Business", "Career", "Learning", "Finance", "Relationships"];
      final scores = ["78", "82", "85", "88", "92"];

      final t = templates[i % templates.length];
      final stat = stats[i % stats.length];
      final area = areas[(i + 1) % areas.length];
      final score = scores[(i + 2) % scores.length];

      final en = t.$1.replaceAll("[stat]", stat).replaceAll("[area]", area).replaceAll("[score]", score);
      final hi = t.$2.replaceAll("[stat]", stat).replaceAll("[area]", area).replaceAll("[score]", score);

      return {AppLanguage.english: en, AppLanguage.hinglish: hi};
    })
  ];

  // ── Lookup function for VM ──
  static String getMessage(AppLanguage lang, int levelNum, int index) {
    if (levelNum <= 5) {
      final list = beginner;
      return list[index % list.length][lang] ?? "";
    } else if (levelNum <= 13) {
      final list = intermediate;
      return list[index % list.length][lang] ?? "";
    } else {
      final list = advanced;
      return list[index % list.length][lang] ?? "";
    }
  }
}
