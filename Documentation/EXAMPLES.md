# EXAMPLES.md

## Practical Use Cases for the Movement Controller

This document provides practical examples and scenarios to help you understand how to configure the Movement Controller to achieve specific gameplay mechanics and feels. Each example outlines the desired outcome, the relevant settings to adjust, and the recommended values to use.

### Example 1: Platformer Feel

**Desired Outcome:** You want your game to feel like a classic platformer, with responsive jumps and smooth movement.

**Recommended Settings:**
- `movementSpeed = 5.0f` 
  - **Description:** Controls how fast the character moves horizontally.
  - **Why:** A moderate speed allows for quick reactions while maintaining control.
  
- `jumpForce = 10.0f`
  - **Description:** The force applied when the character jumps.
  - **Why:** A higher jump force gives players the ability to reach platforms easily.

- `gravityScale = 2.0f`
  - **Description:** Adjusts the gravity affecting the character.
  - **Why:** Increased gravity makes jumps feel more controlled and less floaty.

### Example 2: Realistic Simulation

**Desired Outcome:** You want a more realistic movement feel, similar to a simulation game.

**Recommended Settings:**
- `movementSpeed = 2.0f`
  - **Description:** Slower movement speed for a more realistic pace.
  
- `jumpForce = 5.0f`
  - **Description:** Lower jump force to simulate realistic jumping mechanics.
  
- `gravityScale = 1.0f`
  - **Description:** Standard gravity for a natural falling speed.

### Example 3: Fast-Paced Shooter

**Desired Outcome:** You want a fast-paced shooter feel, with quick movements and agile jumps.

**Recommended Settings:**
- `movementSpeed = 8.0f`
  - **Description:** High speed for rapid movement across the map.
  
- `jumpForce = 12.0f`
  - **Description:** Strong jump force to allow for quick vertical movements.
  
- `gravityScale = 1.5f`
  - **Description:** Slightly increased gravity to keep jumps from feeling too floaty.

### Example 4: Crouch and Slide Mechanics

**Desired Outcome:** You want to implement advanced crouch and slide mechanics for stealth gameplay.

**Recommended Settings:**
- **CrouchConfig:**
  - `crouchSpeed = 2.0f`
    - **Description:** Speed while crouching.
    - **Why:** Slower speed encourages stealth gameplay.
  
  - `slideDuration = 0.5f`
    - **Description:** How long the slide lasts.
    - **Why:** A short slide duration keeps the action fast-paced.

  - `slideSpeed = 6.0f`
    - **Description:** Speed during the slide.
    - **Why:** A moderate speed allows for quick escapes while maintaining control.

### Example 5: Customizing for Player Feedback

**Desired Outcome:** You want to tweak settings based on player feedback to improve gameplay.

**Recommended Approach:**
- Gather player feedback on movement feel.
- Adjust `movementSpeed`, `jumpForce`, and `gravityScale` based on common suggestions.
- Test changes iteratively to find the best balance.

### Conclusion

These examples serve as a starting point for configuring the Movement Controller to fit your game's needs. Feel free to experiment with the values provided and adjust them according to your specific gameplay requirements. Remember, the key to a great player experience is in the fine-tuning of these settings!