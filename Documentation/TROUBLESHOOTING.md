# TROUBLESHOOTING.md

## Common Issues and Solutions

### 1. Character Not Moving
**Issue:** The character does not respond to input and remains stationary.  
**Solution:** 
- Check if the `MovementController` script is attached to the character GameObject.
- Ensure that the input settings are correctly configured in Unity's Input Manager.
- Verify that the `MovementConfig` settings are properly set, especially the `movementSpeed` parameter.

### 2. Sliding Too Much or Not Enough
**Issue:** The character slides excessively or does not slide at all when crouching.  
**Solution:** 
- Adjust the `slideFriction` value in `CrouchConfig.cs`. A lower value will increase sliding, while a higher value will reduce it.
- Ensure that the `crouchSpeed` is set appropriately; if it's too high, the character may not slide effectively.

### 3. Jumping Issues
**Issue:** The character cannot jump or jumps inconsistently.  
**Solution:** 
- Check the `jumpForce` setting in `MovementConfig.cs`. Ensure it is set to a value that allows for adequate jumping height.
- Verify that the character's Rigidbody component is configured correctly, with appropriate mass and drag settings.

### 4. Character Clipping Through the Ground
**Issue:** The character clips through the ground when moving or jumping.  
**Solution:** 
- Ensure that the collider on the character is properly sized and positioned.
- Adjust the `groundCheckDistance` in `MovementConfig.cs` to ensure the character correctly detects the ground.

### 5. Animation Not Syncing with Movement
**Issue:** The character's animations do not match the movement speed or direction.  
**Solution:** 
- Check the Animator component and ensure that the parameters are correctly set up to respond to movement inputs.
- Verify that the `movementSpeed` in `MovementConfig.cs` is correctly linked to the animation parameters.

### 6. Input Not Recognized
**Issue:** The character does not respond to input commands.  
**Solution:** 
- Ensure that the input system is correctly set up in Unity. If using the new Input System, make sure the actions are properly mapped.
- Check if the `MovementController` script is enabled and not being overridden by another script.

### 7. Performance Issues
**Issue:** The game runs slowly or lags during movement.  
**Solution:** 
- Review the `MovementConfig` and `CrouchConfig` settings for any values that may be too high, causing performance overhead.
- Optimize the number of active GameObjects and ensure that unnecessary components are disabled.

### 8. Unexpected Character Behavior
**Issue:** The character behaves erratically or does not respond as expected.  
**Solution:** 
- Review all configuration settings in both `MovementConfig.cs` and `CrouchConfig.cs` for any conflicting values.
- Ensure that no other scripts are interfering with the movement logic.

## Additional Resources
For further assistance, please refer to the following documentation:
- [Movement Config Reference](MOVEMENT_CONFIG_REFERENCE.md)
- [Crouch Config Reference](CROUCH_CONFIG_REFERENCE.md)
- [Integration Guide](INTEGRATION_GUIDE.md)

If issues persist, consider reaching out to the community forums or submitting a bug report through the official channels.