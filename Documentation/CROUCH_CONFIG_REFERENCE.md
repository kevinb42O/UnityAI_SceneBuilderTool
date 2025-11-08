# Crouch Configuration Reference

## Overview

The `CrouchConfig` class is designed to manage the advanced crouch and slide mechanics of the movement controller. This document provides a comprehensive reference for each setting within the `CrouchConfig.cs` file, detailing their purpose, recommended values, and interactions with other settings.

## CrouchConfig Settings

| Setting Name                | Description                                                                 | Default Value | Recommended Range | Interaction Warnings                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|---------------|-------------------|--------------------------------------------------------------------------------------|
| `crouchHeight`              | The height of the character when crouching.                               | `0.5f`        | `0.3f` - `1.0f`   | ⚠️ Affects: `standHeight` <br> ⚠️ Don't change if `standHeight` is also modified.  |
| `standHeight`               | The height of the character when standing.                                 | `1.8f`        | `1.5f` - `2.0f`   | ⚠️ Affects: `crouchHeight` <br> ⚠️ Ensure this is greater than `crouchHeight`.    |
| `crouchSpeed`               | The speed at which the character moves while crouching.                   | `2.0f`        | `1.0f` - `4.0f`   | ⚠️ Affects: `slideSpeed` <br> ✅ Synergizes well with `slideDuration`.              |
| `slideSpeed`                | The speed of the character during a slide.                                 | `5.0f`        | `3.0f` - `8.0f`   | ⚠️ Affects: `slideDuration` <br> ⚠️ Don't change if `crouchSpeed` is modified.     |
| `slideDuration`             | The duration of the slide in seconds.                                      | `1.0f`        | `0.5f` - `2.0f`   | ⚠️ Affects: `slideSpeed` <br> ✅ Synergizes well with `crouchSpeed`.               |
| `crouchAnimationSpeed`      | The speed of the crouch animation transition.                               | `1.0f`        | `0.5f` - `2.0f`   | ⚠️ Affects: animation blending <br> ✅ Synergizes well with `crouchHeight`.        |

## Detailed Settings Explanation

### `crouchHeight`
- **What it does**: Defines how low the character crouches.
- **Why it exists**: To allow for varied gameplay experiences, accommodating different environments and gameplay styles.
- **When to change**: Adjust this value if you want your character to fit through tighter spaces or to create a more immersive experience.

### Value Guidance
- **Default value**: `0.5f` (standard crouch height)
- **Recommended range**: `0.3f` - `1.0f`
- **Examples**:
  - Low value (`0.3f`): "Ideal for stealth games where low profiles are crucial."
  - Default value (`0.5f`): "Balanced for most gameplay scenarios."
  - High value (`1.0f`): "Useful for games with larger character models."

### Interaction Warnings
- ⚠️ Affects: `standHeight`
- ⚠️ Don't change this if you also changed `standHeight`.

### Common Mistakes
- ❌ Setting this too high can cause clipping through the environment.
- ✅ Instead, try adjusting `standHeight` to maintain balance.

### Visual Examples
- Before: Character standing at `1.8f` height.
- After: Character crouching at `0.5f` height.

---

### `standHeight`
- **What it does**: Sets the height of the character when not crouching.
- **Why it exists**: To define the character's physical presence in the game world.
- **When to change**: Modify this if you want to create a character that is taller or shorter than the default.

### Value Guidance
- **Default value**: `1.8f`
- **Recommended range**: `1.5f` - `2.0f`
- **Examples**:
  - Low value (`1.5f`): "For shorter characters, like dwarves or children."
  - Default value (`1.8f`): "Standard human height."
  - High value (`2.0f`): "For tall characters, like giants."

### Interaction Warnings
- ⚠️ Affects: `crouchHeight`
- ⚠️ Ensure this is greater than `crouchHeight`.

### Common Mistakes
- ❌ Setting this too low can make the character feel unnatural.
- ✅ Instead, try adjusting `crouchHeight` to maintain realism.

### Visual Examples
- Before: Character standing at `1.5f`.
- After: Character standing at `1.8f`.

---

### `crouchSpeed`
- **What it does**: Controls how fast the character can move while crouching.
- **Why it exists**: To balance stealth and mobility during crouching.
- **When to change**: Adjust this if you want to create a faster or slower crouch movement.

### Value Guidance
- **Default value**: `2.0f`
- **Recommended range**: `1.0f` - `4.0f`
- **Examples**:
  - Low value (`1.0f`): "Ideal for stealth gameplay."
  - Default value (`2.0f`): "Balanced for most scenarios."
  - High value (`4.0f`): "For fast-paced action games."

### Interaction Warnings
- ⚠️ Affects: `slideSpeed`
- ✅ Synergizes well with `slideDuration`.

### Common Mistakes
- ❌ Setting this too high can reduce the stealth aspect.
- ✅ Instead, try lowering it for a more tactical approach.

### Visual Examples
- Before: Character moving at `1.0f` speed while crouching.
- After: Character moving at `2.0f` speed while crouching.

---

### `slideSpeed`
- **What it does**: Determines how fast the character slides.
- **Why it exists**: To provide a dynamic movement option during crouching.
- **When to change**: Modify this if you want to create a more aggressive or cautious sliding mechanic.

### Value Guidance
- **Default value**: `5.0f`
- **Recommended range**: `3.0f` - `8.0f`
- **Examples**:
  - Low value (`3.0f`): "For a more controlled slide."
  - Default value (`5.0f`): "Balanced for most gameplay."
  - High value (`8.0f`): "For fast-paced action sequences."

### Interaction Warnings
- ⚠️ Affects: `slideDuration`
- ⚠️ Don't change if `crouchSpeed` is modified.

### Common Mistakes
- ❌ Setting this too low can make sliding feel ineffective.
- ✅ Instead, try increasing it for more dynamic gameplay.

### Visual Examples
- Before: Character sliding at `3.0f`.
- After: Character sliding at `5.0f`.

---

### `slideDuration`
- **What it does**: Specifies how long the slide lasts.
- **Why it exists**: To control the pacing of movement during a slide.
- **When to change**: Adjust this if you want to create a longer or shorter sliding experience.

### Value Guidance
- **Default value**: `1.0f`
- **Recommended range**: `0.5f` - `2.0f`
- **Examples**:
  - Low value (`0.5f`): "Quick slides for fast-paced gameplay."
  - Default value (`1.0f`): "Standard duration for most scenarios."
  - High value (`2.0f`): "Longer slides for dramatic effects."

### Interaction Warnings
- ⚠️ Affects: `slideSpeed`
- ✅ Synergizes well with `crouchSpeed`.

### Common Mistakes
- ❌ Setting this too high can lead to unrealistic movement.
- ✅ Instead, try balancing it with `slideSpeed`.

### Visual Examples
- Before: Character sliding for `0.5f` seconds.
- After: Character sliding for `1.0f` seconds.

---

### `crouchAnimationSpeed`
- **What it does**: Controls the speed of the crouch animation.
- **Why it exists**: To ensure smooth transitions between standing and crouching.
- **When to change**: Modify this if you want to adjust the feel of the crouch animation.

### Value Guidance
- **Default value**: `1.0f`
- **Recommended range**: `0.5f` - `2.0f`
- **Examples**:
  - Low value (`0.5f`): "Slower transitions for a more dramatic effect."
  - Default value (`1.0f`): "Balanced for most animations."
  - High value (`2.0f`): "Faster transitions for quick gameplay."

### Interaction Warnings
- ⚠️ Affects: animation blending.
- ✅ Synergizes well with `crouchHeight`.

### Common Mistakes
- ❌ Setting this too high can make animations feel rushed.
- ✅ Instead, try lowering it for smoother transitions.

### Visual Examples
- Before: Character transitioning at `0.5f` speed.
- After: Character transitioning at `1.0f` speed.

---

## Conclusion

This document serves as a comprehensive reference for the `CrouchConfig` settings. By understanding each parameter and its interactions, you can fine-tune the crouch and slide mechanics to fit your game's unique requirements. For further guidance, refer to the other documentation files or the integration guide.