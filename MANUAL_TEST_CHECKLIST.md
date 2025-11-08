# 🎮 MOVEMENT SYSTEM MANUAL TEST CHECKLIST
## Print this and check off as you test!

**Tester Name:** ________________  
**Date:** ________________  
**Unity Version:** ________________  
**Build Target:** ________________

---

## ⚡ QUICK VERIFICATION (5 minutes - Do this first!)

| Test | Expected Result | ✓ | Notes |
|------|----------------|---|-------|
| Walk forward | Smooth 1300 u/s movement | ☐ | Speed: ____ |
| Sprint forward | Smooth 2015 u/s (1.55× walk) | ☐ | Speed: ____ |
| Jump (grounded) | ~206 unit height, 0.49s air | ☐ | Height: ____ |
| Jump (sprinting) | Longer horizontal distance | ☐ | Distance: ____ |
| Double jump | 2nd jump ~135 units up | ☐ | Height: ____ |
| Crouch toggle | Height shrinks to 140 units | ☐ | Works: ____ |
| Stand (no obstacle) | Height returns to 320 units | ☐ | Works: ____ |
| Slide activation | Press C while sprinting → slide | ☐ | Works: ____ |

**Pass Criteria:** 7/8 tests must pass  
**Your Score:** ___/8  
**Status:** [ ] PASS [ ] FAIL

---

## 🏔️ SLOPE PHYSICS (15 minutes)

### Flat → Gentle Slopes
| Test | Expected | ✓ | Speed |
|------|----------|---|-------|
| Walk on 0° flat | No slide, stable | ☐ | _____ |
| Walk on 5° slope | Smooth, no stutter | ☐ | _____ |
| Walk on 10° slope | Slight acceleration down | ☐ | _____ |
| Walk on 20° slope | Noticeable speed change | ☐ | _____ |

### Medium Slopes
| Test | Expected | ✓ | Speed |
|------|----------|---|-------|
| Walk up 30° | Slower, but steady climb | ☐ | _____ |
| Sprint down 30° | Accelerates naturally | ☐ | _____ |
| Jump on 30° slope | Gains horizontal speed | ☐ | _____ |
| Crouch on 35° slope | Optional slide (if enabled) | ☐ | _____ |

### Steep Slopes
| Test | Expected | ✓ | Speed |
|------|----------|---|-------|
| Walk on 50° slope | Auto-slide if enabled | ☐ | _____ |
| Sprint on 50° slope | Fast acceleration | ☐ | _____ |
| Crouch on 50° slope | Force-slide (if enabled) | ☐ | _____ |
| Walk on 70° slope | Slide regardless | ☐ | _____ |

### Slope Transitions
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Flat → 30° upslope | Smooth slowdown | ☐ | _____ |
| 30° → flat | Smooth speedup | ☐ | _____ |
| 30° down → 30° up (valley) | No float, smooth | ☐ | _____ |
| 50° slope → flat | Slide continues briefly | ☐ | _____ |

**Pass Criteria:** 14/16 tests pass  
**Your Score:** ___/16  
**Status:** [ ] PASS [ ] FAIL

---

## 🎯 SLIDE MECHANICS (20 minutes)

### Basic Sliding
| Test | Expected | ✓ | Speed Range |
|------|----------|---|-------------|
| Manual slide (flat) | Sprint + C → slide | ☐ | _____ → _____ |
| Slide duration | ~1-3 seconds | ☐ | Duration: ____ s |
| Slide max speed | Caps at 3000 u/s | ☐ | Max: _____ |
| Release crouch → stop | Momentum transferred | ☐ | Final: _____ |

### Slope Sliding
| Test | Expected | ✓ | Speed Range |
|------|----------|---|-------------|
| Slide down 30° | Smooth acceleration | ☐ | _____ → _____ |
| Slide down 50° | Faster acceleration | ☐ | _____ → _____ |
| Slide down 70° | Near-vertical slide | ☐ | _____ → _____ |
| Slide up 30° | Decelerate → reverse | ☐ | Apex: _____ |

### Advanced Sliding
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Slide → jump | Momentum preserved in air | ☐ | Carried: ____ u/s |
| Jump → slide land | Buffered slide works | ☐ | Landed at: ____ |
| Slide → wall | Deflects smoothly | ☐ | Lost speed: ____ |
| Slide → stand | 85% momentum transfer | ☐ | Transfer: ____ |

### Uphill Physics
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Slide up 30° slow | Reversal at apex | ☐ | Reversed: ____ |
| Slide up 40° fast | Climbs, then reverses | ☐ | Peak: ____ u/s |
| Uphill jump timing | Jump cancels reversal | ☐ | Worked: ____ |

**Pass Criteria:** 14/16 tests pass  
**Your Score:** ___/16  
**Status:** [ ] PASS [ ] FAIL

---

## 🧗 WALL JUMP SYSTEM (15 minutes)

### Basic Wall Jumps
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Single wall jump | Launches away from wall | ☐ | Height: ____ |
| Wall jump while falling | Works at any fall speed | ☐ | Speed: ____ |
| Wall jump cooldown | 0.12s between jumps | ☐ | Timing: ____ |
| Same wall spam | Blocked (anti-exploit) | ☐ | Worked: ____ |

### Wall Jump Chains
| Test | Expected | ✓ | Speed Build |
|------|----------|---|-------------|
| 2-wall chain | Speed builds slightly | ☐ | _____ → _____ |
| 3-wall chain | Speed builds more | ☐ | _____ → _____ |
| 5-wall chain | Significant speed | ☐ | _____ → _____ |
| Wall → slide land | Momentum → slide | ☐ | Final: _____ |

### Momentum Scaling
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Slow fall → wall jump | Normal height | ☐ | Height: ____ |
| Fast fall → wall jump | Extra horizontal | ☐ | Speed: ____ |
| Camera direction | Jump where looking | ☐ | Worked: ____ |
| Input direction | WASD influences | ☐ | Responsive: ____ |

**Pass Criteria:** 11/13 tests pass  
**Your Score:** ___/13  
**Status:** [ ] PASS [ ] FAIL

---

## 🤸 TACTICAL DIVE (10 minutes)

### Basic Dive
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Dive on flat | Forward arc dive | ☐ | Distance: ____ |
| Dive forward (W) | Dives in camera direction | ☐ | Correct: ____ |
| Dive left (A) | Dives 90° left | ☐ | Correct: ____ |
| Dive back (S) | Dives backward | ☐ | Correct: ____ |

### Dive Landing
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Dive → land prone | Slides on belly | ☐ | Distance: ____ |
| Prone duration | ~0.8s or press input | ☐ | Duration: ____ s |
| Prone → stand | Quick recovery | ☐ | Responsive: ____ |
| Dive → slide | Transitions smoothly | ☐ | Worked: ____ |

### Dive Integration
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Dive cancels slide | Slide stops, dive starts | ☐ | Clean: ____ |
| Jump during dive | Jump takes priority | ☐ | Worked: ____ |
| Dive under obstacle | Ducks smoothly | ☐ | Clearance: ____ |

**Pass Criteria:** 10/11 tests pass  
**Your Score:** ___/11  
**Status:** [ ] PASS [ ] FAIL

---

## ⚡ INPUT CONFLICTS (10 minutes)

### Simultaneous Inputs
| Test | Expected | ✓ | Winner |
|------|----------|---|--------|
| C + X (same frame) | Dive wins | ☐ | ______ |
| C + Space (crouch+jump) | Jump wins | ☐ | ______ |
| Shift + C (sprint+crouch) | Slide starts | ☐ | ______ |
| All 3 (Shift+C+X) | Dive wins | ☐ | ______ |

### Buffered Inputs
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Jump in air → land | Jump buffer works | ☐ | Latency: ____ |
| Crouch in air → land | Slide starts | ☐ | Worked: ____ |
| Jump during slam | Buffer cleared | ☐ | Blocked: ____ |
| Spam inputs | No state flicker | ☐ | Stable: ____ |

### State Conflicts
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Slide + jump held | Jump blocked | ☐ | Correct: ____ |
| Slide on stairs | No slide activation | ☐ | Blocked: ____ |
| Grapple during slide | Slide cancels | ☐ | Clean: ____ |
| Platform + slide | Velocities add | ☐ | Smooth: ____ |

**Pass Criteria:** 11/12 tests pass  
**Your Score:** ___/12  
**Status:** [ ] PASS [ ] FAIL

---

## 🎪 CROUCH SLAM CHAINS (15 minutes)

### Basic Slam
| Test | Expected | ✓ | Speed |
|------|----------|---|-------|
| Crouch → fall 5m → land | Slam triggered | ☐ | _____ u/s |
| Slam on flat ground | Slide continues | ☐ | _____ u/s |
| Slam on 30° slope | Downhill boost | ☐ | _____ u/s |
| Slam on 50° slope | Major speed | ☐ | _____ u/s |

### Slam Chains
| Test | Expected | ✓ | Speed Build |
|------|----------|---|-------------|
| Slam → slide → ramp | Speed preserved | ☐ | _____ → _____ |
| Slam → jump → slam | Momentum stacks | ☐ | _____ → _____ |
| Slam → wall jump → slam | Speed chains | ☐ | _____ → _____ |
| 3-slam chain | High speed (>4000) | ☐ | Final: _____ |

### Slam Edge Cases
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Slam + jump held | Jump blocked | ☐ | Slide: ____ |
| Slam on moving platform | Platform + slam vel | ☐ | Combined: ____ |
| Slam into wall | Deflects smoothly | ☐ | Worked: ____ |

**Pass Criteria:** 10/11 tests pass  
**Your Score:** ___/11  
**Status:** [ ] PASS [ ] FAIL

---

## 🏃 MOVEMENT QUALITY (10 minutes)

### Responsiveness
| Test | Expected | ✓ | Latency |
|------|----------|---|---------|
| Input → movement | <2 frames (33ms) | ☐ | ____ ms |
| Jump → airborne | <1 frame (16ms) | ☐ | ____ ms |
| Crouch → slide | <2 frames (33ms) | ☐ | ____ ms |
| Stand → walk | Instant | ☐ | ____ ms |

### Animation Sync
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Slide anim timing | Plays immediately | ☐ | Delay: ____ |
| Dive anim timing | Plays immediately | ☐ | Delay: ____ |
| Land anim timing | Plays on impact | ☐ | Delay: ____ |
| State transitions | Smooth blending | ☐ | Glitches: ____ |

### Feel & Polish
| Test | Expected | ✓ | Rating |
|------|----------|---|--------|
| Momentum flow | Satisfying chains | ☐ | ___/10 |
| Control precision | Responsive input | ☐ | ___/10 |
| Physics weight | Grounded feel | ☐ | ___/10 |
| Overall fun factor | Enjoyable movement | ☐ | ___/10 |

**Pass Criteria:** 10/12 tests pass  
**Your Score:** ___/12  
**Status:** [ ] PASS [ ] FAIL

---

## ⚙️ PERFORMANCE (10 minutes)

### Frame Rate
| Test | Expected | ✓ | FPS |
|------|----------|---|-----|
| Idle (60 FPS target) | Stable 60+ fps | ☐ | ____ |
| Sliding (60 FPS) | Stable 60+ fps | ☐ | ____ |
| Wall jump chains | Stable 60+ fps | ☐ | ____ |
| Complex geometry | Stable 60+ fps | ☐ | ____ |

### Frame Rate Independence
| Test | Expected | ✓ | Feel |
|------|----------|---|------|
| Lock to 30 FPS | Feels consistent | ☐ | ___/10 |
| Lock to 60 FPS | Feels normal | ☐ | ___/10 |
| Lock to 144 FPS | Feels same as 60 | ☐ | ___/10 |
| Variable FPS (30-60) | No speed changes | ☐ | ___/10 |

### Memory & GC
| Test | Expected | ✓ | Result |
|------|----------|---|--------|
| Slide for 60s | 0 GC alloc | ☐ | ____ B/frame |
| Wall slide complex geo | <1% frame time | ☐ | ____ ms |
| State transitions | No GC spikes | ☐ | ____ B |
| Debug logs off | 0 string alloc | ☐ | ____ B |

**Pass Criteria:** 11/12 tests pass  
**Your Score:** ___/12  
**Status:** [ ] PASS [ ] FAIL

---

## 🔧 CONFIGURATION (5 minutes)

### Config Switching
| Test | Expected | ✓ | Notes |
|------|----------|---|-------|
| Switch mid-slide | Smooth transition | ☐ | Jitter: ____ |
| Switch mid-dive | Continues dive | ☐ | Worked: ____ |
| Null config | Falls back to inspector | ☐ | Worked: ____ |

### Extreme Values
| Test | Expected | ✓ | Result |
|------|----------|---|--------|
| Speed × 10 | Fast but stable | ☐ | Stable: ____ |
| Speed ÷ 10 | Slow but functional | ☐ | Worked: ____ |
| Gravity = 0 | Drift movement | ☐ | No fall: ____ |
| Negative values | Auto-corrects | ☐ | Fixed: ____ |

**Pass Criteria:** 6/7 tests pass  
**Your Score:** ___/7  
**Status:** [ ] PASS [ ] FAIL

---

## 📊 FINAL SCORE CALCULATION

| Category | Your Score | Possible | Pass? |
|----------|-----------|----------|-------|
| Quick Verification | ___/8 | 8 | ☐ |
| Slope Physics | ___/16 | 16 | ☐ |
| Slide Mechanics | ___/16 | 16 | ☐ |
| Wall Jump System | ___/13 | 13 | ☐ |
| Tactical Dive | ___/11 | 11 | ☐ |
| Input Conflicts | ___/12 | 12 | ☐ |
| Crouch Slam Chains | ___/11 | 11 | ☐ |
| Movement Quality | ___/12 | 12 | ☐ |
| Performance | ___/12 | 12 | ☐ |
| Configuration | ___/7 | 7 | ☐ |

**TOTAL SCORE:** ____/118  
**PASS RATE:** ____%

### Grading Scale:
- **100-118 (90%+):** ✅ EXCELLENT - Ready for release!
- **100-105 (85-89%):** ✅ GOOD - Minor polish needed
- **95-100 (80-84%):** ⚠️ ACCEPTABLE - Address failures
- **<95 (<80%):** ❌ NEEDS WORK - Major issues found

---

## 🐛 ISSUES FOUND

**Critical Issues (Must Fix Before Release):**
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

**Medium Issues (Should Fix):**
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

**Minor Issues (Nice to Fix):**
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

---

## 📝 TESTER NOTES

Additional observations, edge cases, or suggestions:

________________________________________________________________________
________________________________________________________________________
________________________________________________________________________
________________________________________________________________________
________________________________________________________________________
________________________________________________________________________

---

## ✅ SIGN-OFF

**Tester Signature:** ____________________  
**Date Completed:** ____________________  
**Recommendation:** [ ] Ship It [ ] Needs Work [ ] Major Issues  

**Final Verdict:**  
________________________________________________________________________
________________________________________________________________________
