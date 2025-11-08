# INTEGRATION_GUIDE.md

## Integration Guide for Movement and Crouch Systems

Welcome to the Integration Guide for the AAA Movement Controller package. This document aims to provide a comprehensive understanding of how the movement and crouch systems work together, ensuring a seamless experience when configuring your character's movement dynamics.

### Understanding the Interaction

The Movement Controller is designed to provide a cohesive experience between the movement and crouch systems. Each system has its own configuration settings, but they are interconnected in ways that can significantly affect gameplay. Below, we outline how these systems interact and provide guidance on configuring them for optimal performance.

### Key Interactions

1. **Movement Speed and Crouch Speed**
   - The `movementSpeed` setting in `MovementConfig` directly influences how fast the character moves while crouching. 
   - **Recommendation**: If you increase the `movementSpeed`, consider adjusting the `crouchSpeed` in `CrouchConfig` to maintain a balanced gameplay experience.

2. **Gravity and Jump Force**
   - The `gravity` setting in `MovementConfig` affects how quickly the character falls, which can impact the effectiveness of jumps during crouch transitions.
   - **Recommendation**: Ensure that the `jumpForce` is proportionate to the `gravity` value to achieve a natural jumping feel, especially when transitioning from a crouch.

3. **Crouch Duration and Movement Input**
   - The `crouchDuration` in `CrouchConfig` determines how long the character remains in a crouched state. This can affect the player's ability to move while crouched.
   - **Recommendation**: If you want a quick crouch and stand-up mechanic, keep the `crouchDuration` low, but ensure that the `movementSpeed` is also adjusted to allow for quick recovery.

### Configuration Examples

- **Scenario 1: Fast-paced Gameplay**
  - Set `movementSpeed = 3.0f` in `MovementConfig`.
  - Adjust `crouchSpeed = 2.5f` in `CrouchConfig` to maintain a quick crouch transition.

- **Scenario 2: Realistic Simulation**
  - Set `movementSpeed = 1.5f` in `MovementConfig`.
  - Set `crouchSpeed = 1.0f` in `CrouchConfig` to reflect a more realistic crouching behavior.

### Common Pitfalls

- **Changing Movement Speed Without Adjusting Crouch Speed**
  - ⚠️ **Warning**: If you increase `movementSpeed` without adjusting `crouchSpeed`, players may find it difficult to navigate tight spaces while crouched.
  - ✅ **Solution**: Always adjust both settings in tandem to maintain gameplay balance.

- **Inconsistent Gravity and Jump Force**
  - ⚠️ **Warning**: Setting a high `gravity` value while keeping a low `jumpForce` can lead to unrealistic jump mechanics.
  - ✅ **Solution**: Use a formula like `jumpForce = gravity * 0.5f` to ensure a balanced jump experience.

### Conclusion

By understanding the interactions between the movement and crouch systems, you can create a more cohesive and enjoyable gameplay experience. Always test your settings in various scenarios to ensure that they work well together, and don't hesitate to iterate on your configurations to find the perfect balance for your game.

For further details on specific settings, refer to the [MOVEMENT_CONFIG_REFERENCE.md](MOVEMENT_CONFIG_REFERENCE.md) and [CROUCH_CONFIG_REFERENCE.md](CROUCH_CONFIG_REFERENCE.md) documents. Happy developing!