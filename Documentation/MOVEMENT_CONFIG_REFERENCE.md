# MOVEMENT_CONFIG_REFERENCE.md

## MovementConfig Reference

This document provides a comprehensive reference for every setting in the `MovementConfig.cs` file. Each setting is explained in detail, including its purpose, recommended values, and interactions with other settings.

### 1. Movement Speed

- **Description**: Controls the base speed of the character's movement.
- **Why it exists**: To allow developers to define how fast the character can move in the game world.
- **When to change it**: Adjust this value to fit the desired pace of your game.

- **Value Guidance**:
  - Default value: `movementSpeed = 5.0f`
  - Recommended range: `1.0f - 10.0f`
  - Examples:
    - Low value (2.0): "Slow-paced exploration"
    - Default value (5.0): "Balanced movement speed"
    - High value (8.0): "Fast-paced action"

- **Interaction Warnings**:
  - ⚠️ Affects: Jump height, acceleration
  - ⚠️ Don't change this if you also changed `acceleration`
  - ✅ Synergizes well with: `acceleration`

### 2. Jump Force

- **Description**: Determines the force applied when the character jumps.
- **Why it exists**: To control how high the character can jump, impacting gameplay dynamics.
- **When to change it**: Modify this for different jump heights based on game design.

- **Value Guidance**:
  - Default value: `jumpForce = 7.0f`
  - Recommended range: `5.0f - 15.0f`
  - Examples:
    - Low value (5.0): "Short jumps for platforming"
    - Default value (7.0): "Standard jump height"
    - High value (12.0): "High jumps for exploration"

- **Interaction Warnings**:
  - ⚠️ Affects: Gravity, movement speed
  - ⚠️ Don't change this if you also changed `gravityScale`
  - ✅ Synergizes well with: `gravityScale`

### 3. Gravity Scale

- **Description**: Modifies the effect of gravity on the character.
- **Why it exists**: To allow for different gravity effects, enhancing gameplay feel.
- **When to change it**: Adjust for different game styles, such as low-gravity environments.

- **Value Guidance**:
  - Default value: `gravityScale = 1.0f`
  - Recommended range: `0.5f - 2.0f`
  - Examples:
    - Low value (0.5): "Low gravity for floaty jumps"
    - Default value (1.0): "Normal gravity"
    - High value (1.5): "Increased gravity for realism"

- **Interaction Warnings**:
  - ⚠️ Affects: Jump force, fall speed
  - ⚠️ Don't change this if you also changed `jumpForce`
  - ✅ Synergizes well with: `fallSpeed`

### 4. Crouch Speed

- **Description**: Controls the speed at which the character can move while crouching.
- **Why it exists**: To provide a stealthy movement option for players.
- **When to change it**: Adjust for different gameplay styles, such as stealth mechanics.

- **Value Guidance**:
  - Default value: `crouchSpeed = 2.0f`
  - Recommended range: `1.0f - 4.0f`
  - Examples:
    - Low value (1.0): "Very slow crouch for stealth"
    - Default value (2.0): "Normal crouch speed"
    - High value (3.5): "Quick crouch for tactical gameplay"

- **Interaction Warnings**:
  - ⚠️ Affects: Overall movement speed
  - ⚠️ Don't change this if you also changed `movementSpeed`
  - ✅ Synergizes well with: `crouchConfig`

### 5. Slide Duration

- **Description**: Defines how long the character can slide after crouching.
- **Why it exists**: To create a dynamic movement option that enhances gameplay.
- **When to change it**: Adjust based on desired slide mechanics in your game.

- **Value Guidance**:
  - Default value: `slideDuration = 1.0f`
  - Recommended range: `0.5f - 2.0f`
  - Examples:
    - Low value (0.5): "Short slide for quick maneuvers"
    - Default value (1.0): "Standard slide duration"
    - High value (1.5): "Long slide for dramatic escapes"

- **Interaction Warnings**:
  - ⚠️ Affects: Crouch speed, player control during slides
  - ⚠️ Don't change this if you also changed `crouchSpeed`
  - ✅ Synergizes well with: `crouchConfig`

## Conclusion

This reference provides a detailed overview of the settings available in `MovementConfig.cs`. By understanding each parameter, you can effectively customize the movement mechanics of your game to achieve the desired player experience. For further assistance, refer to the other documentation files or the integration guide.